//
//  TweetViewCellTrailingFooter.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 19/04/22.
//

import UIKit

protocol TweetViewCellTrailingFooterInteractionsHandler: TweetViewCellTrailing {
    func didPressLike(_ tweetViewCellTrailingFooter: TweetViewCellTrailingFooter)
    
    func didPressComment(_ tweetViewCellTrailingFooter: TweetViewCellTrailingFooter)
    
    @available(iOS 14, *)
    func didPressBookmark(_ tweetViewCellTrailingFooter: TweetViewCellTrailingFooter)
    
    @available(iOS 14, *)
    func didPressFollow(_ tweetViewCellTrailingFooter: TweetViewCellTrailingFooter)
    
    @available(iOS, deprecated: 14)
    func didPressOptions(_ tweetViewCellTrailingFooter: TweetViewCellTrailingFooter)
}

class TweetViewCellTrailingFooter: TXView {
    // Declare
    weak var interactionsHandler: TweetViewCellTrailingFooterInteractionsHandler?
    
    private let likeInteractionDetails: LikeInteractionDetails = {
        let likeInteractionDetails = LikeInteractionDetails()
        
        likeInteractionDetails.enableAutolayout()
        likeInteractionDetails.heightConstaint(with: 20)
        
        return likeInteractionDetails
    }()
    
    private let commentInteractionDetails: CommentInteractionDetails = {
        let commentInteractionDetails = CommentInteractionDetails()
        
        commentInteractionDetails.enableAutolayout()
        commentInteractionDetails.heightConstaint(with: 20)
        
        return commentInteractionDetails
    }()
    
    private let tweetOptions: TweetOptions = {
        let tweetOptions = TweetOptions()
        
        tweetOptions.enableAutolayout()
        tweetOptions.heightConstaint(with: 20)
        
        return tweetOptions
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
                likeInteractionDetails,
                commentInteractionDetails,
                tweetOptions,
            ]
        )
        
        combinedStack.enableAutolayout()
        combinedStack.axis = .horizontal
        combinedStack.spacing = 16
        combinedStack.distribution = .fillEqually
        combinedStack.alignment = .center
        
        return combinedStack
    }
    
    // Configure
    func configure(
        withTweet tweet: Tweet
    ) {
        likeInteractionDetails.interactionsHandler = self
        likeInteractionDetails.configure(withTweet: tweet)
        likeInteractionDetails.addTapGestureRecognizer(
            target: self,
            action: #selector(onLikePressed(_:))
        )
        
        commentInteractionDetails.interactionsHandler = self
        commentInteractionDetails.configure(withTweet: tweet)
        commentInteractionDetails.addTapGestureRecognizer(
            target: self,
            action: #selector(onCommentPressed(_:))
        )
        
        tweetOptions.interactionsHandler = self
        tweetOptions.configure(withTweet: tweet)
    }
    
    // Interact
    @objc private func onLikePressed(_ sender: UITapGestureRecognizer) {
        interactionsHandler?.didPressLike(self)
    }
    
    @objc private func onCommentPressed(_ sender: UITapGestureRecognizer) {
        interactionsHandler?.didPressComment(self)
    }
}

// MARK: LikeInteractionDetailsInteractionHandler
extension TweetViewCellTrailingFooter: LikeInteractionDetailsInteractionsHandler {
    func didPressLike(_ likeInteractionDetails: LikeInteractionDetails) {
        interactionsHandler?.didPressLike(self)
    }
}

// MARK: CommentInteractionDetailsInteractionHandler
extension TweetViewCellTrailingFooter: CommentInteractionDetailsInteractionsHandler {
    func didPressComment(_ commentInteractionDetails: CommentInteractionDetails) {
        interactionsHandler?.didPressComment(self)
    }
}

// MARK: TweetOptionsInteractionHandler
extension TweetViewCellTrailingFooter: TweetOptionsInteractionsHandler {
    @available(iOS 14, *)
    func didPressBookmark(_ tweetOptions: TweetOptions) {
        interactionsHandler?.didPressBookmark(self)
    }
    
    @available(iOS 14, *)
    func didPressFollow(_ tweetOptions: TweetOptions) {
        interactionsHandler?.didPressFollow(self)
    }
    
    func didPressOptions(_ tweetOptions: TweetOptions) {
        interactionsHandler?.didPressOptions(self)
    }
}
