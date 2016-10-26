//
//  MapViewController.swift
//  Virtual Tourist
//
//  Created by Dylan Edwards on 8/17/16.
//  Copyright © 2016 Slinging Pixels Media. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, SegueHandlerType {
    
    enum SegueIdentifier: String {
        case openPhotoAlbum
    }
    
    private var mapContainerView: MapContainerView!
    
    private var locationTitle = ""
    private var coordinate: CLLocationCoordinate2D!
    private var selectedPin: Pin!
    
    private let stateMachine = MapViewStateMachine()
    
    private var navController: MapViewNavigationController!
    
    //MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navController       = navigationController! as! MapViewNavigationController
        mapContainerView    = view as! MapContainerView
        
        let openAlbumClosure = { [unowned self] (pin: Pin) in
            self.selectedPin = pin
            self.performSegueWithIdentifier(.openPhotoAlbum, sender: self)
        }
        
        let presentAlertClosure = { [unowned self] (annotation: MapLocationAnnotation) in
            let alert = UIAlertController(
                title: LocalizedStrings.NoPhotosFoundAlert.title,
                message: LocalizedStrings.NoPhotosFoundAlert.message,
                preferredStyle: .alert)
            
            let deleteClosure = { [unowned self] (alert: UIAlertAction) in
                self.mapContainerView.deletePinForAnnotation(annotation)
            }
            
            alert.addAction(UIAlertAction(title: LocalizedStrings.NoPhotosFoundAlert.deleteButton, style: .destructive, handler: deleteClosure))
            alert.addAction(UIAlertAction(title: LocalizedStrings.NoPhotosFoundAlert.keepButton, style: .default, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
            
        }
        
        mapContainerView.configure(withOpenAlbumClosure: openAlbumClosure, mapViewStateMachine: stateMachine, alertPresentationClosure: presentAlertClosure)
        
        configureNavigationController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        configureNavigationController()
    }

    //MARK: - Configuration
    
    private func configureNavigationController() {
        navigationItem.title = LocalizedStrings.ViewControllerTitles.virtualTourist
        
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

