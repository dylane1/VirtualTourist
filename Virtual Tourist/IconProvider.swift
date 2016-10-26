//
//  IconProvider.swift
//  Virtual Tourist
//
//  Created by Dylan Edwards on 7/10/16.
//  Copyright © 2016 Slinging Pixels Media. All rights reserved.
//
/// Icon bezier drawing code generated in PaintCode

import UIKit

enum Icon: String {
    /*case Pin
    case Map
    case List
    case LocationMarker
    case LocationMarker30Point*/
    case disclosureIndicator
}

protocol IconProviderProtocol {
    static func imageOfDrawnIcon(icon: Icon, size: CGSize, fillColor: UIColor, shadowColor: UIColor) -> UIImage
}

struct IconProvider { }

extension IconProvider: IconProviderProtocol, DisclosureIndicatorDrawable {
    
    static func imageOfDrawnIcon(icon: Icon, size: CGSize, fillColor: UIColor = UIColor.black, shadowColor: UIColor = UIColor.black) -> UIImage {
        var image: UIImage {
            
            UIGraphicsBeginImageContextWithOptions(CGSize(width: size.width, height: size.height), false, 0)
            
            switch icon {
            case .disclosureIndicator:
                drawDisclosureIndicatorWithColor(fillColor: fillColor)
            }
            
            let img = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
            
            return img
        }
        return image
    }
}



































