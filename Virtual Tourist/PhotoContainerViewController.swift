//
//  PhotoContainerViewController.swift
//  Virtual Tourist
//
//  Created by Dylan Edwards on 10/24/16.
//  Copyright © 2016 Slinging Pixels Media. All rights reserved.
//

import UIKit

class PhotoContainerViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var toggleDeleteButton: UIButton!
    
    @IBOutlet weak var imageViewHeight: NSLayoutConstraint!
    @IBOutlet weak var imageViewWidth: NSLayoutConstraint!
    
    private var titleString = ""
    private var imageData: Data!
    private var indexPathInCollection: IndexPath!
    private var isSelectedForDeletion = false
    
    private var toggleCompletion: ((IndexPath) -> Void)!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTitleLabel()
        configureImageView()
        configureButton()
        prettyIt()
    }

    //MARK: - Configuration
    
    internal func configure(withPhoto photo: Photo, atIndexPath indexPath: IndexPath, isSelectedForDeletion isSelected: Bool, toggleHandler completion: @escaping (IndexPath) -> Void) {
        titleString             = photo.title!
        imageData               = photo.imageData! as Data!
        indexPathInCollection   = indexPath
        isSelectedForDeletion   = isSelected
        toggleCompletion        = completion
    }
    
    private func configureTitleLabel() {
        titleLabel.text = (titleString == "") ? LocalizedStrings.PhotoViewerVC.defaultTitle : titleString
    }
    
    private func configureImageView() {
        let image = UIImage(data: imageData)
        imageViewWidth.constant  = image!.size.width
        imageViewHeight.constant = image!.size.height
        
        imageView.image = image!
        imageView.alpha = (isSelectedForDeletion) ? 0.5 : 1.0
    }
    
    private func configureButton() {
        toggleDeleteButton.addTarget(self, action: #selector(toggleForDeletion), for: .touchUpInside)
        toggleDeleteButton.tintColor = UIColor.red
        
        let buttonTitle = (isSelectedForDeletion) ? LocalizedStrings.PhotoViewerVC.unmarkForDeletion : LocalizedStrings.PhotoViewerVC.markForDeletion
        
        toggleDeleteButton.setTitle(buttonTitle, for: .normal)
        
    }
    
    private func prettyIt() {
        view.layer.cornerRadius     = 6
        view.layer.shadowColor      = UIColor.black.cgColor
        view.layer.shadowOpacity    = 0.6
        view.layer.shadowRadius     = 10
        view.layer.shadowOffset     = CGSize(width: 5, height: 5)
        view.layer.masksToBounds    = false
    }
    
    //MARK: - 
    
    internal func toggleForDeletion() {
        isSelectedForDeletion = (isSelectedForDeletion) ? false : true
        configureImageView()
        configureButton()
        toggleCompletion(indexPathInCollection)
    }
}
