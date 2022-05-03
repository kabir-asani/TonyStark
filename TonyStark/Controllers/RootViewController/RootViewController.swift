//
//  MainViewController.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 30/04/22.
//

import Foundation

class HomeEvent: TXEvent { }
class AuthenticationEvent: TXEvent { }

class RootViewController: TXViewController {
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
                strongSelf.dismiss(animated: true)
                
                
                let homeViewController = HomeViewController()
                homeViewController.modalPresentationStyle = .fullScreen
                homeViewController.modalTransitionStyle = .crossDissolve
                
                strongSelf.present(
                    homeViewController,
                    animated: true
                )
            }
            
            if event is AuthenticationEvent {
                strongSelf.dismiss(animated: true)
                
                let authenticationViewController = AuthenticationViewController()
                authenticationViewController.modalPresentationStyle = .fullScreen
                authenticationViewController.modalTransitionStyle = .crossDissolve
                
                strongSelf.present(
                    authenticationViewController,
                    animated: true
                )
            }
        }
    }
}
