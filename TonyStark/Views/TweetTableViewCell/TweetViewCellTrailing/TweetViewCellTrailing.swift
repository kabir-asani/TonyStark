//
//  TweetViewCellTrailing.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 18/04/22.
//

import UIKit

class TweetViewCellTrailing: TXView {
    // Declare
    private let header: TweetViewCellTrailingHeader = {
        let header = TweetViewCellTrailingHeader()
        
        header.enableAutolayout()
        
        return header
    }()
    
    private let body: TweetViewCellTrailingBody = {
        let body = TweetViewCellTrailingBody()
        
        body.enableAutolayout()
        
        return body
    }()
    
    private let footer: TweetViewCellTrailingFooter = {
        let footer = TweetViewCellTrailingFooter()
        
        footer.enableAutolayout()
        
        return footer
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
                header,
                body,
                footer
            ]
        )
        
        combinedStack.enableAutolayout()
        combinedStack.axis = .vertical
        combinedStack.spacing = 8
        combinedStack.distribution = .equalSpacing
        combinedStack.alignment = .fill
        
        return combinedStack
    }
    
    // Configure
    @available(iOS 14, *)
    func configure(
        withTweet tweet: Tweet,
        onLikePressed: @escaping () -> Void,
        onCommentPressed: @escaping () -> Void,
        onBookmarksPressed: @escaping () -> Void,
        onFollowPressed: @escaping () -> Void
    ) {
        header.configure(withTweet: tweet)
        
        body.configure(withTweet: tweet)
        
        footer.configure(
            withTweet: tweet,
            onLikePressed: onLikePressed,
            onCommentPressed: onCommentPressed,
            onBookmarkPressed: onBookmarksPressed,
            onFollowPressed: onFollowPressed
        )
    }
    
    @available(iOS, deprecated: 14)
    func configure(
        withTweet tweet: Tweet,
        onLikePressed: @escaping () -> Void,
        onCommentPressed: @escaping () -> Void,
        onOptionsPressed: @escaping () -> Void
    ) {
        header.configure(withTweet: tweet)
        
        body.configure(withTweet: tweet)
        
        footer.configure(
            withTweet: tweet,
            onLikePressed: onLikePressed,
            onCommentPressed: onCommentPressed,
            onOptionsPressed: onOptionsPressed
        )
    }
}
