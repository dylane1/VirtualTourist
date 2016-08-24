//
//  StudentLocationMapContainerView.swift
//  On The Map
//
//  Created by Dylan Edwards on 6/16/16.
//  Copyright © 2016 Slinging Pixels Media. All rights reserved.
//

import MapKit
import UIKit

class MapContainerView: UIView {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var mapView: MKMapView!
    
    /// Use a preloaded image until map is renedered so user doesn't see empty map area
//    @IBOutlet weak var preloadedMapImage: UIImageView!
    private var mapRendered = false
    
//    private lazy var studentInfoProvider = StudentInformationProvider.sharedInstance
    
//    private var annotations = [StudentLocationAnnotation]()
//    
    private var openPhotoAlbum: (() -> Void)!
//
    private var animatedPinsIn = false
    
    //MARK: - View Lifecycle
    
    override func didMoveToWindow() {
        mapView.delegate = self
//        configureMapImage()
        configureActivityIndicator()
        configureLongPressGestureRecognizer()
        
    }
    
    //MARK: - Configuration
    private func configureActivityIndicator() {
        activityIndicator.activityIndicatorViewStyle = .WhiteLarge
        activityIndicator.color = Theme.activityIndicatorCircle1
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
    }
    
    private func configureLongPressGestureRecognizer() {
        let gestureRecognizer = UILongPressGestureRecognizer()
        gestureRecognizer.addTarget(self, action: #selector(hangleLongPress(_:)))
        
        gestureRecognizer.minimumPressDuration = 0.5
        
        mapView.addGestureRecognizer(gestureRecognizer)
    }
    
    internal func configure(withOpenAlbumClosure closure: () -> Void) {
        openPhotoAlbum = closure
        
        activityIndicator.startAnimating()
        
        /// clear for refresh
//        clearAnnotations()
        
        animatedPinsIn = false
        
//        if mapRendered {
//            placeAnnotations()
//        }
    }
    
    /**
     Show a map image on top of map view while it loads so the user doesn't
     see a blank map area
     */
//    private func configureMapImage() {
//        preloadedMapImage.alpha = 0.0
//        
//        if !mapRendered {
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
//            preloadedMapImage.alpha = 1.0
//        }
//        
//        activityIndicator.color = UIColor.ceSoir()
//        activityIndicator.startAnimating()
//    }
    
    //MARK: - 
    internal func hangleLongPress(gestureRecognizer: UIGestureRecognizer) {
        switch gestureRecognizer.state {
        case .Began:
            addAnnotation(gestureRecognizer)
            break
        default:
            ///Ended
            break
        }
    }
    
    
    //MARK: - Map View
    private func addAnnotation(gestureRecognizer: UIGestureRecognizer) {
        let location = gestureRecognizer.locationInView(mapView)
        let coordinate = mapView.convertPoint(location, toCoordinateFromView: mapView)
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        mapView.addAnnotation(annotation)
        
//        CLGeocoder().reverseGeocodeLocation(CLLocation(latitude: newCoordinates.latitude, longitude: newCoordinates.longitude), completionHandler: { (placemarks, error) -> Void in
//            if error != nil {
//                print("Reverse geocoder failed with error" + error!.localizedDescription)
//                return
//            }
//            
//            if placemarks.count > 0 {
//                let pm = placemarks[0] as! CLPlacemark
//                
//                // not all places have thoroughfare & subThoroughfare so validate those values
//                annotation.title = pm.thoroughfare + ", " + pm.subThoroughfare
//                annotation.subtitle = pm.subLocality
//                self.map.addAnnotation(annotation)
//                println(pm)
//            }
//            else {
//                annotation.title = "Unknown Place"
//                self.map.addAnnotation(annotation)
//                println("Problem with the data received from geocoder")
//            }
//            places.append(["name":annotation.title,"latitude":"\(newCoordinates.latitude)","longitude":"\(newCoordinates.longitude)"])
//        })
    }
    
    private func placeAnnotations() {
        
//        for item in studentInfoProvider.studentInformationArray! {
//            let annotation = StudentLocationAnnotation(title: (item.firstName + " " + item.lastName), mediaURL: item.mediaURL,locationName: item.mapString, coordinate: CLLocationCoordinate2D(latitude: item.latitude, longitude: item.longitude))
//            annotations.append(annotation)
//        }
//        
//        mapView.addAnnotations(annotations)
        activityIndicator.stopAnimating()
    }
    
//    internal func clearAnnotations() {
//        if annotations.count > 0 {
//            mapView.removeAnnotations(annotations)
//            annotations.removeAll()
//        }
//    }
    
//    private func animateAnnotationsWithAnnotationArray(views: [MKAnnotationView]) {
//        for annotation in views {
//            let endFrame = annotation.frame
//            annotation.frame = CGRectOffset(endFrame, 0, -500)
//            let duration = 0.3
//            
//            UIView.animateWithDuration(duration, animations: {
//                annotation.frame = endFrame
//            })
//        }
//        animatedPinsIn = true
//    }
}

extension MapContainerView: MKMapViewDelegate {
    
    func mapViewDidFinishRenderingMap(mapView: MKMapView, fullyRendered: Bool) {
        if mapRendered { return }
        mapRendered = true
//        preloadedMapImage.alpha = 0.0
        placeAnnotations()
    }

    
//    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
//        
////        if let annotation = annotation as? StudentLocationAnnotation {
//            var pinView: MKAnnotationView
//            if let dequeuedView = mapView.dequeueReusableAnnotationViewWithIdentifier(MKAnnotationView.reuseIdentifier) as MKAnnotationView! {
//                
//                dequeuedView.annotation = annotation
//                pinView = dequeuedView
//            } else {
//                pinView = MKAnnotationView(annotation: annotation, reuseIdentifier: MKAnnotationView.reuseIdentifier)
//                pinView.canShowCallout = true
//                pinView.calloutOffset = CGPoint(x: -5, y: 5)
////                pinView.image = IconProvider.imageOfDrawnIcon(.Annotation, size: CGSize(width: 15, height: 15))
//                pinView.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure) as UIView
//            }
//        print(pinView.annotation?.coordinate)
//        return pinView
////        }
////        return nil
//    }
    
//    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
//        let annotation = view.annotation// as! StudentLocationAnnotation
////        openLinkClosure?(annotation.mediaURL)
//        openPhotoAlbum()
//    }
    
//    func mapView(mapView: MKMapView, didAddAnnotationViews views: [MKAnnotationView]) {
//        if !animatedPinsIn {
//            animateAnnotationsWithAnnotationArray(views)
//        }
//        
//    }
}
