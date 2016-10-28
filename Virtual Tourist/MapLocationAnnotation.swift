//
//  StudentLocationAnnotation.swift
//  Virtual Tourist
//
//  Created by Dylan Edwards on 6/16/16.
//  Copyright © 2016 Slinging Pixels Media. All rights reserved.
//

import MapKit
import Foundation

final class MapLocationAnnotation: NSObject, MKAnnotation {
    
    internal var title: String? = ""
    internal var pin: Pin!
    internal var isSelected = false
    
    /// coordiante must me 'dynamic' in order to update the location Virtual Tourist
    internal dynamic var coordinate = CLLocationCoordinate2D()
}
