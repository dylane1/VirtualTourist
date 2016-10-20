//
//  MapViewController.swift
//  Virtual Tourist
//
//  Created by Dylan Edwards on 8/17/16.
//  Copyright © 2016 Slinging Pixels Media. All rights reserved.
//

import UIKit
import MapKit
//import CoreData

class MapViewController: UIViewController, SegueHandlerType {
    
    enum SegueIdentifier: String {
        case openPhotoAlbum
    }
    
    private var mapContainerView: MapContainerView!
    
    private var locationTitle = ""
    private var coordinate: CLLocationCoordinate2D!
    private var selectedPin: Pin!
    
    private let stateMachine = MapViewStateMachine()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapContainerView = view as! MapContainerView
        
        let openAlbumClosure = { [unowned self] (pin: Pin) in
            self.selectedPin = pin
            self.performSegueWithIdentifier(.openPhotoAlbum, sender: self)
        }
        mapContainerView.configure(withOpenAlbumClosure: openAlbumClosure, mapViewStateMachine: stateMachine)
        
        configureNavigationController()
    }

    //MARK: - Configuration
    
    private func configureNavigationController() {
        navigationItem.title = LocalizedStrings.ViewControllerTitles.virtualTourist
        
        let navController = navigationController! as! MapViewNavigationController
        navController.setNavigationBarAttributes(isAppTitle: true)
        
        navController.configure(withStateMachine: stateMachine)
    }
    
    
    //MARK: - Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        /// Overkill for this situation, but would be useful for multiple seques
        switch segueIdentifierForSegue(segue) {
        case .openPhotoAlbum:
            

            /// Setup
            let photoAlbumVC = segue.destination as? PhotoAlbumViewController
            
            photoAlbumVC?.configure(withPin: selectedPin)

        }
    }
    
}

