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
    @IBOutlet weak var photosCollectionView: PhotoAlbumCollectionView!
    @IBOutlet weak var toolbar: UIToolbar!

    private var pin: Pin!
//    fileprivate var coordinate: CLLocationCoordinate2D!
    
    /**
     Map View Constraints
     
     Want to set as a percentage of space avalable per device instead of fixed
     
     - Height is set for portrait layout
     - Width is set for landscape layout
     */
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var widthConstraint: NSLayoutConstraint!

    
    
    //MARK: - Configuration
    
    internal func configure(withPin pin: Pin) {
        magic("ok")
//        coordinate = pin.coordinate
        self.pin = pin
        
        heightConstraint.constant = bounds.height * 0.25
        widthConstraint.constant = bounds.height * 0.33
//        magic("coordinate: \(coordinate)")
        
        configureMapView()
        configureCollectionView()
        configureToolbar()
    }
    
    private func configureMapView() {
        let regionRadius        = CLLocationDistance(34000)
        let annotation          = MKPointAnnotation()
        annotation.coordinate   = CLLocationCoordinate2D(latitude: pin.latitude, longitude: pin.longitude)
        
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(annotation.coordinate, regionRadius * 2.0, regionRadius * 2.0)
        
        mapView.setRegion(coordinateRegion, animated: true)
        
        mapView.addAnnotation(annotation)
    }

    private func configureCollectionView() {
        photosCollectionView.configure(withPin: pin)
    }
    
    private func configureToolbar() {
        var toolbarItemArray = [UIBarButtonItem]()
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        
        toolbarItemArray.append(flexSpace)
        
        let albumButton = UIBarButtonItem(
            title: LocalizedStrings.ToolbarButtons.newCollection,
            style: .plain,
            target: self,
            action: #selector(newCollectionButtonTapped))
        
        toolbarItemArray.append(albumButton)
        
        toolbarItemArray.append(flexSpace)
        
        toolbar.setItems(toolbarItemArray, animated: false)
        
//        toolbar.barTintColor = Theme.darkBlue
        toolbar.tintColor    = Theme.navBarTitleColor
        toolbar.isTranslucent  = true
    }
    
    
    internal func newCollectionButtonTapped() {
        magic("oh yeah")
    }
    
    
}
