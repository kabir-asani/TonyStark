//
//  ComposeViewController.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 16/03/22.
//

import UIKit

class ComposeViewController: TXTabBarController {
    // Declare
    private let composableTextView: TXTextView = {
        let composableTextView = TXTextView()
        
        composableTextView.enableAutolayout()
        composableTextView.font = .systemFont(
            ofSize: 16,
            weight: .regular
        )

        return composableTextView
    }()
    
    // Configure
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSubviews()
        
        configureNavigationBar()
        configureComposableTextView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        composableTextView.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        composableTextView.resignFirstResponder()
    }
    
    private func addSubviews() {
        view.addSubview(composableTextView)
    }
    
    private func configureNavigationBar() {
        navigationItem.title = "Compose"
        
        navigationItem.leftBarButtonItem = TXBarButtonItem(
            barButtonSystemItem: .cancel,
            target: self,
            action: #selector(onCancelPressed(_:))
        )
        
        navigationItem.rightBarButtonItem = TXBarButtonItem(
            title: "Tweet",
            style: .done,
            target: self,
            action: #selector(onDonePressed(_:))
        )
    }
    
    private func configureComposableTextView() {
        composableTextView.pin(
            to: view,
            withInsets: .all(16),
            byBeingSafeAreaAware: true
        )
    }
    
    // Populate
    
    // Interact
    @objc private func onDonePressed(_ sender: UIBarButtonItem) {
    }
    
    @objc private func onCancelPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
}
