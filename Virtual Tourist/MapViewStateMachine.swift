//
//  MapViewPinEditingStateMachine.swift
//  Virtual Tourist
//
//  Created by Dylan Edwards on 10/18/16.
//  Copyright © 2016 Slinging Pixels Media. All rights reserved.
//

import Foundation

enum MapState {
    case isSelecting, clearingAll, normalState
}

final class MapViewStateMachine {
    internal var state: Dynamic<MapState>
//    internal var isEditing: Dynamic<Bool>
    
    init() {
        state = Dynamic(.normalState)
//        isEditing = Dynamic(false)
    }
}
