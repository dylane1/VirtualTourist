//
//  NavigateRightIconDrawable.swift
//  On The Map
//
//  Created by Dylan Edwards on 7/12/16.
//  Copyright © 2016 Slinging Pixels Media. All rights reserved.
//

import UIKit

protocol DisclosureIndicatorDrawable { }

extension DisclosureIndicatorDrawable where Self: IconProviderProtocol {
    static func draw20PointDisclosureIndicatorWithColor(fillColor color: UIColor = UIColor.blackColor()) {
        //// Symbolicons-Junior
        //// disclosureIndicator Drawing
        let fillColor = color
        
        let disclosureIndicatorPath = UIBezierPath()
        disclosureIndicatorPath.moveToPoint(CGPoint(x: 8.37, y: 3.38))
        disclosureIndicatorPath.addCurveToPoint(CGPoint(x: 7.39, y: 3), controlPoint1: CGPoint(x: 8.1, y: 3.13), controlPoint2: CGPoint(x: 7.75, y: 3))
        disclosureIndicatorPath.addCurveToPoint(CGPoint(x: 6.41, y: 3.38), controlPoint1: CGPoint(x: 7.03, y: 3), controlPoint2: CGPoint(x: 6.68, y: 3.13))
        disclosureIndicatorPath.addCurveToPoint(CGPoint(x: 6.41, y: 5.24), controlPoint1: CGPoint(x: 5.86, y: 3.9), controlPoint2: CGPoint(x: 5.86, y: 4.73))
        disclosureIndicatorPath.addLineToPoint(CGPoint(x: 11.45, y: 10))
        disclosureIndicatorPath.addLineToPoint(CGPoint(x: 6.41, y: 14.76))
        disclosureIndicatorPath.addCurveToPoint(CGPoint(x: 6.41, y: 16.62), controlPoint1: CGPoint(x: 5.86, y: 15.27), controlPoint2: CGPoint(x: 5.86, y: 16.1))
        disclosureIndicatorPath.addCurveToPoint(CGPoint(x: 8.37, y: 16.62), controlPoint1: CGPoint(x: 6.95, y: 17.13), controlPoint2: CGPoint(x: 7.83, y: 17.13))
        disclosureIndicatorPath.addLineToPoint(CGPoint(x: 14.73, y: 10.62))
        disclosureIndicatorPath.addCurveToPoint(CGPoint(x: 14.73, y: 9.38), controlPoint1: CGPoint(x: 15.09, y: 10.28), controlPoint2: CGPoint(x: 15.09, y: 9.72))
        disclosureIndicatorPath.addLineToPoint(CGPoint(x: 8.37, y: 3.38))
        disclosureIndicatorPath.closePath()
        disclosureIndicatorPath.miterLimit = 4
        
        disclosureIndicatorPath.usesEvenOddFillRule = true
        
        fillColor.setFill()
        disclosureIndicatorPath.fill()
    }
}
