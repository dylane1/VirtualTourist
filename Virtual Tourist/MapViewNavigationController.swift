//
//  MapViewNavigationController.swift
//  Virtual Tourist
//
//  Created by Dylan Edwards on 10/18/16.
//  Copyright © 2016 Slinging Pixels Media. All rights reserved.
//

import UIKit

final class MapViewNavigationController: NavigationController {
    
    /// This is set by the stateMachine, not directly
    private var state: MapState = .normalStateNoPins {
        didSet {
            setupButtons()
        }
    }
    private var stateMachine: MapViewStateMachine! {
        didSet {
            stateMachine.state.bind {
                self.state = $0
            }
        }
    }
    
    private var editPinsButton: UIBarButtonItem!
    private var clearAllPinsButton: UIBarButtonItem!
    
    //MARK: - Configuration
    
    internal func configure(withStateMachine stateMachine: MapViewStateMachine) {
        self.stateMachine = stateMachine
        configureNavigationItems()
    }
    
    private func configureNavigationItems() {
        
        editPinsButton = UIBarButtonItem(
            title: LocalizedStrings.NavigationControllerButtons.editPins,
            style: .plain,
            target: self,
            action: #selector(editPinsButtonTapped))
        
        navigationBar.topItem?.rightBarButtonItem = editPinsButton
        
        clearAllPinsButton = UIBarButtonItem(
            title: LocalizedStrings.NavigationControllerButtons.clearAll,
            style: .plain,
            target: self,
            action: #selector(clearAllButtonTapped))
        
        navigationBar.topItem?.leftBarButtonItem = clearAllPinsButton
        setupButtons()
    }
    
    private func setupButtons() {
        switch state {
        case .normalStateNoPins:
            editPinsButton.title            = LocalizedStrings.NavigationControllerButtons.editPins
            editPinsButton.isEnabled        = false
            clearAllPinsButton.isEnabled    = false
        case .normalStateWithPins:
            editPinsButton.title            = LocalizedStrings.NavigationControllerButtons.editPins
            editPinsButton.isEnabled        = true
            clearAllPinsButton.isEnabled    = true
        case .isSelecting:
            editPinsButton.title = LocalizedStrings.NavigationControllerButtons.clearSelected
            editPinsButton.isEnabled = true
        default:
            break
        }
    }
    
    
    //MARK: - Actions
    
    internal func editPinsButtonTapped() {
        switch state {
        case .normalStateWithPins:
            stateMachine.state.value = .isSelecting
        case .isSelecting:
            stateMachine.state.value = .clearingSelected
        default:
            break
        }
    }
    
    internal func clearAllButtonTapped() {
        stateMachine.state.value = .clearingAll
    }
}
