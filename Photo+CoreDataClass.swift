//
//  Photo+CoreDataClass.swift
//  Virtual Tourist
//
//  Created by Dylan Edwards on 9/20/16.
//  Copyright © 2016 Slinging Pixels Media. All rights reserved.
//

import Foundation
import CoreData


public class Photo: NSManagedObject {
    convenience init(withId id: Int64, title: String = "A Photo", url: String, pin: Pin, context: NSManagedObjectContext) {
        
        if let ent = NSEntityDescription.entity(forEntityName: "Photo", in: context) {
            self.init(entity: ent, insertInto: context)
            
            self.id         = id
            self.title      = title
            self.url        = url
            self.pin        = pin
//            self.imageData  = imageData
            
            return
        }
        fatalError("Could not initialize Photo")
    }
}
