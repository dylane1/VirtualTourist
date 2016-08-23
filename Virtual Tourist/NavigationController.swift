//
//  NavigationController.swift
//  On The Map
//
//  Created by Dylan Edwards on 5/18/16.
//  Copyright © 2016 Slinging Pixels Media. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController {
    
    internal func setNavigationBarAttributes(isAppTitle isTitle: Bool) {
        
        navigationBar.barTintColor = Theme.barTintColor
        navigationBar.tintColor    = Theme.buttonTint
        navigationBar.translucent  = true
        
        var titleLabelAttributes: [String : AnyObject] = [NSForegroundColorAttributeName : Theme.textLight]
        
        if isTitle {
            titleLabelAttributes[NSFontAttributeName] = UIFont(name: Constants.FontName.markerFelt, size: 24)!
        } else {
            titleLabelAttributes[NSFontAttributeName] = UIFont(name: Constants.FontName.avenirBlack, size: 14)
        }
        
        navigationBar.titleTextAttributes = titleLabelAttributes
    }
}
