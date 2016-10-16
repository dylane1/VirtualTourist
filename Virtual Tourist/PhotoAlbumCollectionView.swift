//
//  PhotoAlbumCollectionView.swift
//  Virtual Tourist
//
//  Created by Dylan Edwards on 10/14/16.
//  Copyright © 2016 Slinging Pixels Media. All rights reserved.
//

import UIKit
import CoreData
import MapKit

class PhotoAlbumCollectionView: UICollectionView {

    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    private var stack: CoreDataStack!
    
//    private var photoArray = [Photo]()
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    
    //MARK: - Configuration
    internal func configure(withPin pin: Pin) {
        stack = appDelegate.stack
//        delegate = self
        
        /**
         First, check to see if photos exist in database. If they don't, hit flickr
         */
//        magic("pin: \(pin.photos)")
        
//        magic("pin.photos.count: \(pin.photos!.count)")
//        fetchFromCoreData()
        
        /// Start getting images
        if pin.photos!.count == 0 {
            let flickrFetchCompletion = { (photos: [Photo]?) in
                guard let photos = photos as [Photo]! else { return }
                
                for photo in photos {
                    self.checkForImageData(photo)
//                    magic("title: \(photo.title); url: \(photo.url)")
//                    self.photoArray.append(photo)
                }
                //TODO: Reload data for collection view
                //            magic("self.collectionView: \(self.collectionView)")
                //            self.collectionView?.reloadData()
            }
            FlickrProvider.fetchImagesForPin(pin, withCompletion: flickrFetchCompletion)
        } else {
            for photo in pin.photos! {
                checkForImageData(photo as! Photo)
//                let p = photo as! Photo
//                magic("p.title: \(p.url!)")
            }
        }
        
    }
    
    private func checkForImageData(_ photo: Photo) {
        if photo.imageData != nil {
            /// load image into cell
            magic("data exists... imageData.bytes: \(photo.imageData?.bytes)")
        } else {
            let imageDataLoadedComplete = {
                magic("download complete... imageData.bytes: \(photo.imageData?.bytes)")
            }
            FlickrProvider.fetchImageDataForPhoto(photo, withCompletion: imageDataLoadedComplete)
        }
    }
//    private func fetchFromCoreData() {
//        /// Get the stack
//        stack = appDelegate.stack
//        
//        /// Create a fetchrequest
//        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Photo")
//        
//        /// Create Predicate
////        let predicate = NSPredicate(format: String, <#T##args: CVarArg...##CVarArg#>)
//        
//        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
//        
//        do {
//            photoArray = try stack.context.fetch(request) as! [Photo]
//            magic("photoArray: \(photoArray.count)")
////            placeAnnotations()
//        } catch {
//            magic("failed to fetch photoArray: \(error)")
//        }
//    }
}
