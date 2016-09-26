//
//  Pin+CoreDataClass.swift
//  Virtual Tourist
//
//  Created by Dylan Edwards on 9/20/16.
//  Copyright © 2016 Slinging Pixels Media. All rights reserved.
//

import Foundation
import CoreData


public class Pin: NSManagedObject {
    
    convenience init(withTitle title: String = "A Pin", latitude: Double, longitude: Double, context: NSManagedObjectContext) {
        if let ent = NSEntityDescription.entity(forEntityName: "Pin", in: context) {
            self.init(entity: ent, insertInto: context)
            
            self.title      = title
            self.latitude   = latitude
            self.longitude  = longitude
            
            return
        }
        fatalError("Could not initialize Pin")
    }
}
