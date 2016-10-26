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
    
    /// UI
    
//    static let screenHeight = UIScreen.main.bounds.height
//    static let screenWidth  = UIScreen.main.bounds.width
//    
//    struct DeviceScreenHeight {
//        static let iPhone4s: CGFloat    = 480
//        static let iPhone5: CGFloat     = 568
//        static let iPhone6: CGFloat     = 667
//        static let iPhone6Plus: CGFloat = 736
//    }
//
    //MARK: - Network
    
    struct Flickr {
        static let key      = "446dfaa1521e824779ddb5cd32d363a4"
        static let secret   = "53cc541820255f86"
    }
    
    struct HTTPHeaderFieldValues {
        static let applicationJSON = "application/json"
    }
    
    struct HTTPHeaderFields {
        static let accept           = "Accept"
        static let contentType      = "Content-Type"
        static let xParseAppId      = "X-Parse-Application-Id"
        static let xParseRestAPIKey = "X-Parse-REST-API-Key"
    }
    
    struct HTTPMethods {
        static let get      = "GET"
        static let post     = "POST"
        static let put      = "PUT"
        static let delete   = "DELETE"
    }
    
    struct FontName {
        static let avenirLight  = "Avenir-Light"
        static let avenirMedium = "Avenir-Medium"
        static let avenirHeavy  = "Avenir-Heavy"
        static let avenirBlack  = "Avenir-Black"
        
        static let markerFelt   = "MarkerFelt-Wide"
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
    
    
//    struct FileSystem {
//        static let applicationSupport = NSSearchPathForDirectoriesInDomains(.applicationSupportDirectory, .userDomainMask, true)[0]
//    }
//    static let storedMapImage = FileSystem.applicationSupport + "/storedMapImage.png"
    
    
    //MARK: - Dictionary Keys
    
    struct Keys {
//        ///
//        static let session      = "session"
//        static let account      = "account"
//        static let id           = "id"
//        
//        ///
//        static let key          = "key"
//        static let user         = "user"
//        
//        ///
//        static let first_name   = "first_name"
//        static let last_name    = "last_name"
//        
//        ///
//        static let results      = "results"
//        static let objectId     = "objectId"
//        static let firstName    = "firstName"
//        static let lastName     = "lastName"
//        static let uniqueKey    = "uniqueKey"
//        static let latitude     = "latitude"
//        static let longitude    = "longitude"
//        static let mapString    = "mapString"
//        static let mediaURL     = "mediaURL"
//        static let updatedAt    = "updatedAt"
//        static let createdAt    = "createdAt"
//        
//        ///
//        static let status       = "status"
//        static let error        = "error"
//        static let parameter    = "parameter"
    }
    
//    struct LoginErrorResponses {
//        static let missingUsername = "udacity.username"
//        static let missingPassword = "udacity.password"
//    }
}
