//
//  MapViewPinEditingStateMachine.swift
//  Virtual Tourist
//
//  Created by Dylan Edwards on 10/18/16.
//  Copyright © 2016 Slinging Pixels Media. All rights reserved.
//

import Foundation

enum MapState {
    case normalStateNoPins, normalStateWithPins, isSelecting, clearingSelected, clearingAll
}

final class MapViewStateMachine {
    internal var state: Dynamic<MapState>
    
    init() {
        state = Dynamic(.normalStateNoPins)
    }
}
