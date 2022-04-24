//
//  TweetViewCellTrailingHeader.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 19/04/22.
//

import UIKit

class PartialTweetViewCellTrailingHeader: TXView {
    // Declare
    private let nameText: TXLabel = {
        let nameText = TXLabel()
        
        nameText.enableAutolayout()
        nameText.adjustsFontSizeToFitWidth = false
        nameText.numberOfLines = 1
        nameText.font = .systemFont(ofSize: 16, weight: .bold)
        
        return nameText
    }()
    
    private let usernameText: TXLabel = {
        let usernameText = TXLabel()
        
        usernameText.enableAutolayout()
        usernameText.adjustsFontSizeToFitWidth = false
        usernameText.lineBreakMode = .byTruncatingTail
        usernameText.numberOfLines = 1
        usernameText.font = .systemFont(ofSize: 16, weight: .regular)
        usernameText.textColor = .gray
        
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
                usernameText,
                TXStackView.spacer
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
    func configure(withTweet tweet: Tweet) {
        configureNameText(withText: tweet.author.name)
        configureUsernameText(withText: tweet.author.username)
    }
    
    private func configureNameText(withText text: String) {
        nameText.text = text
    }
    
    private func configureUsernameText(withText text: String) {
        usernameText.text = "@" + text
    }
}
