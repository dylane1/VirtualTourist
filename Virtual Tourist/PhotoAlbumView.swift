//
//  PhotoAlbumView.swift
//  Virtual Tourist
//
//  Created by Dylan Edwards on 8/26/16.
//  Copyright © 2016 Slinging Pixels Media. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class PhotoAlbumView: UIView {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var photosCollectionView: UICollectionView!
    @IBOutlet weak var toolbar: UIToolbar!

    fileprivate var pin: Pin!
    
    /**
     Map View Constraints
     
     Want to set as a percentage of space avalable per device instead of fixed
     
     - Height is set for portrait layout
     - Width is set for landscape layout
     */
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var widthConstraint: NSLayoutConstraint!

    /// Collection View Data
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    private var stack: CoreDataStack!
    
//    fileprivate var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>!
    
    fileprivate var selectedIndexes = [IndexPath]()
    
    fileprivate var insertedIndexPaths: [IndexPath]!
    fileprivate var deletedIndexPaths: [IndexPath]!
    fileprivate var updatedIndexPaths: [IndexPath]!
    
    fileprivate var photos = [Photo]()
    ///
    
    //MARK: - Configuration
    
    internal func configure(withPin pin: Pin) {
        self.pin = pin
        
        heightConstraint.constant = bounds.height * 0.25
        widthConstraint.constant = bounds.height * 0.33
        
        configureMapView()
        configureCollectionViewData()
        configureCollectionView()
        configureToolbar()
    }
    
    private func configureMapView() {
        let regionRadius        = CLLocationDistance(34000)
        let annotation          = MKPointAnnotation()
        annotation.coordinate   = CLLocationCoordinate2D(latitude: pin.latitude, longitude: pin.longitude)
        
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(annotation.coordinate, regionRadius * 2.0, regionRadius * 2.0)
        
        mapView.setRegion(coordinateRegion, animated: true)
        
        mapView.addAnnotation(annotation)
    }

    private func configureCollectionViewData() {
        stack = appDelegate.stack
        
        /**
         First, check to see if photos exist in database. If they don't, hit flickr
         */
        if pin.photos!.count == 0 {
            let flickrFetchCompletion = { (photos: [Photo]?) in
                guard let photos = photos as [Photo]! else { return }
                
                for photo in photos {
                    self.checkForImageData(photo)
                }
            }
            FlickrProvider.fetchImagesForPin(pin, withCompletion: flickrFetchCompletion)
        } else {
            for photo in pin.photos! {
                checkForImageData(photo as! Photo)
            }
        }
        
        photosCollectionView.dataSource = self
    }
    
    
    private func configureCollectionView() {
        photosCollectionView.delegate = self
    }
    
    private func configureToolbar() {
        var toolbarItemArray = [UIBarButtonItem]()
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        
        toolbarItemArray.append(flexSpace)
        
        let albumButton = UIBarButtonItem(
            title: LocalizedStrings.ToolbarButtons.newCollection,
            style: .plain,
            target: self,
            action: #selector(newCollectionButtonTapped))
        
        toolbarItemArray.append(albumButton)
        
        toolbarItemArray.append(flexSpace)
        
        toolbar.setItems(toolbarItemArray, animated: false)
        
//        toolbar.barTintColor = Theme.darkBlue
        toolbar.tintColor    = Theme.navBarTitleColor
        toolbar.isTranslucent  = true
    }
    
    //MARK: - 
//    internal func layoutCollectionView() {
//        // Lay out the collection view so that cells take up 1/3 of the width,
//        // with no space in between.
//        let layout : UICollectionViewFlowLayout = UICollectionViewFlowLayout()
//        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//        layout.minimumLineSpacing = 0
//        layout.minimumInteritemSpacing = 0
//        
//        let width = floor(photosCollectionView.frame.size.width/3)
//        layout.itemSize = CGSize(width: width, height: width)
//        photosCollectionView.collectionViewLayout = layout
//    }
    
    
    private func checkForImageData(_ photo: Photo) {
        /// Add photo to photo array
        photos.append(photo)
        
        /// Check for image data
        if photo.imageData != nil {
            /// load image into cell
            magic("data exists... imageData.bytes: \(photo.imageData?.bytes)")
        } else {
            let imageDataLoadedComplete = {
                self.photosCollectionView.reloadData()
                magic("download complete... imageData.bytes: \(photo.imageData?.bytes)")
            }
            FlickrProvider.fetchImageDataForPhoto(photo, withCompletion: imageDataLoadedComplete)
        }
    }
    
    
    internal func newCollectionButtonTapped() {
        magic("oh yeah")
    }
    
    
}
//TODO: Move this stuff down to photoalbumcollectionview if possible
extension PhotoAlbumView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
        
//        return pin.photos?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoAlbumCollectionViewCell.reuseIdentifier, for: indexPath) as! PhotoAlbumCollectionViewCell
        
        cell.configure(withImageData: photos[indexPath.row].imageData)
//        self.configureCell(cell, atIndexPath: indexPath)
        
        return cell
    }
    
    
}

extension PhotoAlbumView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        //        let cell = collectionView.cellForItem(at: indexPath) as! ColorCell
        //
        //        // Whenever a cell is tapped we will toggle its presence in the selectedIndexes array
        //        if let index = selectedIndexes.index(of: indexPath) {
        //            selectedIndexes.remove(at: index)
        //        } else {
        //            selectedIndexes.append(indexPath)
        //        }
        //
        //        // Then reconfigure the cell
        //        configureCell(cell, atIndexPath: indexPath)
        //
        //        // And update the buttom button
        //        updateBottomButton()
    }
    
    
}

extension PhotoAlbumView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        magic("frame.width: \(frame.width)")
        let width = (frame.width / 3) - 5
        
        return CGSize(width: width, height: width)
    }
}
//extension PhotoAlbumView: NSFetchedResultsControllerDelegate {
//    
//}

































