//
//  ReusableView.swift
//  Virtual Tourist
//
//  Created by Dylan Edwards on 6/20/16.
//  Copyright © 2016 Slinging Pixels Media. All rights reserved.
//

import UIKit

protocol ReusableView: class { }

extension ReusableView where Self: UIView {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
