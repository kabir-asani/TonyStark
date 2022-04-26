//
//  PartialUserTableViewCellBody.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 25/04/22.
//

import UIKit

class TweetTableViewCellBody: TXView {
    // Declare
    private let tweetText: TXLabel = {
        let tweetText = TXLabel()
        
        tweetText.enableAutolayout()
        tweetText.adjustsFontSizeToFitWidth = false
        tweetText.numberOfLines = 0
        tweetText.font = .systemFont(ofSize: 16, weight: .regular)
        
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
