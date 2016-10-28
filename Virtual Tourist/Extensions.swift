//
//  Extensions.swift
//  Virtual Tourist
//
//  Created by Dylan Edwards on 8/23/16.
//  Copyright © 2016 Slinging Pixels Media. All rights reserved.
//

import UIKit
import MapKit

extension MKPinAnnotationView: ReusableView { }
extension UICollectionViewCell: ReusableView { }

extension UICollectionView {
    internal func dequeueReusableCell<T: UICollectionViewCell>(forIndexPath indexPath: IndexPath) -> T where T: ReusableView {
        guard let cell = dequeueReusableCell(withReuseIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            fatalError("No way, Jose... could not dequeue cell w/ identifier: \(T.reuseIdentifier)")
        }
        return cell
    }
}
