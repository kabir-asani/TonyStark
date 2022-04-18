//
//  TweetViewCellLeading.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 18/04/22.
//

import Foundation
import UIKit

class TweetViewCellLeading: UIView {
    private var tweet: Tweet!
    
    private let profileImage: TXCircularImageView = {
        let profileImage = TXCircularImageView(radius: 22)
        
        profileImage.enableAutolayout()
        profileImage.backgroundColor = .lightGray
        
        return profileImage
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        arrangeSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with tweet: Tweet) {
        self.tweet = tweet
        
        configureProfileImage()
    }
    
    private func arrangeSubviews() {
        addSubview(profileImage)
        
        profileImage.pin(to: self)
    }
    
    private func configureProfileImage() {
        Task {
            [weak self] in
            
            guard let safeSelf = self else {
                return
            }
            
            let image = await TXImageProvider.shared.image(safeSelf.tweet.author.image)
            
            DispatchQueue.main.async {
                [weak self] in
                guard let safeSelf = self, let image = image else {
                    return
                }
                
                safeSelf.profileImage.image = image
            }
        }
    }
}
