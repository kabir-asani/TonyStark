//
//  CommentTableViewCellLeading.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 20/04/22.
//

import UIKit

extension CommentTableViewCell {
    class Leading: TXView {
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
            withComment comment: Comment,
            onProfileImagePressed: @escaping () -> Void
        ) {
            profileImage.configure(
                withImageURL: comment.author.image,
                onPressed: onProfileImagePressed
            )
        }
        
        // Interact
    }
}
