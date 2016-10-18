//
//  CoreDataStack.swift
//  Virtual Tourist
//
//  Created by Dylan Edwards on 9/20/16.
//  Copyright © 2016 Slinging Pixels Media. All rights reserved.
//

import Foundation
import CoreData

struct CoreDataStack {
    
    // MARK: Properties
    
    private let model: NSManagedObjectModel
    fileprivate let coordinator: NSPersistentStoreCoordinator
    fileprivate let persistingContext: NSManagedObjectContext
    fileprivate let backgroundContext: NSManagedObjectContext
    private let modelURL: URL
    fileprivate let storeURL: URL
    
    internal let context: NSManagedObjectContext
    
    
    
    // MARK: Initializers
    
    init?(modelName: String) {
        
        /// Assumes the model is in the main bundle
        guard let modURL = Bundle.main.url(forResource: modelName, withExtension: "momd") else {
            magic("Unable to find \(modelName)in the main bundle")
            return nil
        }
        modelURL = modURL
        
        // Try to create the model from the URL
        guard let mod = NSManagedObjectModel(contentsOf: modelURL) else {
            magic("Unable to create a model from \(modelURL)")
            return nil
        }
        model = mod
        
        /// Create the store coordinator
        coordinator = NSPersistentStoreCoordinator(managedObjectModel: model)
        
        /// Create a persistingContext (private queue) -- fileprivate
        persistingContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        persistingContext.persistentStoreCoordinator = coordinator
        
        /// Create a child context (main queue) -- internal
        context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        context.parent = persistingContext
        
        /// Create a background context child of main context -- fileprivate
        backgroundContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        backgroundContext.parent = context
        
        /// Add a SQLite store located in the documents folder
        let fileManager = FileManager.default
        
        guard let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            magic("Unable to reach the documents folder")
            return nil
        }
        
        storeURL = documentsURL.appendingPathComponent("model.sqlite")
        
        /// Options for migration
        let options = [NSInferMappingModelAutomaticallyOption: true,NSMigratePersistentStoresAutomaticallyOption: true]
        
        do {
            try addStoreCoordinator(NSSQLiteStoreType, configuration: nil, storeURL: storeURL, options: options as [NSObject : AnyObject]?)
        } catch {
            magic("Unable to add store at \(storeURL)")
        }
    }
    
    // MARK: Utils
    
    func addStoreCoordinator(_ storeType: String, configuration: String?, storeURL store: URL, options : [NSObject:AnyObject]?) throws {
        try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: store, options: options)
    }
}

// MARK: - CoreDataStack (Removing Data)

internal extension CoreDataStack  {
    
    func dropAllData() throws {
        /** 
         * Delete all the objects in the db. This won't delete the files, it will
         * just leave empty tables.
         */
        try coordinator.destroyPersistentStore(at: storeURL, ofType: NSSQLiteStoreType , options: nil)
        try addStoreCoordinator(NSSQLiteStoreType, configuration: nil, storeURL: storeURL, options: nil)
    }
}

// MARK: - CoreDataStack (Batch Processing in the Background)

extension CoreDataStack {
    
    typealias Batch = (_ workerContext: NSManagedObjectContext) -> ()
    
    func performBackgroundBatchOperation(_ batch: @escaping Batch) {
        
        backgroundContext.perform() {
            
            batch(self.backgroundContext)
            
            /// Save it to the parent context, so normal saving can work
            do {
                try self.backgroundContext.save()
            } catch {
                fatalError("Error while saving backgroundContext: \(error)")
            }
        }
    }
}

// MARK: - CoreDataStack (Save Data)

extension CoreDataStack {
    
    func save() {
        /** 
         *  We call this synchronously, but it's a very fast operation (it
         *  doesn't hit the disk). We need to know when it ends so we can call 
         *  the next save (on the persisting context). This last one might take 
         *  some time and is done in a background queue
         */
        context.performAndWait() {
            
            if self.context.hasChanges {
                do {
                    try self.context.save()
                } catch {
                    fatalError("Error while saving main context: \(error)")
                }
                
                // now we save in the background
                self.persistingContext.perform() {
                    do {
                        try self.persistingContext.save()
                    } catch {
                        fatalError("Error while saving persisting context: \(error)")
                    }
                }
            }
        }
    }
    
    func autoSave(delayInSeconds seconds: Int) {
        
        if seconds > 0 {
            do {
                try self.context.save()
            } catch {
                magic("Error while autosaving")
            }
            
            let delayInNanoSeconds = UInt64(seconds) * NSEC_PER_SEC
            let time = DispatchTime.now() + Double(Int64(delayInNanoSeconds)) / Double(NSEC_PER_SEC)
            
            DispatchQueue.main.asyncAfter(deadline: time) {
                self.autoSave(delayInSeconds: seconds)
            }
        }
    }
}















