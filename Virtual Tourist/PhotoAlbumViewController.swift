//
//  PhotoAlbumViewController.swift
//  Virtual Tourist
//
//  Created by Dylan Edwards on 8/26/16.
//  Copyright © 2016 Slinging Pixels Media. All rights reserved.
//

import UIKit
import MapKit

class PhotoAlbumViewController: UIViewController {

    private var photoAlbumView: PhotoAlbumView!
    private var pin: Pin!
//    fileprivate var locationTitle = ""
//    fileprivate var coordinate: CLLocationCoordinate2D!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = pin.title!
        
        let navController = navigationController! as! NavigationController
        navController.setNavigationBarAttributes(isAppTitle: false)
        
        photoAlbumView = view as! PhotoAlbumView
        
        photoAlbumView.configure(withPin: pin)
    }

//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        
//        photoAlbumView.layoutCollectionView()
//    }
    
    //MARK: - Configuration
    
    internal func configure(withPin pin: Pin) {
        self.pin = pin
//        locationTitle   = pin.title!
//        coordinate      = CLLocationCoordinate2D(latitude: pin.latitude, longitude: pin.longitude)
    }

}
