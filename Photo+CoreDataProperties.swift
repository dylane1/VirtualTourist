//
//  Photo+CoreDataProperties.swift
//  Virtual Tourist
//
//  Created by Dylan Edwards on 9/26/16.
//  Copyright © 2016 Slinging Pixels Media. All rights reserved.
//

import Foundation
import CoreData

extension Photo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Photo> {
        return NSFetchRequest<Photo>(entityName: "Photo");
    }

    @NSManaged public var imageData: NSData?
    @NSManaged public var title: String?
    @NSManaged public var id: Int16
    @NSManaged public var pin: Pin?

}
