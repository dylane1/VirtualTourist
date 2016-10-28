//
//  Constants.swift
//  Virtual Tourist
//
//  Created by Dylan Edwards on 5/18/16.
//  Copyright © 2016 Slinging Pixels Media. All rights reserved.
//

import UIKit

struct Constants {
    
    /// Storyboard
    struct StoryBoardID {
        static let main             = "Main"
        static let noPhotosFound    = "noPhotosFound"
        static let photoContainer   = "photoContainer"
    }
    
    //MARK: - Network
    
    struct Flickr {
        static let key      = "446dfaa1521e824779ddb5cd32d363a4"
        static let secret   = "53cc541820255f86"
    }
    
    struct FontName {
        static let markerFelt   = "MarkerFelt-Wide"
        static let avenirHeavy  = "Avenir-Heavy"
    }


    //MARK: - Storage
    
    static let coreDataStack = CoreDataStack(modelName: "Model")!
    
    static let userDefaults = UserDefaults.standard
    
    struct StorageKeys {
        static let latitude         = "com.slingingPixels.virtualTourist.storageKeys.latitude"
        static let longitude        = "com.slingingPixels.virtualTourist.storageKeys.longitude"
        static let latitudeDelta    = "com.slingingPixels.virtualTourist.storageKeys.latitudeDelta"
        static let longitudeDelta   = "com.slingingPixels.virtualTourist.storageKeys.longitudeDelta"
    }
}
