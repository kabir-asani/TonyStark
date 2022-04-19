//
//  CommentInteractionDetails.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 18/04/22.
//

import Foundation
import UIKit

protocol CommentInteractionDetailsInteractionsHandler: TweetViewCellTrailingFooter {
    func didPressComment(_ commentInteractionDetails: CommentInteractionDetails)
}

class CommentInteractionDetails: TXView {
    // Declare
    weak var interactionsHandler: CommentInteractionDetailsInteractionsHandler?
    
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
                TXStackView.spacer
            ]
        )
        
        combinedStack.enableAutolayout()
        combinedStack.axis = .horizontal
        combinedStack.spacing = 8
        combinedStack.distribution = .fill
        combinedStack.alignment = .center
        
        return combinedStack
    }
    
    // Configure
    func configure(withTweet tweet: Tweet) {
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
        interactionsHandler?.didPressComment(self)
    }
}
