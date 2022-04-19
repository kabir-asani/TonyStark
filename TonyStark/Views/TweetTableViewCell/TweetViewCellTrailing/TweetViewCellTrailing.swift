//
//  TweetViewCellTrailing.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 18/04/22.
//

import UIKit

protocol TweetViewCellTrailingInteractionsHandler: TweetTableViewCell {
    func didPressLike(_ tweetViewCellTrailing: TweetViewCellTrailing)
    
    func didPressComment(_ tweetViewCellTrailing: TweetViewCellTrailing)
    
    @available(iOS 14, *)
    func didPressBookmark(_ tweetViewCellTrailing: TweetViewCellTrailing)
    
    @available(iOS 14, *)
    func didPressFollow(_ tweetViewCellTrailing: TweetViewCellTrailing)
    
    @available(iOS, deprecated: 14)
    func didPressOptions(_ tweetViewCellTrailing: TweetViewCellTrailing)
}

class TweetViewCellTrailing: TXView {
    // Declare
    weak var interactionsHandler: TweetViewCellTrailingInteractionsHandler?
    
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
    func configure(
        withTweet tweet: Tweet
    ) {
        header.configure(withTweet: tweet)
        
        body.configure(withTweet: tweet)
        
        footer.interactionsHandler = self
        footer.configure(withTweet: tweet)
    }
}

// MARK: TweetViewCellTrailingFooterInteractionsHandler
extension TweetViewCellTrailing: TweetViewCellTrailingFooterInteractionsHandler {
    func didPressLike(_ tweetViewCellTrailingFooter: TweetViewCellTrailingFooter) {
        interactionsHandler?.didPressLike(self)
    }
    
    func didPressComment(_ tweetViewCellTrailingFooter: TweetViewCellTrailingFooter) {
        interactionsHandler?.didPressComment(self)
    }
    
    @available(iOS 14, *)
    func didPressBookmark(_ tweetViewCellTrailingFooter: TweetViewCellTrailingFooter) {
        interactionsHandler?.didPressBookmark(self)
    }
    
    @available(iOS 14, *)
    func didPressFollow(_ tweetViewCellTrailingFooter: TweetViewCellTrailingFooter) {
        interactionsHandler?.didPressFollow(self)
    }
    
    func didPressOptions(_ tweetViewCellTrailingFooter: TweetViewCellTrailingFooter) {
        interactionsHandler?.didPressOptions(self)
    }
}
