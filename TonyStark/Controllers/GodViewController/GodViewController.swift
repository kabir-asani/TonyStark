//
//  MainViewController.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 30/04/22.
//

import UIKit

class GodViewController: TXViewController {
    // Declare
    
    // Configure
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureEventListener()
    }
    
    private func configureEventListener() {
        TXEventBroker.shared.listen {
            [weak self] event in
            guard let strongSelf = self else {
                return
            }
            
            if event is HomeEvent {
                strongSelf.switchToHomeViewController()
            }
            
            if event is AuthenticationEvent {
                strongSelf.switchToAuthenticationViewController()
            }
        }
    }
    
    private func switchToHomeViewController() {
        dismiss(animated: false)
        
        let homeViewController = HomeViewController()
        homeViewController.modalPresentationStyle = .fullScreen
        homeViewController.modalTransitionStyle = .crossDissolve
        
        present(
            homeViewController,
            animated: true
        )
    }
    
    private func switchToAuthenticationViewController() {
        dismiss(animated: false)
        
        let authenticationViewController = AuthenticationViewController()
        authenticationViewController.modalPresentationStyle = .fullScreen
        authenticationViewController.modalTransitionStyle = .crossDissolve
        
        present(
            authenticationViewController,
            animated: true
        )
    }
    
    // Populate
    
    // Interact
}
