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
 * October 19, 2016: I edited this to allow for multiple listeners
 *
 */

class Dynamic<T> {
    
    typealias Listener = (T) -> Void
    private var listeners = [Listener?]()
    
    internal func bind(listener: Listener?) {
        listeners.append(listener)
    }
    
    internal func bindAndFire(listener: Listener?) {
        listeners.append(listener)
        listener?(value)
    }
    
    internal var value: T {
        didSet {
            for listener in listeners {
                listener?(value)
            }
        }
    }
    
    init(_ v: T) {
        value = v
    }
}
