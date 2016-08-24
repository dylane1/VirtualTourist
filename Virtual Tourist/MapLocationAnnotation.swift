//
//  StudentLocationAnnotation.swift
//  On The Map
//
//  Created by Dylan Edwards on 6/16/16.
//  Copyright © 2016 Slinging Pixels Media. All rights reserved.
//

import MapKit
import Foundation

final class MapLocationAnnotation: NSObject, MKAnnotation, ReusableView {
    internal let title: String?
    internal let mediaURL: String
    internal let locationName: String
    internal let coordinate: CLLocationCoordinate2D
    
    internal var subtitle: String? {
        return mediaURL
    }
    
    init(title: String, mediaURL: String, locationName: String, coordinate: CLLocationCoordinate2D) {
        self.title          = title
        self.mediaURL       = mediaURL
        self.locationName   = locationName
        self.coordinate     = coordinate
        
        super.init()
    }
}
