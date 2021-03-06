//
//  NavigationController.swift
//  Virtual Tourist
//
//  Created by Dylan Edwards on 5/18/16.
//  Copyright © 2016 Slinging Pixels Media. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController {
    
    internal func setNavigationBarAttributes(isAppTitle isTitle: Bool) {
        
        navigationBar.tintColor    = Theme.navBarTitleColor
        navigationBar.isTranslucent  = true
        
        var titleLabelAttributes: [String : AnyObject] = [NSForegroundColorAttributeName : Theme.navBarTitleColor]
        
        if isTitle {
            titleLabelAttributes[NSFontAttributeName] = UIFont(name: Constants.FontName.markerFelt, size: 18)!
        } else {
            titleLabelAttributes[NSFontAttributeName] = UIFont(name: Constants.FontName.avenirHeavy, size: 18)
        }
        
        navigationBar.titleTextAttributes = titleLabelAttributes
    }
}
