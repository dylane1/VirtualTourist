//
//  StudentLocationMapContainerView.swift
//  On The Map
//
//  Created by Dylan Edwards on 6/16/16.
//  Copyright © 2016 Slinging Pixels Media. All rights reserved.
//

import MapKit
import UIKit
import CoreData


class MapContainerView: UIView {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var mapView: MKMapView!
    
    //TODO: MAYBE -- landscape poses a problem
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
//    @IBOutlet weak var preloadedMapImage: UIImageView!
    
    private var state: MapState = .normalState {
        didSet {
            magic("just set state to: \(state)")
            //            updateButtonsEnabled()
        }
    }
    private var stateMachine: MapViewStateMachine! {
        didSet {
            stateMachine.state.bind {
                self.state = $0
            }
        }
    }
    
    fileprivate var mapRendered = false
    fileprivate var animatedPinsIn = false
    

    
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    private var stack: CoreDataStack!
    
    private var draggableAnnotation: MapLocationAnnotation?
    private var annotations = [MapLocationAnnotation]()
    private var pins = [Pin]()
    private var placemarks: [CLPlacemark]?
    
    fileprivate var pinsToDelete = [Pin]()
    
    fileprivate var openPhotoAlbum: ((Pin) -> Void)!
//
    
    
    //MARK: - View Lifecycle
    
    override func didMoveToWindow() {
        mapView.delegate = self
        
        configureActivityIndicator()
        configureMap()
        configureLongPressGestureRecognizer()
        configurePanGestureRecognizer()
        
        fetchFromCoreData()
    }
    
    //MARK: - Configuration
    
    internal func configure(withOpenAlbumClosure closure: @escaping (Pin) -> Void, mapViewStateMachine sm: MapViewStateMachine) {
        openPhotoAlbum  = closure
        stateMachine    = sm
        activityIndicator.startAnimating()
    }
    
    internal func configure(withStateMachine stateMachine: MapViewStateMachine) {
        self.stateMachine = stateMachine
    }
    
    private func configureActivityIndicator() {
        activityIndicator.activityIndicatorViewStyle = .whiteLarge
        activityIndicator.color = Theme.activityIndicatorCircle1
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
    }
    
    private func configureMap() {
        let lat         = Constants.userDefaults.double(forKey: Constants.StorageKeys.latitude)
        let lon         = Constants.userDefaults.double(forKey: Constants.StorageKeys.longitude)
        let latDelta    = Constants.userDefaults.double(forKey: Constants.StorageKeys.latitudeDelta)
        let lonDelta    = Constants.userDefaults.double(forKey: Constants.StorageKeys.longitudeDelta)
        
        if lat != 0.0 && lon != 0.0 {
            let center  = CLLocationCoordinate2D(latitude: lat, longitude: lon)
            let span    = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: lonDelta)
            let region  = MKCoordinateRegion(center: center, span: span)
            
            mapView.setRegion(region, animated: true)
        }
    }
    /**
     Show a map image on top of map view while it loads so the user doesn't
     see a blank map area
     
     This will need to be saved every time the user changes the map or goes to 
     a photo album. Is it really worth it? I suppose it depends on the performance
     hit.
     */
//    private func configureMapImage() {
//        preloadedMapImage.alpha = 0.0
//        
//        if !mapRendered {
//            //TODO: Load image from core data
//            
//            
////            /// Need to determine map size & load correct image accordingly
////            switch Constants.screenHeight {
////            case Constants.DeviceScreenHeight.iPhone4s:
////                preloadedMapImage.image = UIImage(assetIdentifier: .Map_iPhone4s)
////            case Constants.DeviceScreenHeight.iPhone5:
////                preloadedMapImage.image = UIImage(assetIdentifier: .Map_iPhone5)
////            case Constants.DeviceScreenHeight.iPhone6:
////                preloadedMapImage.image = UIImage(assetIdentifier: .Map_iPhone6)
////            default:
////                /// iPhone6Plus
////                preloadedMapImage.image = UIImage(assetIdentifier: .Map_iPhone6Plus)
////            }
//            preloadedMapImage.alpha = 1.0
//        }
    
