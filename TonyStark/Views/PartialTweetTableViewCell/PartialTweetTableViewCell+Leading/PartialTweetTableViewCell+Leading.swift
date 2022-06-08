//
//  TweetViewCellLeading.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 18/04/22.
//

import Foundation
import UIKit

extension PartialTweetTableViewCell {
    class Leading: UIView {
        // Declare
        private let profileImage: AvatarImage = {
            let profileImage = AvatarImage(size: .small)
            
            profileImage.enableAutolayout()
            
            return profileImage
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
            addSubview(profileImage)
            
            profileImage.pin(to: self)
        }
        
        // Configure
        func configure(
            withTweet tweet: Tweet,
            onProfileImagePressed: @escaping () -> Void
        ) {
            profileImage.configure(
                withImageURL: tweet.viewables.author.image,
                onPressed: onProfileImagePressed
            )
        }
        
        // Interact
    }
}
