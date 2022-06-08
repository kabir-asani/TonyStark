//
//  PartialUserTableViewCellHeaderCenter.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 25/04/22.
//

import UIKit

extension TweetTableViewCell.Header {
    class Middle: TXView {
        private var onPressed: (() -> Void)?
        
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
            
            combinedStackView.addTapGestureRecognizer(
                target: self,
                action: #selector(onPressed(_:))
            )
        }
        
        private func makeCombinedStackView() -> TXStackView {
            let combinedStack = TXStackView(
                arrangedSubviews: [
                    nameText,
                    usernameText
                ]
            )
            
            combinedStack.enableAutolayout()
            combinedStack.axis = .vertical
            combinedStack.distribution = .equalSpacing
            combinedStack.alignment = .leading
            combinedStack.spacing = 4
            
            return combinedStack
        }
        
        // Configure
        func configure(
            withTweet tweet: Tweet,
            onPressed: @escaping () -> Void
        ) {
            self.onPressed = onPressed
            
            nameText.text = tweet.viewables.author.name
            usernameText.text = "@" + tweet.viewables.author.username
        }
        
        // Interact
        @objc private func onPressed(_ sender: UITapGestureRecognizer) {
            onPressed?()
        }
    }

}
