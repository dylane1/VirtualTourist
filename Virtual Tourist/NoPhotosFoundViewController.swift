//
//  NoPhotosFoundViewController.swift
//  Virtual Tourist
//
//  Created by Dylan Edwards on 10/21/16.
//  Copyright © 2016 Slinging Pixels Media. All rights reserved.
//

import UIKit

class NoPhotosFoundViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var label0: UILabel!
    
    //MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureLabels()
    }
    
    //MARK: - Configuration
    
    private func configureLabels() {
        label0.adjustsFontSizeToFitWidth = true
        
        let labelAttributes: [String : Any] = [
            NSStrokeColorAttributeName: Theme.textLink,
            NSStrokeWidthAttributeName: -3.0,
            NSForegroundColorAttributeName : Theme.textLight,
            NSFontAttributeName: UIFont(name: Constants.FontName.markerFelt, size: 20)!
        ]
        
        label0.attributedText = NSAttributedString(string: LocalizedStrings.noPhotosFound, attributes: labelAttributes)
    }

}
