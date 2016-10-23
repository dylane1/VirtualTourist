//
//  FlickrFetchable.swift
//  Virtual Tourist
//
//  Created by Dylan Edwards on 10/20/16.
//  Copyright © 2016 Slinging Pixels Media. All rights reserved.
//

import Foundation

protocol FlickrFetchable {
    var pin: Pin { get set }
//    var hasHitEndOfFlickrPhotos: Bool { get set }
    
//    func toolbarButtonSetup()
}

extension FlickrFetchable {
    internal mutating func performFlickrFetch(withCompletion completion: (() -> Void)? = nil) {
        let flickrFetchCompletion = { (hasPhotos: Bool) in
//            if !hasPhotos {
//                //TODO: pop an alert that no images were found
//                magic("no images found on flickr")
//                if self.pin.page > 1 {
//                    /// This was an unsuccessful attempt at loading a new collection
//                    self.pin.page -= 1
//                    self.hasHitEndOfFlickrPhotos = true
//                    self.toolbarButtonSetup()
//                }
//                return
//            }
//            completion?()
//            self.processPhotos()
        }
        FlickrProvider.fetchImagesForPin(pin, pageNumber: pin.page, withCompletion: flickrFetchCompletion)
    }
}
