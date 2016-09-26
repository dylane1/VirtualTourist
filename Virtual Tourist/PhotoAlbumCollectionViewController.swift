//
//  PhotoAlbumCollectionViewController.swift
//  Virtual Tourist
//
//  Created by Dylan Edwards on 9/12/16.
//  Copyright © 2016 Slinging Pixels Media. All rights reserved.
//

import UIKit
import CoreData

final class PhotoAlbumCollectionViewController: UICollectionViewController {
    var photos = [NSManagedObject]()
    
    var fetchedResultsController: NSFetchedResultsController<Photo>? {
        didSet{
            // Whenever the frc changes, we execute the search and
            // reload the table
            fetchedResultsController?.delegate = self
//            executeSearch()
//            tableView.reloadData()
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
//        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    //MARK: - Configuration
    internal func configure(withPin pin: Pin) {
        /// Fetch?
        
        
        /// Start getting images
    
    //        let tempCompletion = { (images: [Image]?) in
    //            guard let images = images as [Image]! else { return }
    //
    //            for image in images {
    //                magic("title: \(image.title); url: \(image.url)")
    //            }
    //        }
    //        FlickrProvider.fetchImagesForLocation(CLLocation(latitude: self.draggableAnnotation!.coordinate.latitude, longitude: self.draggableAnnotation!.coordinate.longitude), withCompletion: tempCompletion)
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if fetchedResultsController?.fetchedObjects != nil {
            return (fetchedResultsController?.fetchedObjects!.count)!
        }
        return 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let photo = fetchedResultsController!.object(at: indexPath) 
        
        let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as PhotoAlbumCollectionViewCell
    
        // Configure the cell
        cell.configure(withImageData: photo.imageData!)
        
        return cell
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
    
    }
    */

}

extension PhotoAlbumCollectionViewController: NSFetchedResultsControllerDelegate {
    
}


