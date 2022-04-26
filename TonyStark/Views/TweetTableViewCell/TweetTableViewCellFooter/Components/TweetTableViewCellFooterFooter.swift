//
//  TweetTableViewCellFooterFooter.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 26/04/22.
//

import UIKit

class TweetTableViewCellFooterFooter: TXView {
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
        likesText.font = .systemFont(ofSize: 16, weight: .regular)
        
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
        
        combinedStackView.pin(to: self)
    }
    
    private func makeCombinedStackView() -> TXStackView {
        let combinedStack = TXStackView(
            arrangedSubviews: [
                likesCountText,
                likesText
            ]
        )
        
        combinedStack.enableAutolayout()
        combinedStack.axis = .horizontal
        combinedStack.distribution = .equalSpacing
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
}
