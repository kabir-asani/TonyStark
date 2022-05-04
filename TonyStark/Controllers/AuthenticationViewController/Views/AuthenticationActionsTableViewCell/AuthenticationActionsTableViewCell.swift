//
//  AuthenticationActionsTableViewCell.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 02/05/22.
//

import UIKit

protocol AuthenticationActionsTableViewCellInteractionsHandler: AnyObject {
    func authenticationActionsCellDidContinueWithGoogle()
    
    func authenticationActionsCellDidContinueWithApple()
}

class AuthenticationActionsTableViewCell: TXTableViewCell {
    // Declare
    override class var reuseIdentifier: String {
        String(describing: AuthenticationActionsTableViewCell.self)
    }
    
    weak var interactionsHandler: AuthenticationActionsTableViewCellInteractionsHandler?
    
    private let googleButton: TXButton = {
        let googleButton = TXButton()
        
        googleButton.enableAutolayout()
        googleButton.fixHeight(to: 60)
        googleButton.setTitle(
            "Continue with Google",
            for: .normal
        )
        googleButton.setTitleColor(
            .black,
            for: .normal
        )
        googleButton.backgroundColor = .white
        googleButton.layer.cornerRadius = 30
        googleButton.clipsToBounds = true
        googleButton.layer.borderWidth = 1
        googleButton.layer.borderColor = TXColor.lightGray.cgColor
        
        return googleButton
    }()
    
    private let appleButton: TXButton = {
        let appleButton = TXButton()
        
        appleButton.enableAutolayout()
        appleButton.fixHeight(to: 60)
        appleButton.setTitle(
            "Continue with Apple",
            for: .normal
        )
        appleButton.setTitleColor(
            .black,
            for: .normal
        )
        appleButton.backgroundColor = .white
        appleButton.layer.cornerRadius = 30
        appleButton.clipsToBounds = true
        appleButton.layer.borderWidth = 1
        appleButton.layer.borderColor = TXColor.lightGray.cgColor
        
        return appleButton
    }()
    
    // Arrange
    override init(
        style: UITableViewCell.CellStyle,
        reuseIdentifier: String?
    ) {
        super.init(
            style: style,
            reuseIdentifier: reuseIdentifier
        )
        
        arrangeBaseView()
        arrangeSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func arrangeBaseView() {
        selectionStyle = .none
        separatorInset = .leading(.infinity)
    }
    
    private func arrangeSubviews() {
        arrangeGoogleButton()
        arrangeAppleButton()
        
        let combinedStackView = makeCombinedStackView()
        
        addSubview(combinedStackView)
        
        combinedStackView.pin(
            to: self,
            withInsets: .all(16),
            byBeingSafeAreaAware: true
        )
    }
    
    private func makeCombinedStackView() -> TXStackView {
        let combinedStack = TXStackView(
            arrangedSubviews: [
                googleButton,
                appleButton
            ]
        )
        
        combinedStack.enableAutolayout()
        combinedStack.axis = .vertical
        combinedStack.distribution = .equalSpacing
        combinedStack.alignment = .fill
        combinedStack.spacing = 16
        
        return combinedStack
    }
    
    private func arrangeGoogleButton() {
        googleButton.addTarget(
            self,
            action: #selector(onContinueWithGooglePressed(_:)),
            for: .touchUpInside
        )
    }
    
    private func arrangeAppleButton() {
        appleButton.addTarget(
            self,
            action: #selector(onContinueWithApplePressed(_:)),
            for: .touchUpInside
        )
    }
    
    // Configure
    
    // Interact
    
    @objc private func onContinueWithGooglePressed(_ sender: TXButton) {
        interactionsHandler?.authenticationActionsCellDidContinueWithGoogle()
    }
    
    @objc private func onContinueWithApplePressed(_ sender: TXButton) {
        interactionsHandler?.authenticationActionsCellDidContinueWithApple()
    }
}
