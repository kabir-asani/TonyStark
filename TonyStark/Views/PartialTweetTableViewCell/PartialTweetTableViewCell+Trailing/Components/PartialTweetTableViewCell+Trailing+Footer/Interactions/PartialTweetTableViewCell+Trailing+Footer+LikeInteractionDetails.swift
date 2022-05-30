//
//  LikeInteractionDetails.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 18/04/22.
//

import Foundation
import UIKit

extension PartialTweetTableViewCell.Trailing.Footer {
    class LikeInteractionDetails: TXView {
        // Declare
        private var onLikePressed: (() -> Void)?
        
        private let likeButton: TXButton = {
            let likeButton = TXButton()
            
            likeButton.enableAutolayout()
            
            return likeButton
        }()
        
        private let likesCountText: TXLabel = {
            let likesCountText = TXLabel()
            
            likesCountText.enableAutolayout()
            likesCountText.font = .systemFont(ofSize: 18, weight: .semibold)
            
            return likesCountText
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
                    likeButton,
                    likesCountText,
                    .spacer
                ]
            )
            
            combinedStack.enableAutolayout()
            combinedStack.axis = .horizontal
            combinedStack.spacing = 8
            combinedStack.distribution = .fill
            combinedStack.alignment = .center
            
            combinedStack.addTapGestureRecognizer(
                target: self,
                action: #selector(onLikePressed(_:))
            )
            
            return combinedStack
        }
        
        // Configure
        func configure(
            withTweet tweet: Tweet,
            onLikePressed: @escaping () -> Void
        ) {
            self.onLikePressed = onLikePressed
            
            configureLikeButton(
                with: tweet.viewables.liked
            )
            
            configureLikeText(
                withData: (
                    likesCount: tweet.interactionDetails.likesCount,
                    isLiked: tweet.viewables.liked
                )
            )
        }
        
        private func configureLikeButton(
            with isLiked: Bool
        ) {
            likeButton.setImage(
                UIImage(
                    systemName: isLiked
                    ? "heart.fill"
                    : "heart"
                ),
                for: .normal
            )
            
            likeButton.imageView?.tintColor = isLiked
            ? .systemPink
            : .systemGray
            
            likeButton.addTarget(
                self,
                action: #selector(onEntireLikePressed(_:)),
                for: .touchUpInside
            )
        }
        
        private func configureLikeText(
            withData data: (
                likesCount: Int,
                isLiked: Bool
            )
        ) {
            likesCountText.text = "\(data.likesCount)"
            
            likesCountText.textColor = data.isLiked
            ? .systemPink
            : .systemGray
        }
        
        // Interact
        @objc private func onLikePressed(
            _ sender: TXButton
        ) {
            onLikePressed?()
        }
        
        @objc private func onEntireLikePressed(
            _ sender: UITapGestureRecognizer
        ) {
            onLikePressed?()
        }
    }
}
