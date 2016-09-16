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

    fileprivate var photoAlbumView: PhotoAlbumView!
    fileprivate var locationTitle = ""
    fileprivate var coordinate: CLLocationCoordinate2D!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = locationTitle
        
        let navController = navigationController! as! NavigationController
        navController.setNavigationBarAttributes(isAppTitle: false)
        
        photoAlbumView = view as! PhotoAlbumView
        
        photoAlbumView.configure(withTitle: locationTitle, coordinate: coordinate)
    }

    
    
    //MARK: - Configuration
    
    internal func configure(withTitle title: String, coordinate coord: CLLocationCoordinate2D) {
        locationTitle   = title
        coordinate      = coord
    }

}
