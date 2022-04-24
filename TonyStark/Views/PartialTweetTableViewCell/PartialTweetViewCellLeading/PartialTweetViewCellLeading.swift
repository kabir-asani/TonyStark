//
//  TweetViewCellLeading.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 18/04/22.
//

import Foundation
import UIKit

class PartialTweetViewCellLeading: UIView {
    // Declare
    private var onProfileImagePressed: (() -> Void)?
    
    private let profileImage: TXCircularImageView = {
        let profileImage = TXCircularImageView(radius: 22)
        
        profileImage.enableAutolayout()
        profileImage.backgroundColor = .lightGray
        profileImage.isUserInteractionEnabled = true
        
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
    
    func configure(
        withTweet tweet: Tweet,
        onProfileImagePressed: @escaping () -> Void
    ) {
        self.onProfileImagePressed = onProfileImagePressed
        
        configureProfileImage(withImageURL: tweet.author.image)
    }
    
    private func arrangeSubviews() {
        addSubview(profileImage)
        
        profileImage.pin(to: self)
    }
    
    // Configure
    private func configureProfileImage(
        withImageURL imageURL: String
    ) {
        profileImage.addTapGestureRecognizer(
            target: self,
            action: #selector(onProfileImagePressed(_:))
        )
        
        Task {
            let image = await TXImageProvider.shared.image(imageURL)
            
            DispatchQueue.main.async {
                [weak self] in
                guard let strongSelf = self, let image = image else {
                    return
                }
                
                strongSelf.profileImage.image = image
            }
        }
    }
    
    // Interact
    @objc private func onProfileImagePressed(_ sender: UITapGestureRecognizer) {
        onProfileImagePressed?()
    }
}
