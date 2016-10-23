//
//  PhotoAlbumCollectionViewCell.swift
//  Virtual Tourist
//
//  Created by Dylan Edwards on 9/12/16.
//  Copyright © 2016 Slinging Pixels Media. All rights reserved.
//

import UIKit

class PhotoAlbumCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageLoadingLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    //MARK: - Configuration
    
    internal func configure(withImageData imageData: NSData?) {
        let labelAttributes: [String : Any] = [
            NSStrokeColorAttributeName: Theme.textDark,
            NSStrokeWidthAttributeName: -3.0,
            NSForegroundColorAttributeName : Theme.textLight,
            NSFontAttributeName: UIFont(name: Constants.FontName.markerFelt, size: 14)!
        ]
        imageLoadingLabel.attributedText = NSAttributedString(string: LocalizedStrings.imageLoading, attributes: labelAttributes)
        
        imageLoadingLabel.adjustsFontSizeToFitWidth = true
        
        
        if imageData != nil {
            imageLoadingLabel.alpha = 0.0
            imageView.image = UIImage(data: imageData! as Data)
        } else {
            imageLoadingLabel.alpha = 1.0
            backgroundColor = Theme.presentationDimBGColor
        }
    }
}
