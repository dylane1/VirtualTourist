//
//  SegueHandlerType.swift
//  On The Map
//
//  Created by Dylan Edwards on 7/6/16.
//  Copyright © 2016 Slinging Pixels Media. All rights reserved.
//
/// https://www.natashatherobot.com/protocol-oriented-segue-identifiers-swift/

import UIKit

protocol SegueHandlerType {
    associatedtype SegueIdentifier: RawRepresentable
}

extension SegueHandlerType where Self: UIViewController, SegueIdentifier.RawValue == String {
    
    func performSegueWithIdentifier(segueIdentifier: SegueIdentifier, sender: AnyObject?) {
        performSegueWithIdentifier(segueIdentifier.rawValue, sender: sender)
    }
    
    func segueIdentifierForSegue(segue: UIStoryboardSegue) -> SegueIdentifier {
        // still have to use guard stuff here, but at least you're
        // extracting it this time
        guard let identifier = segue.identifier,
            segueIdentifier = SegueIdentifier(rawValue: identifier) else {
                fatalError("Invalid segue identifier \(segue.identifier).") }
        
        return segueIdentifier
    }
}
