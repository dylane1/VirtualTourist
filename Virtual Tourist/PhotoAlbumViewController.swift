//
//  PhotoAlbumViewController.swift
//  Virtual Tourist
//
//  Created by Dylan Edwards on 8/26/16.
//  Copyright © 2016 Slinging Pixels Media. All rights reserved.
//

import UIKit
import MapKit
import CustomPresentation

class PhotoAlbumViewController: UIViewController {

    fileprivate var photoAlbumView: PhotoAlbumView!
    private var pin: Pin!
    
    private var overlayTransitioningDelegate: OverlayTransitioningDelegate?
    private var photoViewController: PhotoContainerViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = pin.title!
        
        let navController = navigationController! as! NavigationController
        navController.setNavigationBarAttributes(isAppTitle: false)
        
        photoAlbumView = view as! PhotoAlbumView
        
        let openPhotoHandler = { [weak self] (photo: Photo, indexPath: IndexPath, isSelected: Bool) in
            self!.openPhotoContainerViewControllerForPhoto(photo, atIndexPath: indexPath, isSelectedForDeletion: isSelected)
        }
        
        photoAlbumView.configure(withPin: pin, openPhotoHandler: openPhotoHandler)
    }
    
    //MARK: - Configuration
    
    internal func configure(withPin pin: Pin) {
        self.pin = pin
    }
    
    //MARK: - Photo presentation
    
    private func openPhotoContainerViewControllerForPhoto(_ photo: Photo, atIndexPath indexPath: IndexPath, isSelectedForDeletion isSelected: Bool) {
        
        photoViewController = UIStoryboard(name: Constants.StoryBoardID.main, bundle: nil).instantiateViewController(withIdentifier: Constants.StoryBoardID.photoContainer) as? PhotoContainerViewController
        
        let selectionToggleHandler = { [weak self] (photoIndexPath: IndexPath) in
            self!.photoAlbumView.toggleCellSelectionAtIndexPath(photoIndexPath)
        }
        photoViewController!.configure(withPhoto: photo, atIndexPath: indexPath, isSelectedForDeletion: isSelected, toggleHandler: selectionToggleHandler)
        
        let image = UIImage(data: photo.imageData! as Data)
        
        let width = image!.size.width + 16
        let height = image!.size.height + 74
        
        let photoVCPreferredContentSize = CGSize(width: width, height: height)
        
        let dismissalCompletion = { [weak self] in
            self!.overlayTransitioningDelegate  = nil
            self!.photoViewController           = nil
        }
        
        overlayTransitioningDelegate = OverlayTransitioningDelegate()
        
        overlayTransitioningDelegate!.configureTransitionWithContentSize(photoVCPreferredContentSize, options: [
            .dimmingBGColor : Theme.presentationDimBGColor,
            .inFromPosition : Position.center,
            .outToPosition : Position.center,
            .alphaIn : true,
            .alphaOut : true,
            .tapToDismiss:  true,
            .scaleIn : true,
            .scaleOut : true
            ], dismissalCompletion: dismissalCompletion)
        
        photoViewController!.transitioningDelegate = overlayTransitioningDelegate!
        photoViewController!.modalPresentationStyle = .custom
        
        present(photoViewController!, animated: true, completion: nil)
        
    }

}

extension PhotoAlbumViewController {
    /** Resize cells upon rotation */
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        photoAlbumView.layoutCollectionView()
    }
}

