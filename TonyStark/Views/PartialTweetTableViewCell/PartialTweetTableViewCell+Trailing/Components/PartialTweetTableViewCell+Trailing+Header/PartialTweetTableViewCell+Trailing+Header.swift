//
//  TweetViewCellTrailingHeader.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 19/04/22.
//

import UIKit

extension PartialTweetTableViewCell.Trailing {
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
        
        private let dotText: TXLabel = {
            let dotText: TXLabel = .sepator()
            
            dotText.enableAutolayout()
            dotText.text = "•"
            
            return dotText
        }()
        
        private let dateText: TXLabel = {
            let timeText: TXLabel = .dateTime()
            
            timeText.enableAutolayout()
            
            return timeText
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
                    dotText,
                    dateText,
                    .spacer,
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
            configureNameText(withText: tweet.viewables.author.name)
            configureUsernameText(withText: tweet.viewables.author.username)
            configureDateText(withDate: tweet.creationDate)
        }
        
        private func configureNameText(withText text: String) {
            nameText.text = text
        }
        
        private func configureUsernameText(withText text: String) {
            usernameText.text = "@" + text
        }
        
        private func configureDateText(withDate date: Date) {
            dateText.text = date.formatted(as: .visiblyPleasingShort)
        }
    }
}
