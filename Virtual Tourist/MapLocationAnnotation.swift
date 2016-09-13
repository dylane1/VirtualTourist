//
//  StudentLocationAnnotation.swift
//  On The Map
//
//  Created by Dylan Edwards on 6/16/16.
//  Copyright © 2016 Slinging Pixels Media. All rights reserved.
//

import MapKit
import Foundation

final class MapLocationAnnotation: NSObject, MKAnnotation {
    internal var title: String? = ""
    
    /// coordiante must me 'dynamic' in order to update the location on the map
    internal dynamic var coordinate = CLLocationCoordinate2D()
    
    
}
