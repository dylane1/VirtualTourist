//
//  StudentLocationMapContainerView.swift
//  On The Map
//
//  Created by Dylan Edwards on 6/16/16.
//  Copyright © 2016 Slinging Pixels Media. All rights reserved.
//

import MapKit
import UIKit
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


class MapContainerView: UIView {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var mapView: MKMapView!
    
    //TODO: 
    /**
     1. Look for previously saved screenshot & load it, if one exists.
     2. Clear set alpha to 0 when map tiles load.
     3. Take a snapshot of map before exiting (going to photo album, or leaving app)
     4. Save it to core data (replacing old)
     
     Considerations: 
     
     - What do do if user is in landscape mode? App will not open in landscape,
       unless it's an iPhone 6 plus. (probably just don't save?)
         - Can an user leave & return to an app in landscape mode if the app isn't closed?
    */
    /// Use a preloaded image until map is renedered so user doesn't see empty map area
    @IBOutlet weak var preloadedMapImage: UIImageView!
    
    
    fileprivate var mapRendered = false
    
//    private lazy var studentInfoProvider = StudentInformationProvider.sharedInstance
    
    fileprivate var draggableAnnotation: MapLocationAnnotation?
    fileprivate var annotations = [MapLocationAnnotation]()
    fileprivate var placemarks: [CLPlacemark]?
    
    fileprivate var openPhotoAlbum: ((String, CLLocationCoordinate2D) -> Void)!
//
    fileprivate var animatedPinsIn = false
    
    //MARK: - View Lifecycle
    
    override func didMoveToWindow() {
        mapView.delegate = self
//        configureMapImage()
        configureActivityIndicator()
        configureLongPressGestureRecognizer()
        configurePanGestureRecognizer()
    }
    
    //MARK: - Configuration
    fileprivate func configureActivityIndicator() {
        activityIndicator.activityIndicatorViewStyle = .whiteLarge
        activityIndicator.color = Theme.activityIndicatorCircle1
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
    }
    
    /**
     Show a map image on top of map view while it loads so the user doesn't
     see a blank map area
     */
    fileprivate func configureMapImage() {
        preloadedMapImage.alpha = 0.0
        
        if !mapRendered {
            //TODO: Load image from core data
            
            
//            /// Need to determine map size & load correct image accordingly
//            switch Constants.screenHeight {
//            case Constants.DeviceScreenHeight.iPhone4s:
//                preloadedMapImage.image = UIImage(assetIdentifier: .Map_iPhone4s)
//            case Constants.DeviceScreenHeight.iPhone5:
//                preloadedMapImage.image = UIImage(assetIdentifier: .Map_iPhone5)
//            case Constants.DeviceScreenHeight.iPhone6:
//                preloadedMapImage.image = UIImage(assetIdentifier: .Map_iPhone6)
//            default:
//                /// iPhone6Plus
//                preloadedMapImage.image = UIImage(assetIdentifier: .Map_iPhone6Plus)
//            }
            preloadedMapImage.alpha = 1.0
        }
        
//        activityIndicator.color = UIColor.ceSoir()
//        activityIndicator.startAnimating()
    }
    