//        activityIndicator.color = UIColor.ceSoir()
//        activityIndicator.startAnimating()
//    }
    
    private func configureLongPressGestureRecognizer() {
        let gestureRecognizer = UILongPressGestureRecognizer()
        gestureRecognizer.addTarget(self, action: #selector(hangleLongPress(_:)))
        
        gestureRecognizer.minimumPressDuration = 0.5
        gestureRecognizer.allowableMovement     = 1000 // just set to huge number for now
        mapView.addGestureRecognizer(gestureRecognizer)
    }
    
    private func configurePanGestureRecognizer() {
        let panGestureRecognizer = UIPanGestureRecognizer()
        panGestureRecognizer.addTarget(self, action: #selector(handlePanGesture(_:)))
        panGestureRecognizer.delegate = self
        
        mapView.addGestureRecognizer(panGestureRecognizer)
    }
    
    
    
    
    //MARK: - 
    
    private func fetchFromCoreData() {
        stack = appDelegate.stack
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Pin")
        
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        do {
            pins = try stack.context.fetch(request) as! [Pin]
//            magic("pins: \(pins.count)")
            placeAnnotations()
        } catch {
            magic("failed to fetch pins: \(error)")
        }
        
    }
    
    
    
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
        if draggableAnnotation != nil {
            let location = gestureRecognizer.location(in: mapView)
            let coordinate = mapView.convert(location, toCoordinateFrom: mapView)
            draggableAnnotation!.coordinate = coordinate
            
        }
    }
    
    //MARK: - Map View
    
    fileprivate func placeAnnotations() {
        if animatedPinsIn { return }
        
        for pin in pins {
            let annotation = MapLocationAnnotation()
            annotation.title = pin.title
            annotation.pin = pin
            annotation.coordinate = CLLocationCoordinate2D(latitude: pin.latitude, longitude: pin.longitude)
            annotations.append(annotation)
        }

        mapView.addAnnotations(annotations)
        animatedPinsIn = true
        activityIndicator.stopAnimating()
    }
    
    
    
    private func addAnnotation(_ gestureRecognizer: UIGestureRecognizer) {
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
    
    private func getAnnotationLocationName() {
        CLGeocoder().reverseGeocodeLocation(CLLocation(latitude: draggableAnnotation!.coordinate.latitude, longitude: draggableAnnotation!.coordinate.longitude), completionHandler: { (placemarks: [CLPlacemark]?, error: Error?) -> Void in
            
            if error != nil {
                magic("Reverse geocoder failed with error" + error!.localizedDescription)
                return
            }
            
            if placemarks != nil && placemarks!.count > 0 {
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
                magic("Problem with the data received from geocoder")
            }
            
            /// Create new Pin
            let pin = Pin(withTitle: self.draggableAnnotation!.title!, latitude: self.draggableAnnotation!.coordinate.latitude, longitude: self.draggableAnnotation!.coordinate.longitude, context: self.stack.context)
            
            self.draggableAnnotation?.pin = pin
            
            self.stack.save()
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
    
//    internal func mapViewDidFinishRenderingMap(_ mapView: MKMapView, fullyRendered: Bool) {
//        if mapRendered { return }
//        mapRendered = true
////        preloadedMapImage.alpha = 0.0
//        placeAnnotations()
//    }

    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        /// Save region to NSUserDefaults
        let lat         = mapView.region.center.latitude
        let lon         = mapView.region.center.longitude
        let latDelta    = mapView.region.span.latitudeDelta
        let lonDelta    = mapView.region.span.longitudeDelta
        
        Constants.userDefaults.set(lat, forKey: Constants.StorageKeys.latitude)
        Constants.userDefaults.set(lon, forKey: Constants.StorageKeys.longitude)
        Constants.userDefaults.set(latDelta, forKey: Constants.StorageKeys.latitudeDelta)
        Constants.userDefaults.set(lonDelta, forKey: Constants.StorageKeys.longitudeDelta)
    }
//    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
//        magic("")
//    }
    
    internal func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
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
//            magic(pinView.annotation?.coordinate)
            return pinView
        }
        return nil
    }
    
    internal func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let annotation = view.annotation as! MapLocationAnnotation
        openPhotoAlbum(annotation.pin)
    }
    
    internal func mapView(_ mapView: MKMapView, didAdd views: [MKAnnotationView]) {
        if !animatedPinsIn {
            animateAnnotationsWithAnnotationArray(views)
        }
    }
}

extension MapContainerView: UIGestureRecognizerDelegate {
    internal func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        /// We only allow the (drag) gesture to continue if it is within a long press
        if((gestureRecognizer is UIPanGestureRecognizer) && mapView.isScrollEnabled) {
            return false
        }
        return true
    }
}



































