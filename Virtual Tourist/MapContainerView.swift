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


class MapContainerView: UIView /*, FlickrFetchable*/ {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var mapView: MKMapView!
    
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    private var stack: CoreDataStack!
    
    /// This is set by stateMachine, not directly
    fileprivate var state: MapState = .normalStateNoPins {
        didSet {
            magic("current state: \(state)")
            switch state {
            case .clearingAll:
                clearAllAnnotations()
            case .clearingSelected:
                clearSelectedAnnotations()
            default:
                break
            }
            toggleAnnotationSelection()
        }
    }
    fileprivate var stateMachine: MapViewStateMachine! {
        didSet {
            stateMachine.state.bind {
                self.state = $0
            }
        }
    }
    
    private var presentAlert: ((MapLocationAnnotation) -> Void)!
    
    fileprivate var mapRendered = false
    fileprivate var animatedPinsIn = false
    
    
    private var draggableAnnotation: MapLocationAnnotation?
    
    private var annotations = [MapLocationAnnotation]() {
        didSet {
            stateMachine.state.value = (annotations.count > 0) ? .normalStateWithPins : .normalStateNoPins
        }
    }
    fileprivate var selectedAnnotations = [MapLocationAnnotation]() {
        didSet {
            /// If user deselects all pins, set state back to normal
            if selectedAnnotations.count == 0 {
                stateMachine.state.value = (annotations.count > 0) ? .normalStateWithPins : .normalStateNoPins
            }
        }
    }
    
    ///
    fileprivate var annotationViews = [MKAnnotationView]()
    fileprivate var selectedAnnotationViews = [MKAnnotationView]()
    
    private var pins = [Pin]()
//    fileprivate var pinsToDelete = [Pin]()
    
    
    private var placemarks: [CLPlacemark]?
    
    
    
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
    
    internal func configure(withOpenAlbumClosure closure: @escaping (Pin) -> Void, mapViewStateMachine sm: MapViewStateMachine, alertPresentationClosure alertPresentation: @escaping (MapLocationAnnotation) -> Void) {
        
        openPhotoAlbum  = closure
        stateMachine    = sm
        presentAlert    = alertPresentation
    }
    
    
    private func configureActivityIndicator() {
        activityIndicator.activityIndicatorViewStyle = .whiteLarge
        activityIndicator.color = Theme.activityIndicatorCircle1
        activityIndicator.hidesWhenStopped = true
        
        /// Only run first time
        if !mapRendered {
            activityIndicator.startAnimating()
        }
    }
    
