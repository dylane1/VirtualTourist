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
    
    internal func configure(withURL url: String) {
        magic("url: \(url)")
    }
}
