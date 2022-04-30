//
//  AuthenticationViewController.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 30/04/22.
//

import UIKit

class AuthenticationViewController: TXViewController {
    // Declare
    private let scroll: TXScrollView = {
        let scroll = TXScrollView()
        
        scroll.enableAutolayout()
        
        return scroll
    }()
    
    private let twitterXLogo: TXImageView = {
        let twitterXLogo = TXImageView(image: TXBundledImage.twitterX)
        
        twitterXLogo.enableAutolayout()
        twitterXLogo.contentMode = .scaleAspectFill
        twitterXLogo.squareOff(withSide: 80)
        
        return twitterXLogo
    }()
    
    private let taglineText: TXLabel = {
        let taglineText = TXLabel()
        
        taglineText.enableAutolayout()
        taglineText.font = .systemFont(
            ofSize: 40,
            weight: .black
        )
        taglineText.numberOfLines = 0
        taglineText.text = "Cherish the world better than ever!"
        
        return taglineText
    }()
    
    private let googleButton: RoundedButtonWithLeadingImage = {
        let googleButton = RoundedButtonWithLeadingImage()
        
        googleButton.enableAutolayout()
        
        return googleButton
    }()
    
    private let appleButton: RoundedButtonWithLeadingImage = {
        let appleButton = RoundedButtonWithLeadingImage()
        
        appleButton.enableAutolayout()
        
        return appleButton
    }()
    
    // Configure
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSubviews()
        
        configureScroll()
        configureNavigationBar()
        configureTwitterXLogo()
        configureTaglineText()
        configureGoogleButton()
        configureAppleButton()
    }
    
    private func addSubviews() {
        scroll.addSubview(twitterXLogo)
        scroll.addSubview(taglineText)
        scroll.addSubview(googleButton)
        scroll.addSubview(appleButton)
        
        view.addSubview(scroll)
    }
    
    private func configureNavigationBar() {
        let titleImage = TXImageView(image: TXBundledImage.twitterX)
        titleImage.contentMode = .scaleAspectFit
        
        navigationItem.backButtonTitle = ""
        navigationItem.titleView = titleImage
    }
    
    private func configureScroll() {
        scroll.pin(
            to: view,
            byBeingSafeAreaAware: true
        )
    }
    
    private func configureTwitterXLogo() {
        twitterXLogo.pin(
            toLeftOf: scroll,
            withInset: 16,
            byBeingSafeAreaAware: true
        )
        twitterXLogo.pin(
            toTopOf: scroll,
            withInset: 20,
            byBeingSafeAreaAware: true
        )
    }
    
    private func configureTaglineText() {
        taglineText.attach(
            topToBottomOf: twitterXLogo,
            withMargin: 80,
            byBeingSafeAreaAware: true
        )
        taglineText.pin(
            horizontallySymmetricTo: scroll,
            withInset: 16,
            byBeingSafeAreaAware: true
        )
    }
    
    private func configureGoogleButton() {
        googleButton.configure(
            withData: (
                image: TXBundledImage.google,
                text: "Continue with Google"
            )
        ) {
            Task {
                await UserProvider.current.logIn()
                
                if UserProvider.current.isLoggedIn {
                    TXEventBroker.shared.emit(event: HomeEvent())
                }
            }
        }
        
        googleButton.attach(
            topToBottomOf: taglineText,
            withMargin: 160,
            byBeingSafeAreaAware: true
        )
        googleButton.pin(
            horizontallySymmetricTo: scroll,
            withInset: 16,
            byBeingSafeAreaAware: true
        )
    }
    
    private func configureAppleButton() {
        appleButton.configure(
            withData: (
                image: TXBundledImage.apple,
                text: "Continue with Apple"
            )
        ) {
            Task {
                await UserProvider.current.logIn()
                
                if UserProvider.current.isLoggedIn {
                    TXEventBroker.shared.emit(event: HomeEvent())
                }
            }
        }
        
        appleButton.attach(
            topToBottomOf: googleButton,
            withMargin: 16,
            byBeingSafeAreaAware: true
        )
        appleButton.pin(
            horizontallySymmetricTo: scroll,
            withInset: 16,
            byBeingSafeAreaAware: true
        )
    }
    
    // Populate
    
    // Interact
}
