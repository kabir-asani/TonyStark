//
//  PartialUserTableViewCellFooter.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 25/04/22.
//

import UIKit

class TweetTableViewCellFooter: TXView {
    // Declare
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
        likesText.font = .systemFont(ofSize: 16, weight: .semibold)
        
        return likesText
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
        
        combinedStackView.addTapGestureRecognizer(
            target: self,
            action: #selector(onEntireLikesPressed(_:))
        )
        
        combinedStackView.pin(to: self)
    }
    
    private func makeCombinedStackView() -> TXStackView {
        let combinedStack = TXStackView(
            arrangedSubviews: [
                likesCountText,
                likesText,
                TXStackView.spacer
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
        withTweet tweet: Tweet
    ) { 
        likesCountText.text = "\(tweet.meta.likesCount)"
        
        likesText.text = tweet.meta.likesCount == 1 ? "like" : "likes"
    }
    
    // Interact
    @objc private func onEntireLikesPressed(_ sender: UITapGestureRecognizer) {
        onLikePressed?()
    }
}
