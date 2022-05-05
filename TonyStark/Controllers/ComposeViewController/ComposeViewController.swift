//
//  ComposeViewController.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 16/03/22.
//

import UIKit

class ComposeViewController: TXViewController {
    // Declare
    private let compose: Composer = {
        let compose = Composer()
        
        compose.enableAutolayout()
        
        return compose
    }()
    
    private let separator: TXView = {
        let separator = TXView()
        
        separator.enableAutolayout()
        separator.backgroundColor = .separator
        separator.fixHeight(to: 1)
        
        return separator
    }()
    
    private let composeBottomBar: ComposeBottomBar = {
        let composeBottomBar = ComposeBottomBar()
        
        composeBottomBar.enableAutolayout()
        
        return composeBottomBar
    }()
    
    // Configure
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSubviews()
        
        configureNavigationBar()
        configureCompose()
        configureSeparator()
        configureComposeBottomBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        startKeyboardAwareness()
        compose.focusTextView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        stopKeyboardAwareness()
    }
    
    private func addSubviews() {
        view.addSubview(compose)
        view.addSubview(separator)
        view.addSubview(composeBottomBar)
    }
    
    private func configureNavigationBar() {
        navigationItem.leftBarButtonItem = TXBarButtonItem(
            barButtonSystemItem: .cancel,
            target: self,
            action: #selector(onCancelPressed(_:))
        )
        
        let tweetBarButtonItem = TXBarButtonItem(
            title: "Tweet",
            style: .done,
            target: self,
            action: #selector(onDonePressed(_:))
        )
        
        tweetBarButtonItem.tintColor = .systemBlue
        
        navigationItem.rightBarButtonItem = tweetBarButtonItem
    }
    
    private func configureCompose() {
        compose.configure(
            withUser: CurrentUserDataStore.shared.user!
        )
        
        compose.delegate = self
        
        compose.pin(
            toTopOf: view,
            withInset: 16,
            byBeingSafeAreaAware: true
        )
        compose.pin(
            toLeftOf: view,
            withInset: 16,
            byBeingSafeAreaAware: true
        )
        compose.pin(
            toRightOf: view,
            withInset: 16,
            byBeingSafeAreaAware: true
        )
        compose.attach(
            bottomToTopOf: separator,
            byBeingSafeAreaAware: true
        )
    }
    
    private func configureSeparator() {
        separator.pin(
            toRightOf: view,
            byBeingSafeAreaAware: true
        )
        separator.pin(
            toLeftOf: view,
            byBeingSafeAreaAware: true
        )
        separator.attach(
            bottomToTopOf: composeBottomBar,
            byBeingSafeAreaAware: true
        )
    }
    
    private func configureComposeBottomBar() {
        composeBottomBar.configure(withCurrentCount: 0)
        
        composeBottomBar.pin(
            toLeftOf: view,
            byBeingSafeAreaAware: true
        )
        composeBottomBar.pin(
            toRightOf: view,
            byBeingSafeAreaAware: true
        )
        composeBottomBar.pin(
            toBottomOf: view,
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

// MARK: ComposerDelegate
extension ComposeViewController: ComposerDelegate {
    func composer(
        _ composer: Composer,
        didChangeText text: String
    ) {
        composeBottomBar.configure(withCurrentCount: text.count)
    }
}
