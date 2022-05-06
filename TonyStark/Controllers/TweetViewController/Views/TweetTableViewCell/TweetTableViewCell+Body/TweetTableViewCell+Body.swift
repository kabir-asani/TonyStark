//
//  PartialUserTableViewCellBody.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 25/04/22.
//

import UIKit

extension TweetTableViewCell {
    class Body: TXView {
        // Declare
        private let tweetText: TXLabel = {
            let tweetText: TXLabel = .tweet()
            
            tweetText.enableAutolayout()
            
            return tweetText
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
            addSubview(tweetText)
            
            tweetText.pin(to: self)
        }
        
        // Configure
        func configure(withTweet tweet: Tweet) {
            tweetText.text = tweet.text
        }
        
        // Interact
    }
}
