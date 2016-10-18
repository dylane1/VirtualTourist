//
//  PhotoAlbumCollectionViewCell.swift
//  Virtual Tourist
//
//  Created by Dylan Edwards on 9/12/16.
//  Copyright © 2016 Slinging Pixels Media. All rights reserved.
//

import UIKit

class PhotoAlbumCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    //MARK: - Configuration
    
    internal func configure(withImageData imageData: NSData?) {
        if imageData != nil {
//            magic("data for image is here...")
            imageView.image = UIImage(data: imageData! as Data)
        } else {
//            imageView.backgroundColor = UIColor.purple
            //TODO: load a placeholder
//            magic("no image data for cell")
        }
    }
}
