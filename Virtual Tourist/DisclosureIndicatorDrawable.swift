//
//  DisclosureIndicatorDrawable.swift
//  Virtual Tourist
//
//  Created by Dylan Edwards on 7/12/16.
//  Copyright © 2016 Slinging Pixels Media. All rights reserved.
//

import UIKit

protocol DisclosureIndicatorDrawable { }

extension DisclosureIndicatorDrawable where Self: IconProviderProtocol {
    static func drawDisclosureIndicatorWithColor(fillColor color: UIColor = UIColor.black) {
        //// Symbolicons-Junior
        //// disclosureIndicator Drawing
        let fillColor = color
        
        let disclosureIndicatorPath = UIBezierPath()
        disclosureIndicatorPath.move(to: CGPoint(x: 13.37, y: 8.38))
        disclosureIndicatorPath.addCurve(to: CGPoint(x: 12.39, y: 8), controlPoint1: CGPoint(x: 13.1, y: 8.13), controlPoint2: CGPoint(x: 12.75, y: 8))
        disclosureIndicatorPath.addCurve(to: CGPoint(x: 11.41, y: 8.38), controlPoint1: CGPoint(x: 12.03, y: 8), controlPoint2: CGPoint(x: 11.68, y: 8.13))
        disclosureIndicatorPath.addCurve(to: CGPoint(x: 11.41, y: 10.24), controlPoint1: CGPoint(x: 10.86, y: 8.9), controlPoint2: CGPoint(x: 10.86, y: 9.73))
        disclosureIndicatorPath.addLine(to: CGPoint(x: 16.45, y: 15))
        disclosureIndicatorPath.addLine(to: CGPoint(x: 11.41, y: 19.76))
        disclosureIndicatorPath.addCurve(to: CGPoint(x: 11.41, y: 21.62), controlPoint1: CGPoint(x: 10.86, y: 20.27), controlPoint2: CGPoint(x: 10.86, y: 21.1))
        disclosureIndicatorPath.addCurve(to: CGPoint(x: 13.37, y: 21.62), controlPoint1: CGPoint(x: 11.95, y: 22.13), controlPoint2: CGPoint(x: 12.83, y: 22.13))
        disclosureIndicatorPath.addLine(to: CGPoint(x: 19.73, y: 15.62))
        disclosureIndicatorPath.addCurve(to: CGPoint(x: 19.73, y: 14.38), controlPoint1: CGPoint(x: 20.09, y: 15.28), controlPoint2: CGPoint(x: 20.09, y: 14.72))
        disclosureIndicatorPath.addLine(to: CGPoint(x: 13.37, y: 8.38))
        disclosureIndicatorPath.close()
        disclosureIndicatorPath.miterLimit = 4
        
        disclosureIndicatorPath.usesEvenOddFillRule = true
        
        fillColor.setFill()
        disclosureIndicatorPath.fill()
        
        //// Oval Drawing
        let ovalPath = UIBezierPath(ovalIn: CGRect(x: 3, y: 3, width: 24, height: 24))
        fillColor.setStroke()
        ovalPath.lineWidth = 1
        ovalPath.stroke()
    }
}
