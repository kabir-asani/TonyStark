//
//  CommentInteractionDetails.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 18/04/22.
//

import Foundation
import UIKit

extension PartialTweetTableViewCell.Trailing.Footer {
    class CommentInteractionDetails: TXView {
        // Declare
        private var onCommentPressed: (() -> Void)?
        
        private let commentButton: TXButton = {
            let commentButton = TXButton()
            
            commentButton.enableAutolayout()
            
            return commentButton
        }()
        
        private let commentsCountText: TXLabel = {
            let commentsCountText = TXLabel()
            
            commentsCountText.enableAutolayout()
            commentsCountText.font = .systemFont(ofSize: 18, weight: .semibold)
            commentsCountText.textColor = .gray
            
            return commentsCountText
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
                    commentButton,
                    commentsCountText,
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
                action: #selector(onEntireCommentPressed(_:))
            )
            
            return combinedStack
        }
        
        // Configure
        func configure(
            withTweet tweet: Tweet,
            onCommentPressed: @escaping () -> Void
        ) {
            self.onCommentPressed = onCommentPressed
            
            configureCommentButton()
            configureCommentsCountText(withCommentsCount: tweet.meta.commentsCount)
        }
        
        private func configureCommentButton() {
            commentButton.setImage(
                UIImage(systemName: "text.bubble"),
                for: .normal
            )
            
            commentButton.tintColor = .gray
            
            commentButton.addTarget(
                self,
                action: #selector(onCommentPressed(_:)),
                for: .touchUpInside
            )
        }
        
        private func configureCommentsCountText(withCommentsCount commentsCount: Int) {
            commentsCountText.text = "\(commentsCount)"
        }
        
        // Interact
        @objc private func onCommentPressed(_ sender: TXButton) {
            onCommentPressed?()
        }
        
        @objc private func onEntireCommentPressed(_ sender: UITapGestureRecognizer) {
            onCommentPressed?()
        }
    }
}
