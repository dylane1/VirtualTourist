//
//  MapViewNavigationController.swift
//  Virtual Tourist
//
//  Created by Dylan Edwards on 10/18/16.
//  Copyright © 2016 Slinging Pixels Media. All rights reserved.
//

import UIKit

final class MapViewNavigationController: NavigationController {
//    private var deleteSelected: ((Bool) -> Void)?
//    private var deleteAll: (() -> Void)?
    
    /// This is set by the stateMachine, not directly
    private var state: MapState = .normalState {
        didSet {
            magic("just set state to: \(state)")
//            updateButtonsEnabled()
        }
    }
    private var stateMachine: MapViewStateMachine! {
        didSet {
            stateMachine.state.bind {
                self.state = $0
            }
        }
    }
    
//    private var isSelecting = false
    
    private var editPinsButton: UIBarButtonItem!
    
    //MARK: - Configuration
    
    internal func configure(withStateMachine stateMachine: MapViewStateMachine) {
//        self.deleteSelected = deleteSelected
//        self.deleteAll      = deleteAll
        self.stateMachine = stateMachine
        configureNavigationItems()
    }
//    internal func configure(withDeleteSelected deleteSelected: @escaping (Bool) -> Void, withDeleteAll deleteAll: @escaping () -> Void) {
//        self.deleteSelected = deleteSelected
//        self.deleteAll      = deleteAll
//        
//        configureNavigationItems()
//    }
    
    private func configureNavigationItems() {
//        var rightItemArray  = [UIBarButtonItem]()
        
        editPinsButton = UIBarButtonItem(
            title: LocalizedStrings.NavigationControllerButtons.editPins,
            style: .plain,
            target: self,
            action: #selector(editPinsButtonTapped))
        navigationBar.topItem?.rightBarButtonItem = editPinsButton
        
        let clearAllButton = UIBarButtonItem(
            title: LocalizedStrings.NavigationControllerButtons.clearAll,
            style: .plain,
            target: self,
            action: #selector(clearAllButtonTapped))
        
        navigationBar.topItem?.leftBarButtonItem = clearAllButton
    }
    
    private func setButtonTitle() {
        editPinsButton.title = (state == .isSelecting) ? LocalizedStrings.NavigationControllerButtons.clearSelected : LocalizedStrings.NavigationControllerButtons.editPins
    }
    
    
    //MARK: - Actions
    
    internal func editPinsButtonTapped() {
        stateMachine.state.value = (state == .isSelecting) ? .normalState : .isSelecting
        
//        isSelecting = (isSelecting) ? false : true
//        deleteSelected?(isSelecting)
        setButtonTitle()
    }
    
    internal func clearAllButtonTapped() {
        stateMachine.state.value = .clearingAll
    }
}




