    fileprivate func configureLongPressGestureRecognizer() {
        let gestureRecognizer = UILongPressGestureRecognizer()
        gestureRecognizer.addTarget(self, action: #selector(hangleLongPress(_:)))
        
        gestureRecognizer.minimumPressDuration = 0.5
        gestureRecognizer.allowableMovement     = 1000 // just set to huge number for now
        mapView.addGestureRecognizer(gestureRecognizer)
    }
    
    fileprivate func configurePanGestureRecognizer() {
        let panGestureRecognizer = UIPanGestureRecognizer()
        panGestureRecognizer.addTarget(self, action: #selector(handlePanGesture(_:)))
        panGestureRecognizer.delegate = self
        
        mapView.addGestureRecognizer(panGestureRecognizer)
    }
    
    internal func configure(withOpenAlbumClosure closure: @escaping (String, CLLocationCoordinate2D) -> Void) {
        openPhotoAlbum = closure
        
        activityIndicator.startAnimating()
    }
    
    
    
    
    
    
    //MARK: - 
    internal func hangleLongPress(_ gestureRecognizer: UIGestureRecognizer) {
        switch gestureRecognizer.state {
        case .began:
            mapView.isScrollEnabled = false
            addAnnotation(gestureRecognizer)
        case .ended:
            mapView.isScrollEnabled = true
            getAnnotationLocationName()
        default:
            ///Changed
            break
        }
    }
    
    internal func handlePanGesture(_ gestureRecognizer: UIPanGestureRecognizer) {
//        magic("")
        if draggableAnnotation != nil {
            let location = gestureRecognizer.location(in: mapView)
            let coordinate = mapView.convert(location, toCoordinateFrom: mapView)
            draggableAnnotation!.coordinate = coordinate
            
        }
    }
    
    //MARK: - Map View
    
    fileprivate func placeAnnotations() {
        //TODO: Get annotations from Core Data
        
//        for item in studentInfoProvider.studentInformationArray! {
//            let annotation = MapLocationAnnotation(locationName: item.mapString, coordinate: CLLocationCoordinate2D(latitude: item.latitude, longitude: item.longitude))
//            annotations.append(annotation)
//        }

        mapView.addAnnotations(annotations)
        
        activityIndicator.stopAnimating()
    }
    
    
    
    fileprivate func addAnnotation(_ gestureRecognizer: UIGestureRecognizer) {
        let location = gestureRecognizer.location(in: mapView)
        let coordinate = mapView.convert(location, toCoordinateFrom: mapView)
        let annotation = MapLocationAnnotation()
        annotation.coordinate = coordinate

        annotations.append(annotation)
        mapView.addAnnotation(annotation)
        
        draggableAnnotation = annotation
    }
    
//    internal func clearAnnotations() {
//        if annotations.count > 0 {
//            mapView.removeAnnotations(annotations)
//            annotations.removeAll()
//        }
//    }
    
    fileprivate func getAnnotationLocationName() {
        CLGeocoder().reverseGeocodeLocation(CLLocation(latitude: draggableAnnotation!.coordinate.latitude, longitude: draggableAnnotation!.coordinate.longitude), completionHandler: { (placemarks: [CLPlacemark]?, error: Error?) -> Void in
            
            if error != nil {
                print("Reverse geocoder failed with error" + error!.localizedDescription)
                return
            }
            
            if placemarks?.count > 0 {
                let pm = placemarks![0]
                
                var title = ""
                
                /// Go through in descending order of importance (IMO)
                if pm.areasOfInterest != nil {
                    /// Just go with first one, if there are multiple...
                    title = pm.areasOfInterest![0]
                } else if pm.locality != nil {
                    /// The city
                    title = pm.locality!
                } else if pm.administrativeArea != nil {
                    /// The state
                    title = pm.administrativeArea!
                } else {
                    //TODO: localized
                    title = "Unknown Place"
                }
                
                self.draggableAnnotation!.title = title
            }
            else {
                self.draggableAnnotation!.title = "Unknown Place"
                print("Problem with the data received from geocoder")
            }
        })
    }
    
    fileprivate func animateAnnotationsWithAnnotationArray(_ views: [MKAnnotationView]) {
        for annotation in views {
            let endFrame = annotation.frame
            annotation.frame = endFrame.offsetBy(dx: 0, dy: -500)
            let duration = 0.3
            
            UIView.animate(withDuration: duration, animations: {
                annotation.frame = endFrame
            })
        }
        animatedPinsIn = true
    }
}

extension MapContainerView: MKMapViewDelegate {
    
    func mapViewDidFinishRenderingMap(_ mapView: MKMapView, fullyRendered: Bool) {
        if mapRendered { return }
        mapRendered = true
//        preloadedMapImage.alpha = 0.0
        placeAnnotations()
    }

//    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
//        magic("")
//    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if let annotation = annotation as? MapLocationAnnotation {
            var pinView: MKPinAnnotationView
            if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: MKPinAnnotationView.reuseIdentifier) as! MKPinAnnotationView! {
                
                dequeuedView.annotation = annotation
                pinView = dequeuedView
            } else {
                pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: MKPinAnnotationView.reuseIdentifier)
                pinView.canShowCallout = true
                pinView.calloutOffset = CGPoint(x: -7, y: 5)
                pinView.animatesDrop = true
                
//                pinView.image = IconProvider.imageOfDrawnIcon(.Annotation, size: CGSize(width: 15, height: 15))
                pinView.rightCalloutAccessoryView = UIButton(type: .detailDisclosure) as UIView
            }
            print(pinView.annotation?.coordinate)
            return pinView
        }
        return nil
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let annotation = view.annotation as! MapLocationAnnotation
//        openLinkClosure?(annotation.mediaURL)
        openPhotoAlbum(annotation.title!, annotation.coordinate)
    }
    
    func mapView(_ mapView: MKMapView, didAdd views: [MKAnnotationView]) {
        if !animatedPinsIn {
            animateAnnotationsWithAnnotationArray(views)
        }
        
    }
}

extension MapContainerView: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        // We only allow the (drag) gesture to continue if it is within a long press
        if((gestureRecognizer is UIPanGestureRecognizer) && mapView.isScrollEnabled) {
            return false
        }
        return true
    }
}





































