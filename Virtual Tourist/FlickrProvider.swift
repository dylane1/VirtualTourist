//
//  FlickrProvider.swift
//  Virtual Tourist
//
//  Created by Dylan Edwards on 9/19/16.
//  Copyright © 2016 Slinging Pixels Media. All rights reserved.
//

import MapKit
import Foundation

struct FlickrProvider {
    
    static func fetchImagesForPin(_ pin: Pin, withCompletion completion: @escaping ([Photo]?) -> Void) {
        let lat = pin.latitude
        let lon = pin.longitude
        
        /// Build querey
        /**
         * API Documentation:  https://www.flickr.com/services/api/flickr.photos.search.html
         **/
        let queryString = "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=\(Constants.Flickr.key)&lat=\(lat)&lon=\(lon)&per_page=25&format=json&nojsoncallback=1"
        
        let url = URL(string: queryString)!
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: url) { data, response, error in
            guard let data = data, let response = response, error == nil else {
                DispatchQueue.main.async {
                    //TODO: Implement Error Alerts!
                    magic("NOPE... :( \nerror: \(error)")
                    
                    //self.presentErrorAlert(alertParameters: (title: LocalizedStrings.AlertTitles.error, message: error!.localizedDescription))
                    
                    
                    
                }
                return
            }
            
            let httpResponse = response as! HTTPURLResponse
            
            if httpResponse.statusCode <= 116 && httpResponse.statusCode > 0 {
                magic("Error! status: \(HTTPURLResponse.localizedString(forStatusCode: httpResponse.statusCode))")
            }
            
            do {
                let jsonDictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String: AnyObject]
                // magic("jsonDictionary: \(jsonDictionary["photo"])")
                guard let photos = jsonDictionary["photos"] as? NSDictionary,
                let photoArray = photos["photo"] as? [NSDictionary] else {
                    //TODO: present error alert...
                    
                    magic("Something went terribly wrong")
                    return
                }
                
                let images = photoArray.map { photoElements -> Photo in
                    let id = photoElements["id"] as? String ?? ""
                    let farm = photoElements["farm"] as? Int ?? 0
                    let secret = photoElements["secret"] as? String ?? ""
                    let server = photoElements["server"] as? String ?? ""
                    let title = photoElements["title"] as? String ?? ""
                    
                    /// Build url
                    let url = "https://farm\(farm).staticflickr.com/\(server)/\(id)_\(secret)_m.jpg"
                    
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    let stack = appDelegate.stack
                    let intID = Int16(id)!
                    let photo = Photo(withId: intID, title: title, url: url, pin: pin, context: stack.context)

                    stack.save()
                    
                    return photo
                }
                /// Get back on the main queue before returning the info
                DispatchQueue.main.async {
//
                    completion(images)
                }
            }catch {
                fatalError("Not a JSON Dictionary :[")
            }
        }
        task.resume()
    }
    
}
