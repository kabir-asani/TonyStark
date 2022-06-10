//
//  ComposeViewController.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 16/03/22.
//

import UIKit

class ComposeViewController: TXViewController {
    // Declare
    private let composer: Composer = {
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
    
    private let composeDetailsBar: CompositionDetailsBar = {
        let composeDetailsBar = CompositionDetailsBar()
        
        composeDetailsBar.enableAutolayout()
        
        return composeDetailsBar
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
        composer.focusTextView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        stopKeyboardAwareness()
    }
    
    private func addSubviews() {
        view.addSubview(composer)
        view.addSubview(separator)
        view.addSubview(composeDetailsBar)
    }
    
    private func configureNavigationBar() {
        configureLeftBarButtonWithCancelButton()
        configureRightBarButtonWithTweetBarButton()
    }
    
    private func configureLeftBarButtonWithCancelButton() {
        let cancelBarButtonItem = TXBarButtonItem(
            barButtonSystemItem: .cancel,
            target: self,
            action: #selector(onCancelPressed(_:))
        )
        
        navigationItem.leftBarButtonItem = cancelBarButtonItem
    }
    
    private func configureRightBarButtonWithTweetBarButton() {
        let tweetBarButtonItem = TXBarButtonItem(
            title: "Tweet",
            style: .done,
            target: self,
            action: #selector(onDonePressed(_:))
        )
        
        tweetBarButtonItem.tintColor = .systemBlue
        tweetBarButtonItem.isEnabled = !composer.text.isEmpty
        
        navigationItem.rightBarButtonItem = tweetBarButtonItem
    }
    
    private func configureRightBarButtonWithActivityIndicator() {
        let activityIndicator = TXActivityIndicatorView()
        
        activityIndicator.startAnimating()
        
        let activityIndicatorBarButtonItem = TXBarButtonItem(
            customView: activityIndicator
        )
        
        navigationItem.rightBarButtonItem = activityIndicatorBarButtonItem
    }
    
    private func showActivityIndicatorOnNavigationBar() {
        configureRightBarButtonWithActivityIndicator()
        view.isUserInteractionEnabled = false
    }
    
    private func hideActivityIndicatorOnNavigationBar() {
        configureRightBarButtonWithTweetBarButton()
        view.isUserInteractionEnabled = true
    }
    
    private func configureCompose() {
        composer.configure(
            withUser: CurrentUserDataStore.shared.user!
        )
        
        composer.delegate = self
        
        composer.pin(
            toTopOf: view,
            withInset: 16,
            byBeingSafeAreaAware: true
        )
        composer.pin(
            toLeftOf: view,
            withInset: 16,
            byBeingSafeAreaAware: true
        )
        composer.pin(
            toRightOf: view,
            withInset: 16,
            byBeingSafeAreaAware: true
        )
        composer.attach(
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
            bottomToTopOf: composeDetailsBar,
            byBeingSafeAreaAware: true
        )
    }
    
    private func configureComposeBottomBar() {
        composeDetailsBar.configure(withCurrentCount: 0)
        
        composeDetailsBar.pin(
            toLeftOf: view,
            byBeingSafeAreaAware: true
        )
        composeDetailsBar.pin(
            toRightOf: view,
            byBeingSafeAreaAware: true
        )
        composeDetailsBar.pin(
            toBottomOf: view,
            byBeingSafeAreaAware: true
        )
    }
    
    // Populate
    
    // Interact
    @objc private func onDonePressed(_ sender: UIBarButtonItem) {
        let composedText = composer.text
        
        if !composedText.isEmpty {
            Task {
                showActivityIndicatorOnNavigationBar()
                
                let tweetCreationResult = await TweetsDataStore.shared.createTweet(
                    withDetails: ComposeDetails(
                        text: composedText
                    )
                )
                
                hideActivityIndicatorOnNavigationBar()
                
                tweetCreationResult.map { tweet in
                    dismiss(
                        animated: true
                    )
                } onFailure: { reason in
                    showUnknownFailureSnackBar()
                }
            }
        }
    }
    
    @objc private func onCancelPressed(_ sender: UIBarButtonItem) {
        dismiss(
            animated: true
        )
    }
}

// MARK: ComposerDelegate
extension ComposeViewController: ComposerDelegate {
    func composer(
        _ composer: Composer,
        didChangeText text: String
    ) {
        composeDetailsBar.configure(withCurrentCount: text.count)
        
        if let rightBarButtonItem = navigationItem.rightBarButtonItem {
            if text.count == 0 {
                rightBarButtonItem.isEnabled = false
            } else {
                if !rightBarButtonItem.isEnabled {
                    rightBarButtonItem.isEnabled = true
                }
            }
        }
    }
}
