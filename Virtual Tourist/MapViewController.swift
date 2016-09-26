//
//  MapViewController.swift
//  Virtual Tourist
//
//  Created by Dylan Edwards on 8/17/16.
//  Copyright © 2016 Slinging Pixels Media. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class MapViewController: UIViewController, SegueHandlerType {
//    internal var overlayTransitioningDelegate: OverlayTransitioningDelegate?
    /**
     Admittedly this is silly for a single segue, but I want to standardize the
     segue presentation process for all apps using SegueHandlerType protocol
     */
    enum SegueIdentifier: String {
        case OpenPhotoAlbum
    }
    
    fileprivate var mapContainerView: MapContainerView!
    
    fileprivate var locationTitle = ""
    fileprivate var coordinate: CLLocationCoordinate2D!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapContainerView = view as! MapContainerView
        mapContainerView.configure(withOpenAlbumClosure: { [unowned self] (title, coordinate) in
            self.locationTitle  = title
            self.coordinate     = coordinate
            self.performSegueWithIdentifier(.OpenPhotoAlbum, sender: self)
        })
        
        configureNavigationController()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK: - Configuration
    
    fileprivate func configureNavigationController() {
        navigationItem.title = LocalizedStrings.ViewControllerTitles.virtualTourist
        
        let navController = navigationController! as! NavigationController
        navController.setNavigationBarAttributes(isAppTitle: true)
    }
    
    
    //MARK: - Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        /// Overkill for this situation, but would be useful for multiple seques
        switch segueIdentifierForSegue(segue) {
        case .OpenPhotoAlbum:
            
//            /// Get photos for the location
//            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Photo")
//            
//            let indexPath = tableView.indexPathForSelectedRow!
//            let pin = fetchedResultsController?.objectAtIndexPath(indexPath) as? Pin
//            
//            
//            let pred = NSPredicate(format: "notebook = %@", argumentArray: [notebook!])
//            
//            fetchRequest.predicate = pred
//            
//            // Create FetchedResultsController
//            let fc = NSFetchedResultsController(fetchRequest: fetchRequest,
//                                                managedObjectContext:fetchedResultsController!.managedObjectContext,
//                                                sectionNameKeyPath: "humanReadableAge",
//                                                cacheName: nil)
//            
//            // Inject it into the notesVC
//            notesVC.fetchedResultsController = fc
//            
//            // Inject the notebook too!
//            notesVC.notebook = notebook
            
            
            
            
            /// Setup
            let vc = segue.destination as? PhotoAlbumViewController
            
            vc?.configure(withTitle: locationTitle, coordinate: coordinate)
//            mainTabBarController = segue.destinationViewController as? TabBarController
        }
    }
    
}

