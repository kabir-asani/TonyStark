//
//  TweetTableViewCellFooterHeader.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 26/04/22.
//

import UIKit

extension TweetTableViewCell.Footer {
    class Header: TXView {
        // Declare
        private let dateText: TXLabel = {
            let dateText = TXLabel()
            
            dateText.enableAutolayout()
            dateText.adjustsFontSizeToFitWidth = false
            dateText.numberOfLines = 1
            dateText.textColor = .systemGray
            dateText.font = .systemFont(ofSize: 16, weight: .regular)
            
            return dateText
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
            addSubview(dateText)
            
            dateText.pin(to: self)
        }
        
        // Configure
        func configure(withTweet tweet: Tweet) {
            dateText.text = tweet.creationDate.formatted(as: .visiblyPleasingLong)
        }
        
        // Interact
    }
}
