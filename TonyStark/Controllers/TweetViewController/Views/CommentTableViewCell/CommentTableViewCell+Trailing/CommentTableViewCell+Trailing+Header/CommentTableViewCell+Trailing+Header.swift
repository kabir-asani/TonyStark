//
//  CommentTableViewCellTrailingHeader.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 20/04/22.
//

import UIKit

extension CommentTableViewCell.Trailing {
    class Header: TXView {
        // Declare
        private let nameText: TXLabel = {
            let nameText: TXLabel = .name()
            
            nameText.enableAutolayout()
            nameText.setContentCompressionResistancePriority(
                .init(Float.infinity),
                for: .horizontal
            )
            
            return nameText
        }()
        
        private let usernameText: TXLabel = {
            let usernameText: TXLabel = .username()
            
            usernameText.enableAutolayout()
            
            return usernameText
        }()
        
        // Arrange
        override init(frame: CGRect) {
            super.init(frame: frame)
            
            arrangeSubviews()
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
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
                    usernameText
                ]
            )
            
            combinedStack.enableAutolayout()
            combinedStack.axis = .horizontal
            combinedStack.spacing = 8
            combinedStack.distribution = .fill
            combinedStack.alignment = .center
            
            return combinedStack
        }
        
        // Configure
        func configure(withComment comment: Comment) {
            configureNameText(withText: comment.author.name)
            configureUsernameText(withText: comment.author.username)
        }
        
        private func configureNameText(withText text: String) {
            nameText.text = text
        }
        
        private func configureUsernameText(withText text: String) {
            usernameText.text = "@" + text
        }
        
        // Interact
    }
}
