//
//  MainViewController.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 30/04/22.
//

import Foundation

class HomeEvent: TXEvent { }
class AuthenticationEvent: TXEvent { }

class MainViewController: TXNavigationController {
    init() {
        super.init(rootViewController: TXViewController())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar()
        configureEventListener()
    }
    
    private func configureNavigationBar() {
        navigationBar.isHidden = true
    }
    
    private func configureEventListener() {
        TXEventBroker.shared.listen {
            [weak self] event in
            guard let strongSelf = self else {
                return
            }
            
            if event is HomeEvent {
                strongSelf.setViewControllers(
                    [HomeViewController()],
                    animated: true
                )
            } else {
                strongSelf.setViewControllers(
                    [AuthenticationViewController()],
                    animated: false
                )
            }
        }
    }
}
