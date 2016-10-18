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
    private var pin: Pin!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = pin.title!
        
        let navController = navigationController! as! NavigationController
        navController.setNavigationBarAttributes(isAppTitle: false)
        
        photoAlbumView = view as! PhotoAlbumView
        
        photoAlbumView.configure(withPin: pin)
    }
    
    //MARK: - Configuration
    
    internal func configure(withPin pin: Pin) {
        self.pin = pin
    }

}

extension PhotoAlbumViewController {
    /** Resize cells upon rotation */
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        photoAlbumView.layoutCollectionView()
    }
}

