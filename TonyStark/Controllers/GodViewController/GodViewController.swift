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
            
            if event is LogInEvent {
                strongSelf.switchToHomeViewController()
            }
            
            if event is LogOutEvent {
                strongSelf.switchToAuthenticationViewController()
            }
        }
    }
    
    private func switchToHomeViewController() {
        DispatchQueue.main.async {
            [weak self] in
            guard let strongSelf = self else {
                return
            }
            strongSelf.dismiss(animated: false)
            
            let homeViewController = HomeViewController()
            homeViewController.modalPresentationStyle = .fullScreen
            homeViewController.modalTransitionStyle = .crossDissolve
            
            strongSelf.present(
                homeViewController,
                animated: true
            )
        }
        
    }
    
    private func switchToAuthenticationViewController() {
        DispatchQueue.main.async {
            [weak self] in
            guard let strongSelf = self else {
                return
            }
            
            strongSelf.dismiss(animated: false)
            
            let authenticationViewController = AuthenticationViewController()
            authenticationViewController.modalPresentationStyle = .fullScreen
            authenticationViewController.modalTransitionStyle = .crossDissolve
            
            strongSelf.present(
                authenticationViewController,
                animated: true
            )
        }
    }
    
    // Populate
    
    // Interact
}
