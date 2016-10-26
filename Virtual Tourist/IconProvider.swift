//
//  IconProvider.swift
//  On The Map
//
//  Created by Dylan Edwards on 7/10/16.
//  Copyright © 2016 Slinging Pixels Media. All rights reserved.
//
/// Icon bezier drawing code generated in PaintCode

import UIKit

enum Icon: String {
    case Pin
    case Map
    case List
    case LocationMarker
    case LocationMarker30Point
    case DisclosureIndicator
    case MapButton
    case Annotation
}

protocol IconProviderProtocol {
    static func imageOfDrawnIcon(icon: Icon, size: CGSize, fillColor: UIColor, shadowColor: UIColor) -> UIImage
}

struct IconProvider { }

extension IconProvider: IconProviderProtocol,
                        PinIconDrawable,
                        MapIconDrawable,
                        ListIconDrawable,
                        LocationMarkerIconDrawable,
                        DisclosureIndicatorDrawable,
                        MapButtonDrawable,
                        AnnotationDrawable{
    
    static func imageOfDrawnIcon(icon: Icon, size: CGSize, fillColor: UIColor = UIColor.blackColor(), shadowColor: UIColor = UIColor.blackColor()) -> UIImage {
        var image: UIImage {
            
            UIGraphicsBeginImageContextWithOptions(CGSizeMake(size.width, size.height), false, 0)
            
            switch icon {
            case .Pin:
                draw32PointPinWithColor(fillColor: fillColor)
            case .Map:
                draw30PointMapWithColor(fillColor: fillColor)
            case .List:
                draw30PointListWithColor(fillColor: fillColor)
            case .LocationMarker:
                drawLocationMarkerWithColor(fillColor: fillColor)
            case .LocationMarker30Point:
                draw30PointLocationMarkerWithColor(fillColor: fillColor)
            case .DisclosureIndicator:
                draw20PointDisclosureIndicatorWithColor(fillColor: fillColor)
            case .MapButton:
                draw30PointMapButtonWithColor(fillColor: fillColor)
            case .Annotation:
                drawAnnotationMarker()
            }
            
            let img = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
            
            return img
        }
        return image
    }
}



































