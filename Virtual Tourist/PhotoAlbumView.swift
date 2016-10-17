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

    private var toolbarButton: UIBarButtonItem!
    
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
    
//    fileprivate var insertedIndexPaths: [IndexPath]!
//    fileprivate var deletedIndexPaths: [IndexPath]!
//    fileprivate var updatedIndexPaths: [IndexPath]!
    
    fileprivate var photos = [Photo]()
//    fileprivate var photosToDelete = [Photo]()
    ///
    
    //MARK: - Configuration
    
    internal func configure(withPin pin: Pin) {
        self.pin = pin
        
        heightConstraint.constant = bounds.height * 0.25
        widthConstraint.constant = bounds.height * 0.33
        
        configureMapView()
        configureToolbar()
        configureCollectionViewData()
        configureCollectionView()
        
    }
    
    private func configureMapView() {
        let regionRadius        = CLLocationDistance(34000)
        let annotation          = MKPointAnnotation()
        annotation.coordinate   = CLLocationCoordinate2D(latitude: pin.latitude, longitude: pin.longitude)
        
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(annotation.coordinate, regionRadius * 2.0, regionRadius * 2.0)
        
        mapView.setRegion(coordinateRegion, animated: true)
        
        mapView.addAnnotation(annotation)
    }

    private func configureToolbar() {
        var toolbarItemArray = [UIBarButtonItem]()
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        
        toolbarItemArray.append(flexSpace)
        
        toolbarButton = UIBarButtonItem(
            title: LocalizedStrings.ToolbarButtons.newCollection,
            style: .plain,
            target: self,
            action: #selector(toolbarButtonTapped))
        
        toolbarButton.isEnabled = false
        
        toolbarItemArray.append(toolbarButton)
        
        toolbarItemArray.append(flexSpace)
        
        toolbar.setItems(toolbarItemArray, animated: false)
        
        //        toolbar.barTintColor = Theme.darkBlue
        toolbar.tintColor    = Theme.navBarTitleColor
        toolbar.isTranslucent  = true
    }
    
    private func configureCollectionViewData() {
        stack = appDelegate.stack
        
        /**
         First, check to see if photos exist in database. If they don't, hit flickr
         */
        if pin.photos!.count == 0 {
            let flickrFetchCompletion = { (hasPhotos: Bool) in
                if !hasPhotos {
                    //TODO: pop an alert that no images were found
                    magic("no images found on flickr")
                    return
                }
                self.processPhotos()
            }
            FlickrProvider.fetchImagesForPin(pin, withCompletion: flickrFetchCompletion)
        } else {
            processPhotos()
        }
        
        photosCollectionView.dataSource = self
    }
    
    
    private func configureCollectionView() {
        photosCollectionView.delegate = self
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
    
    private func processPhotos() {
        for photo in pin.photos! {
            checkForImageData(photo as! Photo)
        }
        toolbarButton.isEnabled = true
    }
    
    private func checkForImageData(_ photo: Photo) {
        /// Add photo to photo array
        photos.append(photo)
        
        /// Check for image data
        if photo.imageData != nil {
            /// load image into cell
//            magic("data exists... imageData.bytes: \(photo.imageData!.length)")
        } else {
            let imageDataLoadedComplete = {
                self.photosCollectionView.reloadData()
//                magic("download complete... imageData.bytes: \(photo.imageData!.length)")
            }
            FlickrProvider.fetchImageDataForPhoto(photo, withCompletion: imageDataLoadedComplete)
        }
    }
    
    fileprivate func toggleCellSelection(_ cell: PhotoAlbumCollectionViewCell, atIndexPath indexPath: IndexPath) {
        
        cell.imageView.alpha = (selectedIndexes.index(of: indexPath) != nil) ? 0.5 : 1.0
    }
    
    internal func toolbarButtonTapped() {
        if selectedIndexes.count == 0 {
            photos = [Photo]()
            pin.photos = nil
            //TODO: Fetch new photo set
            photosCollectionView.reloadData()
        } else {
            let newSet = NSMutableSet()
            
            magic("selectedIndexes: \(selectedIndexes)")
            selectedIndexes.sort() { $0.row > $1.row }
            magic("sorted selectedIndexes: \(selectedIndexes)")
            for index in selectedIndexes {
                photos.remove(at: index.row)
            }
            newSet.addObjects(from: photos)
            magic("pin.photos: \(pin.photos?.count)")
            pin.photos = newSet
            magic("new pin.photos: \(pin.photos?.count)")
            photosCollectionView.deleteItems(at: selectedIndexes)
            selectedIndexes = [IndexPath]()
        }
        stack.save()
//        photosCollectionView.reloadData()
    }
    
    /// Called on rotation to reset the cell layout
    internal func layoutCollectionView() {
        photosCollectionView.collectionViewLayout.invalidateLayout()
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
        toggleCellSelection(cell, atIndexPath: indexPath)
        return cell
    }
    
    
}

extension PhotoAlbumView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath) as! PhotoAlbumCollectionViewCell
        
        if let index = selectedIndexes.index(of: indexPath) {
            selectedIndexes.remove(at: index)
        } else {
            selectedIndexes.append(indexPath)
        }
        
        toggleCellSelection(cell, atIndexPath: indexPath)
        
        //TODO: Update toolbar button
    }
    
    
}

extension PhotoAlbumView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let picDimension = floor(photosCollectionView.frame.size.width / 4.0) - 1
        
        return CGSize(width: picDimension, height: picDimension)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 0, 0, 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
}
//extension PhotoAlbumView: NSFetchedResultsControllerDelegate {
//    
//}

































