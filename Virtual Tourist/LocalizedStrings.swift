//
//  LocalizedStrings.swift
//  Virtual Tourist
//
//  Created by Dylan Edwards on 8/23/16.
//  Copyright © 2016 Slinging Pixels Media. All rights reserved.
//

import Foundation

struct LocalizedStrings {
    struct ViewControllerTitles {
        static let virtualTourist = NSLocalizedString("ViewControllerTitles.virtualTourist", value: "Virtual Tourist", comment: "")
    }
    
    struct NavigationControllerButtons {
        static let editPins         = NSLocalizedString("NavigationControllerButtons.editPins", value: "Edit Pins", comment: "")
        static let clearSelected    = NSLocalizedString("NavigationControllerButtons.clearSelected", value: "Clear Selected", comment: "")
        static let clearAll         = NSLocalizedString("NavigationControllerButtons.clearAll", value: "Clear All", comment: "")
    }
    struct ToolbarButtons {
        static let newCollection    = NSLocalizedString("ToolbarButtons.newCollection", value: "New Collection", comment: "")
        static let removeSelected   = NSLocalizedString("ToolbarButtons.removeSelected", value: "Remove Selected", comment: "")
    }
    
    struct NoPhotosFoundAlert {
        static let title        = LocalizedStrings.noPhotosFound
        static let message      = NSLocalizedString("AlertViewButtons.message", value: "No photos were found for this location. Would you like to keep this pin or delete?", comment: "")
        static let deleteButton = NSLocalizedString("AlertViewButtons.delete", value: "Delete", comment: "")
        static let keepButton   = NSLocalizedString("AlertViewButtons.keep", value: "Keep", comment: "")
    }
    
    static let noPhotosFound    = NSLocalizedString("noPhotosFound", value: "No Photos Found", comment: "")
    static let imageLoading     = NSLocalizedString("imageLoading", value: "Loading Image", comment: "")
    static let unknownPlace     = NSLocalizedString("unknownPlace", value: "Unknown Place", comment: "")
}
