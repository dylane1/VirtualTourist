//
//  MapViewController.swift
//  Virtual Tourist
//
//  Created by Dylan Edwards on 8/17/16.
//  Copyright © 2016 Slinging Pixels Media. All rights reserved.
//

import UIKit
//import CustomPresentation

class MapViewController: UIViewController, SegueHandlerType {
//    internal var overlayTransitioningDelegate: OverlayTransitioningDelegate?
    /**
     Admittedly this is silly for a single segue, but I want to standardize the
     segue presentation process for all apps using SegueHandlerType protocol
     */
    enum SegueIdentifier: String {
        case LoginComplete
    }
    
    private var mapContainerView: MapContainerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapContainerView = view as! MapContainerView
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

