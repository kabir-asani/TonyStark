//
//  LikeInteractionDetails.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 18/04/22.
//

import Foundation
import UIKit

class LikeInteractionDetails: UIView {
    private var tweet: Tweet!
    
    private let likeButton: TXButton = {
        let likeButton = TXButton()
        
        likeButton.enableAutolayout()
        
        return likeButton
    }()
    
    private let likesCountText: UILabel = {
        let likesCountText = UILabel()
        
        likesCountText.enableAutolayout()
        likesCountText.font = .systemFont(ofSize: 18, weight: .semibold)
        
        return likesCountText
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        arrangeSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func arrangeSubviews() {
        let stack = UIStackView(
            arrangedSubviews: [
                likeButton,
                likesCountText,
                UIStackView.spacer
            ]
        )
        
        stack.enableAutolayout()
        stack.axis = .horizontal
        stack.spacing = 8
        stack.distribution = .fill
        stack.alignment = .center
        
        addSubview(stack)
        
        stack.pin(to: self)
    }
    
    func configure(with tweet: Tweet) {
        self.tweet = tweet
        
        configureLikeButton()
        configureLikesCountText()
    }
    
    private func configureLikeButton() {
        likeButton.setImage(
            UIImage(
                systemName: tweet.viewables.liked
                ? "heart.fill"
                : "heart"
            ),
            for: .normal
        )
        
        likeButton.imageView?.tintColor = tweet.viewables.liked
        ? .systemPink
        : .systemGray
        
        likeButton.addTarget(
            self,
            action: #selector(onLikePressed(_:)),
            for: .touchUpInside
        )
    }
    
    private func configureLikesCountText() {
        likesCountText.text = "\(tweet.meta.likesCount)"
        
        likesCountText.textColor = tweet.viewables.liked
        ? .systemPink
        : .systemGray
    }
    
    
    @objc private func onLikePressed(_ sender: TXButton) {
        print(#function)
    }
}
