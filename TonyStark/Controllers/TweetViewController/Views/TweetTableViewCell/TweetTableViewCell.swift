//
//  PartialUserTableViewCell.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 25/04/22.
//

import UIKit

protocol TweetTableViewCellInteractionsHandler: AnyObject {
    func tweetCellDidPressProfileImage(_ cell: TweetTableViewCell)
    
    func tweetCellDidPressProfileDetails(_ cell: TweetTableViewCell)
    
    func tweetCellDidPressLike(_ cell: TweetTableViewCell)
    
    func tweetCellDidPressLikeDetails(_ cell: TweetTableViewCell)
    
    func tweetCellDidPressBookmarkOption(_ cell: TweetTableViewCell)
    
    func tweetCellDidPressFollowOption(_ cell: TweetTableViewCell)
    
    @available(iOS, deprecated: 14)
    func tweetCellDidPressOptions(_ cell: TweetTableViewCell)
}

class TweetTableViewCell: TXTableViewCell {
    // Declare
    override class var reuseIdentifier: String {
        String(describing: TweetTableViewCell.self)
    }
    
    weak var interactionsHandler: TweetTableViewCellInteractionsHandler?
    
    private let header: Header = {
        let header = Header()
        
        header.enableAutolayout()
        
        return header
    }()
    
    private let body: Body = {
        let body = Body()
        
        body.enableAutolayout()
        
        return body
    }()
    
    private let footer: Footer = {
        let footer = Footer()
        
        footer.enableAutolayout()
        
        return footer
    }()
    
    // Arrange
    override init(
        style: UITableViewCell.CellStyle,
        reuseIdentifier: String?
    ) {
        super.init(
            style: style,
            reuseIdentifier: reuseIdentifier
        )
        
        arrangeBaseView()
        arrangeSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func arrangeBaseView() {
        selectionStyle = .none
    }
    
    private func arrangeSubviews() {
        let combinedStackView = makeCombinedStackView()
        
        addSubview(combinedStackView)
        
        combinedStackView.pin(
            to: self,
            withInsets: .all(16)
        )
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
        combinedStack.distribution = .equalSpacing
        combinedStack.alignment = .fill
        combinedStack.spacing = 16
        
        return combinedStack
    }
    
    // Configure
    func configure(
        withTweet tweet: Tweet
    ) {
        if #available(iOS 14, *) {
            header.configure(
                withTweet: tweet
            ) {
                [weak self] in
                guard let strongSelf = self else {
                    return
                }
                
                strongSelf.interactionsHandler?.tweetCellDidPressProfileImage(strongSelf)
            } onDetailsPressed: {
                [weak self] in
                guard let strongSelf = self else {
                    return
                }
                
                strongSelf.interactionsHandler?.tweetCellDidPressProfileDetails(strongSelf)
            } onBookmarksPressed: {
                [weak self] in
                guard let strongSelf = self else {
                    return
                }
                
                strongSelf.interactionsHandler?.tweetCellDidPressBookmarkOption(strongSelf)
            } onFollowPressed: {
                [weak self] in
                guard let strongSelf = self else {
                    return
                }
                
                strongSelf.interactionsHandler?.tweetCellDidPressFollowOption(strongSelf)
            }
        } else {
            header.configure(
                withTweet: tweet
            ) {
                [weak self] in
                guard let strongSelf = self else {
                    return
                }
                
                strongSelf.interactionsHandler?.tweetCellDidPressProfileImage(strongSelf)
            } onDetailsPressed: {
                [weak self] in
                guard let strongSelf = self else {
                    return
                }
                
                strongSelf.interactionsHandler?.tweetCellDidPressProfileDetails(strongSelf)
            } onOptionsPressed: {
                [weak self] in
                guard let strongSelf = self else {
                    return
                }
                
                strongSelf.interactionsHandler?.tweetCellDidPressOptions(strongSelf)
            }
        }
        
        
        body.configure(withTweet: tweet)
        
        footer.configure(withTweet: tweet) {
            [weak self] in
            guard let strongSelf = self else {
                return
            }
            
            strongSelf.interactionsHandler?.tweetCellDidPressLikeDetails(strongSelf)
        } onLikePressed: {
            [weak self] in
            guard let strongSelf = self else {
                return
            }
            
            strongSelf.interactionsHandler?.tweetCellDidPressLike(strongSelf)
        }
    }
    
    // Interact
}
