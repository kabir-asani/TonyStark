//
//  OtherUserTableViewCellBody.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 23/04/22.
//

import UIKit

extension OtherUserTableViewCell {
    class Body: TXView {
        // Declare
        private let nameText: TXLabel = {
            let nameText: TXLabel = .name()
            
            nameText.enableAutolayout()
            
            return nameText
        }()
        
        private let usernameText: TXLabel = {
            let usernameText: TXLabel = .username()
            
            usernameText.enableAutolayout()
            
            return usernameText
        }()
        
        private let bioText: TXLabel = {
            let bioText: TXLabel = .bio()
            
            bioText.enableAutolayout()
            
            return bioText
        }()
        
        // Arrange
        override init(frame: CGRect) {
            super.init(frame: frame)
            
            arrangeSubviews()
        }
        
        private func arrangeSubviews() {
            let combinedStackView = makeCombinedStackView()
            
            addSubview(combinedStackView)
            
            combinedStackView.pin(to: self)
        }
        
        private func makeCombinedStackView() -> TXStackView {
            let combinedStack = TXStackView(
                arrangedSubviews: [
                    nameText,
                    usernameText,
                    bioText
                ]
            )
            
            combinedStack.enableAutolayout()
            combinedStack.axis = .vertical
            combinedStack.spacing = 8
            combinedStack.distribution = .equalSpacing
            combinedStack.alignment = .leading
            
            return combinedStack
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        // Configure
        func configure(withUser user: User) {
            configureNameText(withText: user.name)
            configureUsernameText(withText: user.username)
            configureBioText(withText: user.bio)
        }
        
        private func configureNameText(withText text: String) {
            nameText.text = text
        }
        
        private func configureUsernameText(withText text: String) {
            usernameText.text = "@" + text
        }
        
        private func configureBioText(withText text: String) {
            bioText.text = text
        }
    }
}
