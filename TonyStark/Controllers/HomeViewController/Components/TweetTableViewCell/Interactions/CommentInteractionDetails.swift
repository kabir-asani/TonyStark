//
//  CommentInteractionDetails.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 18/04/22.
//

import Foundation
import UIKit

class CommentInteractionDetails: UIView {
    private var tweet: Tweet!
    
    private let commentButton: TXButton = {
        let commentButton = TXButton()
        
        commentButton.enableAutolayout()
        
        return commentButton
    }()
    
    private let commentsCountText: UILabel = {
        let commentsCountText = UILabel()
        
        commentsCountText.enableAutolayout()
        commentsCountText.font = .systemFont(ofSize: 18, weight: .semibold)
        commentsCountText.textColor = .gray
        
        return commentsCountText
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
                commentButton,
                commentsCountText,
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
        
        configureCommentButton()
        configureTrailingCounterText()
    }
    
    private func configureTrailingCounterText() {
        commentsCountText.text = "\(tweet.meta.commentsCount)"
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
    
    @objc private func onCommentPressed(_ sender: TXButton) {
        print(#function)
    }
}
