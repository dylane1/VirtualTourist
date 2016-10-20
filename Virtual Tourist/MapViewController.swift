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
//    internal var overlayTransitioningDelegate: OverlayTransitioningDelegate?
    /**
     Admittedly this is silly for a single segue, but I want to standardize the
     segue presentation process for all apps using SegueHandlerType protocol
     */
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK: - Configuration
    
    private func configureNavigationController() {
        navigationItem.title = LocalizedStrings.ViewControllerTitles.virtualTourist
        
        let navController = navigationController! as! MapViewNavigationController
        navController.setNavigationBarAttributes(isAppTitle: true)
        
//        let deleteSelectedClosure = { (isSelecting: Bool) in
//            if isSelecting {
//                /// tell mapcontainerview to change tapped pin colors & keep a list
//            } else {
//                /// tell mapcontainerview to delete all selected pins
//            }
//        }
//        
//        let deleteAllClosure = {
//            magic("clear all")
//        }
        navController.configure(withStateMachine: stateMachine)
//        navController.configure(withDeleteSelected: deleteSelectedClosure, withDeleteAll: deleteAllClosure)
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

