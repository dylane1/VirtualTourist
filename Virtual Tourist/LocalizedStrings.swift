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
        static let message      = NSLocalizedString("NoPhotosFoundAlert.message", value: "No photos were found for this location. Would you like to keep this pin or delete?", comment: "")
        static let deleteButton = NSLocalizedString("NoPhotosFoundAlert.delete", value: "Delete", comment: "")
        static let keepButton   = NSLocalizedString("NoPhotosFoundAlert.keep", value: "Keep", comment: "")
    }
    
    struct EndOfPhotosReached {
        static let title            = NSLocalizedString("EndOfPhotosReached.title", value: "No More Photos Available", comment: "")
        static let message          = NSLocalizedString("EndOfPhotosReached.message", value: "There are no more photos on Flickr associated with this location. Would you like to return to the beginning?", comment: "")
        static let noThanksButton   = NSLocalizedString("EndOfPhotosReached.noThanksButton", value: "No Thanks", comment: "")
        static let okButton         = NSLocalizedString("EndOfPhotosReached.okButton", value: "OK", comment: "")
    }
    struct PhotoViewerVC {
        static let defaultTitle = NSLocalizedString("PhotoViewerVC.defaultTitle", value: "Untitled", comment: "")
        static let markForDeletion = NSLocalizedString("PhotoViewerVC.markForDeletion", value: "Mark For Deletion", comment: "")
        static let unmarkForDeletion = NSLocalizedString("PhotoViewerVC.unmarkForDeletion", value: "Unmark For Deletion", comment: "")
    }
    
    static let noPhotosFound    = NSLocalizedString("noPhotosFound", value: "No Photos Found", comment: "")
    static let imageLoading     = NSLocalizedString("imageLoading", value: "Loading Image", comment: "")
    static let unknownPlace     = NSLocalizedString("unknownPlace", value: "Unknown Place", comment: "")
}
