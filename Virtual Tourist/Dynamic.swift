//
//  Dynamic.swift
//
//  Created by Dylan Edwards on 12/2/15.
//  Copyright © 2015 Slinging Pixels Media. All rights reserved.
//

/** 
 * Adapted from these two blog posts:
 *
 * http://five.agency/solving-the-binding-problem-with-swift/
 * http://rasic.info/bindings-generics-swift-and-mvvm/
 *
 */
//TODO: Can this cause retain cycles?

class Dynamic<T> {
    
    typealias Listener = (T) -> Void
    var listener: Listener?
    
    func bind(listener: Listener?) {
        self.listener = listener
    }
    
    func bindAndFire(listener: Listener?) {
        self.listener = listener
        listener?(value)
    }
    
    var value: T {
        didSet {
            listener?(value)
        }
    }
    
    init(_ v: T) {
        value = v
    }
}
