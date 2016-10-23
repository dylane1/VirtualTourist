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
    //TODO: Need to test empty image sets returned from flickr
    static func fetchImagesForPin(_ pin: Pin, pageNumber page: Int16, withCompletion completion: @escaping (Bool) -> Void) {
        let lat = pin.latitude
        let lon = pin.longitude
        
        var hasPhotos = false
        
        /// Build querey
        /**
         * API Documentation:  https://www.flickr.com/services/api/flickr.photos.search.html
         **/
        let queryString = "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=\(Constants.Flickr.key)&lat=\(lat)&lon=\(lon)&per_page=16&page=\(page)&format=json&nojsoncallback=1"
        
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
                
                guard let photos = jsonDictionary["photos"] as? NSDictionary,
                let photoArray = photos["photo"] as? [NSDictionary] else {
                    //TODO: present error alert...
                    
                    magic("Something went terribly wrong")
                    return
                }
                if photoArray.count > 0 {
                    hasPhotos = true
                    if page > 1 {
                        /**
                         * This is a new collection fetch that was successful
                         * so clear out the old photos before adding the new.
                         */
                        pin.photos = nil
                    }
                }
                
                _ = photoArray.map { photoElements -> Photo in
                    let id = photoElements["id"] as? String ?? ""
                    let farm = photoElements["farm"] as? Int ?? 0
                    let secret = photoElements["secret"] as? String ?? ""
                    let server = photoElements["server"] as? String ?? ""
                    let title = photoElements["title"] as? String ?? ""
                    
                    /// Build url
                    let url = "https://farm\(farm).staticflickr.com/\(server)/\(id)_\(secret)_m.jpg"
                    
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    let stack = appDelegate.stack
                    
                    let photo = Photo(withId: Int64(id)!, title: title, url: url, pin: pin, context: stack.context)
                    
                    stack.save()
                    return photo
                }
                /// Get back on the main queue before returning the info
                DispatchQueue.main.async {
                    completion(hasPhotos)
                }
            }catch {
                fatalError("Not a JSON Dictionary :[")
            }
        }
        task.resume()
    }
    
    static func fetchImageDataForPhoto(_ photo: Photo, completion: (() -> Void)? = nil) {
        let url = URL(string: photo.url!)!
        
        let session = URLSession.shared
        
        let task = session.downloadTask(with: url, completionHandler: { (location: URL?, response: URLResponse?, error: Error?) -> Void in
            
            guard let location = location, error == nil else {
                magic("image data download error: \(error)")
                return
            }
            
            guard let data = try? Data(contentsOf: location) else {
                magic("couldn't get data from locatoin")
                return
            }
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let stack = appDelegate.stack
            
            photo.imageData = data as NSData?
            
            stack.save()
            
            DispatchQueue.main.async {
                completion?()
            }
        })
        task.resume()
    }
}





























