//
//  TXFloatingActionViewController.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 10/06/22.
//

import UIKit

class TXFloatingActionViewController: TXViewController {
    // Declare
    let containerView: TXView = {
        let containerView = TXView()
        
        containerView.enableAutolayout()
        
        return containerView
    }()
    
    let floatingAction: FloatingActionButton = {
        let floatingAction = FloatingActionButton()
        
        floatingAction.enableAutolayout()
        floatingAction.setImage(
            UIImage(systemName: "plus"),
            for: .normal
        )
        
        return floatingAction
    }()
    
    // Configure
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSubviews()
        
        configureContainerView()
        configureFloatingAction()
    }
    
    private func addSubviews() {
        view.addSubview(containerView)
        view.addSubview(floatingAction)
    }
    
    private func configureContainerView() {
        containerView.pin(
            to: view
        )
    }
    
    private func configureFloatingAction() {
        floatingAction.pin(
            toBottomOf: view,
            withInset: 20,
            byBeingSafeAreaAware: true
        )
        
        floatingAction.pin(
            toRightOf: view,
            withInset: 20,
            byBeingSafeAreaAware: true
        )
        
        floatingAction.addTarget(
            self,
            action: #selector(onFloatingActionPressed(_:)),
            for: .touchUpInside
        )
    }
    
    // Populate
    
    // Interact
    @objc private func onFloatingActionPressed(_ sender: UITapGestureRecognizer) {
        onFloatingActionPressed()
    }
    
    func onFloatingActionPressed() {
        
    }
}
