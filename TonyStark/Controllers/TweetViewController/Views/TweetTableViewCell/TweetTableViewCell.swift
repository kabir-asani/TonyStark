//
//  PartialUserTableViewCell.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 25/04/22.
//

import UIKit

protocol TweetTableViewCellInteractionsHandler: AnyObject {
    func didPressProfileImage(_ cell: TweetTableViewCell)
    
    func didPressDetails(_ cell: TweetTableViewCell)
    
    func didPressLike(_ cell: TweetTableViewCell)
    
    func didPressLikeDetails(_ cell: TweetTableViewCell)
}

class TweetTableViewCell: TXTableViewCell {
    // Declare
    override class var reuseIdentifier: String {
        String(describing: TweetTableViewCell.self)
    }
    
    weak var interactionsHandler: TweetTableViewCellInteractionsHandler?
    
    private let header: TweetTableViewCellHeader = {
        let header = TweetTableViewCellHeader()
        
        header.enableAutolayout()
        
        return header
    }()
    
    private let body: TweetTableViewCellBody = {
        let body = TweetTableViewCellBody()
        
        body.enableAutolayout()
        
        return body
    }()
    
    private let footer: TweetTableViewCellFooter = {
        let footer = TweetTableViewCellFooter()
        
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
        separatorInset = .zero
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
        header.configure(
            withTweet: tweet
        ) {
            [weak self] in
            guard let strongSelf = self else {
                return
            }
            
            strongSelf.interactionsHandler?.didPressProfileImage(strongSelf)
        } onDetailsPressed: {
            [weak self] in
            guard let strongSelf = self else {
                return
            }
            
            strongSelf.interactionsHandler?.didPressDetails(strongSelf)
        }
        
        body.configure(withTweet: tweet)
        
        footer.configure(withTweet: tweet) {
            [weak self] in
            guard let strongSelf = self else {
                return
            }
            
            strongSelf.interactionsHandler?.didPressLikeDetails(strongSelf)
        } onLikePressed: {
            [weak self] in
            guard let strongSelf = self else {
                return
            }
            
            strongSelf.interactionsHandler?.didPressLike(strongSelf)
        }
    }
    
    // Interact
}
