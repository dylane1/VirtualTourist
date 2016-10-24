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

class PhotoAlbumView: UIView, FlickrFetchable {

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
    
    fileprivate var selectedIndexes = [IndexPath]()
    
    internal var photos: [Photo]? = [Photo]()
    private var hasHitEndOfFlickrPhotos = false
    
    
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
         * First, check to see if photos exist in database. If they don't, hit 
         * flickr.
         *
         * Note (October 20, 2016): I'm moving the initial fetch into 
         * MapContainerView. I'm not sure what will happen when I
         * initiate the fetch in MapContainerView, and then segue here before
         * the fetch has completed. I'll need to test by simulating a very slow
         * connection.
         */
        if pin.photos!.count == 0 {
            performFlickrFetchForPin(pin)
        } else {
            let photosProcessedCompletion = {
                self.toolbarButtonSetup()
            }
            processPhotosForPin(pin, photosCollectionView: photosCollectionView, completion: photosProcessedCompletion)
        }
        
        photosCollectionView.dataSource = self
    }
    
    
    private func configureCollectionView() {
        photosCollectionView.delegate           = self
        photosCollectionView.backgroundView     = nil
        photosCollectionView.backgroundColor    = Theme.loginScreenBGColor
    }
    
    
    
    //MARK: - 
    
    private func performFlickrFetchForPin(_ pin: Pin, completion: (() -> Void)? = nil) {
        let flickrFetchCompletion = { (hasPhotos: Bool) in
            if !hasPhotos {
                if pin.page > 1 {
                    /// This was an unsuccessful attempt at loading a new collection
                    pin.page -= 1
                    self.hasHitEndOfFlickrPhotos = true
                    self.toolbarButtonSetup()
                } else {
                    let noImagesFoundVC = UIStoryboard(name: Constants.StoryBoardID.main, bundle: nil).instantiateViewController(withIdentifier: Constants.StoryBoardID.noPhotosFound) as! NoPhotosFoundViewController
                    
                    self.photosCollectionView.backgroundView = noImagesFoundVC.view
                }
                return
            }
            completion?()
            
            let photosProcessedCompletion = {
                self.toolbarButtonSetup()
            }
            self.processPhotosForPin(pin, photosCollectionView: self.photosCollectionView, completion: photosProcessedCompletion)
        }
        FlickrProvider.fetchImagesForPin(pin, pageNumber: pin.page, withCompletion: flickrFetchCompletion)
    }
    
    
    fileprivate func toggleCellSelection(_ cell: PhotoAlbumCollectionViewCell, atIndexPath indexPath: IndexPath) {
        
        cell.imageView.alpha = (selectedIndexes.index(of: indexPath) != nil) ? 0.5 : 1.0
    }
    
    fileprivate func toolbarButtonSetup() {
        if selectedIndexes.count == 0 {
            toolbarButton.title     = LocalizedStrings.ToolbarButtons.newCollection
            toolbarButton.isEnabled = (hasHitEndOfFlickrPhotos) ? false : true
        } else {
            toolbarButton.title     = LocalizedStrings.ToolbarButtons.removeSelected
            toolbarButton.isEnabled = true
        }

    }
    
    internal func toolbarButtonTapped() {
        if selectedIndexes.count == 0 {
            let successfulFetchCompletion = {
                /// Clear out for the new photos
                self.photos = [Photo]()
                self.photosCollectionView.reloadData()
            }
            pin.page += 1
            performFlickrFetchForPin(pin, completion: successfulFetchCompletion)
        } else {
            let newSet = NSMutableSet()
            
            selectedIndexes.sort() { $0.row > $1.row }
            
            for index in selectedIndexes {
                photos!.remove(at: index.row)
            }
            newSet.addObjects(from: photos!)
            
            pin.photos = newSet
            
            photosCollectionView.deleteItems(at: selectedIndexes)
            selectedIndexes = [IndexPath]()
            toolbarButtonSetup()
        }
        stack.save()
    }
    
    /// Called on rotation to reset the cell layout
    internal func layoutCollectionView() {
        photosCollectionView.collectionViewLayout.invalidateLayout()
    }
}

//TODO: Move this stuff down to photoalbumcollectionview if possible
extension PhotoAlbumView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoAlbumCollectionViewCell.reuseIdentifier, for: indexPath) as! PhotoAlbumCollectionViewCell
        
        cell.configure(withImageData: photos![indexPath.row].imageData)
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
        toolbarButtonSetup()
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

































