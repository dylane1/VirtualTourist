//
//  PhotoAlbumView.swift
//  Virtual Tourist
//
//  Created by Dylan Edwards on 8/26/16.
//  Copyright © 2016 Slinging Pixels Media. All rights reserved.
//

import UIKit
import MapKit

class PhotoAlbumView: UIView {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var photosCollectionView: UICollectionView!
    @IBOutlet weak var toolbar: UIToolbar!

    private var coordinate: CLLocationCoordinate2D!
    
    /**
     Map View Constraints
     
     Want to set as a percentage of space avalable per device instead of fixed
     
     - Height is set for portrait layout
     - Width is set for landscape layout
     */
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var widthConstraint: NSLayoutConstraint!

    
    
    //MARK: - Configuration
    
    internal func configure(withTitle title: String, coordinate coord: CLLocationCoordinate2D) {
        coordinate = coord
        heightConstraint.constant = bounds.height * 0.25
        widthConstraint.constant = bounds.height * 0.33
        magic("heightConstraint: \(heightConstraint); widthConstraint: \(widthConstraint)")
    }
    
    private func configureMapView() {
//        mapView.frame = CGRect(x: mapView.bounds.origin.x, y: 0, width: bounds.width, height: bounds.height)
//        let location            = placemarks?[0].location
//        let regionRadius        = CLLocationDistance(54000)
//        let coordinateRegion    = MKCoordinateRegionMakeWithDistance(location!.coordinate, regionRadius * 2.0, regionRadius * 2.0)
//        
//        mapView.setRegion(coordinateRegion, animated: true)
//        
//        let annotation          = MKPointAnnotation()
//        annotation.coordinate   = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
//        
//        mapView.addAnnotation(annotation)
    }

}
