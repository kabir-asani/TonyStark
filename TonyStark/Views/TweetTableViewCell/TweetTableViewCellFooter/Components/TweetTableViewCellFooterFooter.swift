//
//  TweetTableViewCellFooterFooter.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 26/04/22.
//

import UIKit

class TweetTableViewCellFooterFooter: TXView {
    // Declare
    private var onLikeDetailsPressed: (() -> Void)?
    private var onLikePressed: (() -> Void)?
    
    private let likesCountText: TXLabel = {
        let likesCountText = TXLabel()
        
        likesCountText.enableAutolayout()
        
        likesCountText.adjustsFontSizeToFitWidth = false
        likesCountText.numberOfLines = 1
        likesCountText.font = .systemFont(ofSize: 16, weight: .bold)
        
        return likesCountText
    }()
    
    private let likesText: TXLabel = {
        let likesText = TXLabel()
        
        likesText.enableAutolayout()
        likesText.adjustsFontSizeToFitWidth = false
        likesText.numberOfLines = 1
        likesText.textColor = .systemGray
        likesText.font = .systemFont(ofSize: 16, weight: .regular)
        
        return likesText
    }()
    
    private let likeButton: TXButton = {
        let likeButton = TXButton()
        
        likeButton.enableAutolayout()
        
        return likeButton
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
        
        combinedStackView.addTapGestureRecognizer(
            target: self,
            action: #selector(onPressed(_:))
        )
    }
    
    private func makeCombinedStackView() -> TXStackView {
        let combinedStack = TXStackView(
            arrangedSubviews: [
                likesCountText,
                likesText,
                .spacer,
                likeButton
            ]
        )
        
        combinedStack.enableAutolayout()
        combinedStack.axis = .horizontal
        combinedStack.distribution = .fill
        combinedStack.alignment = .center
        combinedStack.spacing = 8
        
        return combinedStack
    }
    
    // Configure
    func configure(
        withTweet tweet: Tweet,
        onLikeDetailsPressed: @escaping () -> Void,
        onLikePressed: @escaping () -> Void
    ) {
        self.onLikeDetailsPressed = onLikeDetailsPressed
        self.onLikePressed = onLikePressed
        
        configureLikeButton(with: tweet.viewables.liked)
        
        likesCountText.text = "\(tweet.meta.likesCount)"
        
        likesText.text = tweet.meta.likesCount == 1 ? "like" : "likes"
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
            action: #selector(onLikePressed(_:)),
            for: .touchUpInside
        )
    }
    
    // Interact
    @objc private func onPressed(_ sender: UITapGestureRecognizer) {
        onLikeDetailsPressed?()
    }
    
    @objc private func onLikePressed(
        _ sender: TXButton
    ) {
        onLikePressed?()
    }
}
