//
//  Constants.swift
//  On The Map
//
//  Created by Dylan Edwards on 5/18/16.
//  Copyright © 2016 Slinging Pixels Media. All rights reserved.
//

import UIKit

struct Constants {
    /// Storyboard
    struct StoryBoardID {
        static let main                     = "Main"
        static let loginVC                  = "loginVC"
        static let activityIndicatorVC      = "activityIndicatorVC"
        static let mapPresentationVC        = "mapPresentationVC"
        static let infoPostingNavController = "infoPostingNavController"
        static let infoPostingVC            = "infoPostingVC"
    }
    
    /// UI
    
    static let screenHeight = UIScreen.mainScreen().bounds.height
    static let screenWidth  = UIScreen.mainScreen().bounds.width
    
    struct DeviceScreenHeight {
        static let iPhone4s: CGFloat    = 480
        static let iPhone5: CGFloat     = 568
        static let iPhone6: CGFloat     = 667
        static let iPhone6Plus: CGFloat = 736
    }
    
    struct MapImage {
        static let iPhone4s     = "Map_iPhone4s.png"
        static let iPhone5      = "Map_iPhone5.png"
        static let iPhone6      = "Map_iPhone6.png"
        static let iPhone6Plus  = "Map_iPhone6Plus.png"
    }
    //MARK: - Network
    
    struct Network {
        static let udacitySignUpURL     = "https://www.udacity.com"
        static let udacitySessionURL    = "https://www.udacity.com/api/session"
        static let parseAppID           = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        static let restAPIKey           = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
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


    //MARK: - Dictionary Keys
    
    struct Keys {
        ///
        static let session      = "session"
        static let account      = "account"
        static let id           = "id"
        
        ///
        static let key          = "key"
        static let user         = "user"
        
        ///
        static let first_name   = "first_name"
        static let last_name    = "last_name"
        
        ///
        static let results      = "results"
        static let objectId     = "objectId"
        static let firstName    = "firstName"
        static let lastName     = "lastName"
        static let uniqueKey    = "uniqueKey"
        static let latitude     = "latitude"
        static let longitude    = "longitude"
        static let mapString    = "mapString"
        static let mediaURL     = "mediaURL"
        static let updatedAt    = "updatedAt"
        static let createdAt    = "createdAt"
        
        ///
        static let status       = "status"
        static let error        = "error"
        static let parameter    = "parameter"
    }
    
    struct LoginErrorResponses {
        static let missingUsername = "udacity.username"
        static let missingPassword = "udacity.password"
    }
}
