//
//  FlickrFetchable.swift
//  Virtual Tourist
//
//  Created by Dylan Edwards on 10/20/16.
//  Copyright © 2016 Slinging Pixels Media. All rights reserved.
//

import UIKit

protocol FlickrFetchable: class {
    var photos: [Photo]? { get set }
}

extension FlickrFetchable {
    internal func processPhotosForPin(_ pin: Pin, photosCollectionView photosCV: UICollectionView? = nil, completion: (() -> Void)? = nil) {
        for photo in pin.photos! {
            checkForImageData(photo as! Photo, photosCollectionView: photosCV)
        }
        completion?()
    }
    
    private func checkForImageData(_ photo: Photo, photosCollectionView photosCV: UICollectionView? = nil) {
        /// Add photo to photo array
        if photos != nil {
            photos!.append(photo)
        }
        
        /// Check for image data
        if photo.imageData == nil {
            if photosCV != nil {
                let imageDataLoadedComplete = {
                    photosCV!.reloadData()
                }
                FlickrProvider.fetchImageDataForPhoto(photo, completion: imageDataLoadedComplete)
            } else {
                FlickrProvider.fetchImageDataForPhoto(photo)
            }
        }
    }
}