    private func configureMap() {
        let lat         = Constants.userDefaults.double(forKey: Constants.StorageKeys.latitude)
        let lon         = Constants.userDefaults.double(forKey: Constants.StorageKeys.longitude)
        let latDelta    = Constants.userDefaults.double(forKey: Constants.StorageKeys.latitudeDelta)
        let lonDelta    = Constants.userDefaults.double(forKey: Constants.StorageKeys.longitudeDelta)
        
        /// Only set region if the values have already been saved to NSUserDefaults
        if lat != 0.0 && lon != 0.0 {
            let center  = CLLocationCoordinate2D(latitude: lat, longitude: lon)
            let span    = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: lonDelta)
            let region  = MKCoordinateRegion(center: center, span: span)
            
            mapView.setRegion(region, animated: true)
        }
    }
    
    private func configureLongPressGestureRecognizer() {
        let gestureRecognizer = UILongPressGestureRecognizer()
        gestureRecognizer.addTarget(self, action: #selector(hangleLongPress(_:)))
        
        gestureRecognizer.minimumPressDuration = 0.5
        gestureRecognizer.allowableMovement     = 1000 /// just set to huge number for now
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
            let location    = gestureRecognizer.location(in: mapView)
            let coordinate  = mapView.convert(location, toCoordinateFrom: mapView)
            
            draggableAnnotation!.coordinate = coordinate
        }
    }
    
    
    
    //MARK: - Map View
    
    fileprivate func placeAnnotations() {
        if animatedPinsIn { return }
        for pin in pins {
            let annotation          = MapLocationAnnotation()
            annotation.title        = pin.title
            annotation.pin          = pin
            annotation.coordinate   = CLLocationCoordinate2D(latitude: pin.latitude, longitude: pin.longitude)
            
            annotations.append(annotation)
        }

        mapView.addAnnotations(annotations)
        activityIndicator.stopAnimating()
    }
    
    private func addAnnotation(_ gestureRecognizer: UIGestureRecognizer) {
        let location    = gestureRecognizer.location(in: mapView)
        let coordinate  = mapView.convert(location, toCoordinateFrom: mapView)
        let annotation  = MapLocationAnnotation()
        
        annotation.coordinate = coordinate

        annotations.append(annotation)
        mapView.addAnnotation(annotation)
        
        draggableAnnotation = annotation
    }
    
    internal func deletePinForAnnotation(_ annotation: MapLocationAnnotation) {
        stack.context.delete(annotation.pin!)
        var annotationsArr = [MKAnnotation]()
        annotationsArr.append(annotation)
        
        mapView.removeAnnotations(annotationsArr)
        
        /// Clear from annotations array
        for _ in annotations {
            if let i = annotations.index(of: annotation) {
                annotations.remove(at: i)
            }
        }
    }
    
    private func clearSelectedAnnotations() {
        if selectedAnnotations.count > 0 {
            
            /// Clear Annotations
            for annotation in selectedAnnotations {
                
                /// Delete pin from Core Data
                stack.context.delete(annotation.pin!)
                
                /// Remove from annotations
                if let i = annotations.index(of: annotation) {
                    annotations.remove(at: i)
                }
            }
            stack.save()
            
            /// Remove from map
            mapView.removeAnnotations(selectedAnnotations)
            
            /// Reset
            selectedAnnotations.removeAll()
        }
        
        /// Clear Annotation Views
        if selectedAnnotationViews.count > 0 {
            
            for view in selectedAnnotationViews {
                
                /// Remove the view from annotationViews
                if let i = annotationViews.index(of: view) {
                    annotationViews.remove(at: i)
                }
            }
            
            /// Reset
            selectedAnnotationViews.removeAll()
        }
    }
    
    private func clearAllAnnotations() {
        if annotations.count > 0 {
            
            /// Delete pins from Core Data
            do {
                try stack.dropAllData()
                stack.save()
            } catch {
                print("Error dropping all objects in DB")
            }
            
            /// Clear annotations from map
            mapView.removeAnnotations(annotations)
            
            /// Clean up everything else
            annotations.removeAll()
            selectedAnnotations.removeAll()
            annotationViews.removeAll()
            selectedAnnotationViews.removeAll()
        }
    }
    
    private func toggleAnnotationSelection() {
        if annotations.count > 0 {
            for annotationView in annotationViews {
                annotationView.canShowCallout = (state == .isSelecting) ? false : true
            }
        }
    }
    
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
                    title = LocalizedStrings.unknownPlace
                
                }
                
                self.draggableAnnotation!.title = title
            }
            else {
                self.draggableAnnotation!.title = LocalizedStrings.unknownPlace
                magic("Problem with the data received from geocoder")
            }
            
            /// Create new Pin
            let pin = Pin(withTitle: self.draggableAnnotation!.title!,
                          latitude: self.draggableAnnotation!.coordinate.latitude,
                          longitude: self.draggableAnnotation!.coordinate.longitude,
                          context: self.stack.context)
            
            self.draggableAnnotation?.pin = pin
            
            self.stack.save()
            
            self.performFlickrFetchForPin(pin)
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
    
    //MARK: - Photo Fetching
    
    ///////////// MOVE TO PROTOCOL /////////////
    private func performFlickrFetchForPin(_ pin: Pin, completion: (() -> Void)? = nil) {
        let flickrFetchCompletion = { (hasPhotos: Bool) in
            if !hasPhotos {
                for annotation in self.annotations {
                    if pin == annotation.pin {
                        self.presentAlert?(annotation)
                        break
                    }
                }
                return
            }
            completion?()
            self.processPhotosForPin(pin)
        }
        FlickrProvider.fetchImagesForPin(pin, pageNumber: pin.page, withCompletion: flickrFetchCompletion)
    }
    
    private func processPhotosForPin(_ pin: Pin) {
        for photo in pin.photos! {
            checkForImageData(photo as! Photo)
        }
    }
    
    private func checkForImageData(_ photo: Photo) {
        
        /// Check for image data
        if photo.imageData == nil {
            FlickrProvider.fetchImageDataForPhoto(photo)
        }
    }
    ///////////// ^ MOVE TO PROTOCOL ^ /////////////
}

extension MapContainerView: MKMapViewDelegate {
    
    internal func mapViewDidFinishRenderingMap(_ mapView: MKMapView, fullyRendered: Bool) {
        if mapRendered { return }
        mapRendered = true
        
        placeAnnotations()
    }

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
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if state == .isSelecting {
            let pinView = view as! MKPinAnnotationView
            let annotation = view.annotation as! MapLocationAnnotation
            /// can use highlighted state to determine if it's selected or not
            if !annotation.isSelected {
                selectedAnnotations.append(annotation)
                selectedAnnotationViews.append(pinView)
                annotation.isSelected   = true
                pinView.pinTintColor = Theme.selectedPin
            } else {
                if let i = selectedAnnotations.index(of: annotation) {
                    selectedAnnotations.remove(at: i)
                }
                if let i = selectedAnnotationViews.index(of: pinView) {
                    selectedAnnotationViews.remove(at: i)
                }
                annotation.isSelected   = false
                pinView.pinTintColor = Theme.unselectedPin
                
            }
            mapView.deselectAnnotation(annotation, animated: false)
        }
    }
    
//    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
//        if state == .isSelecting {
//            //            view.canShowCallout = false
////            view.isHighlighted = true
//            //            magic("add to selected list or take out")
//        }
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
            pinView.pinTintColor = Theme.unselectedPin
            annotationViews.append(pinView)
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



































