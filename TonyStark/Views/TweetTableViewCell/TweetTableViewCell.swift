//
//  TweetTableViewCell.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 14/04/22.
//

import UIKit

protocol TweetTableViewCellInteractionsHandler: AnyObject {
    func didPressLike(_ cell: TweetTableViewCell)
    
    func didPressComment(_ cell: TweetTableViewCell)
    
    func didPressProfileImage(_ cell: TweetTableViewCell)
    
    @available(iOS 14, *)
    func didPressBookmarksOption(_ cell: TweetTableViewCell)
    
    @available(iOS 14, *)
    func didPressFollowOption(_ cell: TweetTableViewCell)
    
    @available(iOS, deprecated: 14)
    func didPressOption(_ cell: TweetTableViewCell)
}

class TweetTableViewCell: TXTableViewCell {
    override class var reuseIdentifier: String {
        String(describing: TweetTableViewCell.self)
    }
    
    // Declare
    weak var interactionsHandler: TweetTableViewCellInteractionsHandler?
    
    private let leading: TweetViewCellLeading = {
        let leading = TweetViewCellLeading()
        
        leading.enableAutolayout()
        
        return leading
    }()
    
    private let trailing: TweetViewCellTrailing = {
        let trailing = TweetViewCellTrailing()
        
        trailing.enableAutolayout()
        
        return trailing
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
        
        arrageBaseView()
        arrangeSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func arrageBaseView() {
        self.selectionStyle = .none
    }
    
    private func arrangeSubviews() {
        let combinateStackView = makeCombinedStackView()
        
        addSubview(combinateStackView)
        
        combinateStackView.pin(
            to: self,
            withInsets: TXEdgeInsets(
                top: 16,
                right: 16,
                bottom: 16,
                left: 16
            )
        )
    }
    
    private func makeCombinedStackView() -> TXStackView {
        let combinateStack = TXStackView(
            arrangedSubviews: [
                leading,
                trailing
            ]
        )
        
        combinateStack.enableAutolayout()
        combinateStack.axis = .horizontal
        combinateStack.distribution = .fill
        combinateStack.alignment = .top
        combinateStack.spacing = 16
        
        return combinateStack
    }
    
    // Configure
    func configure(withTweet tweet: Tweet) {
        leading.configure(
            withTweet: tweet
        ) {
            [weak self] in
            
            guard let safeSelf = self else {
                return
            }
            
            safeSelf.interactionsHandler?.didPressProfileImage(safeSelf)
        }
        
        if #available(iOS 14, *) {
            trailing.configure(
                withTweet: tweet
            ) {
                [weak self] in
                
                guard let safeSelf = self else {
                    return
                }
                
                safeSelf.interactionsHandler?.didPressLike(safeSelf)
            } onCommentPressed: {
                [weak self] in
                
                guard let safeSelf = self else {
                    return
                }
                
                safeSelf.interactionsHandler?.didPressComment(safeSelf)
            } onBookmarksPressed: {
                [weak self] in
                
                guard let safeSelf = self else {
                    return
                }
                
                safeSelf.interactionsHandler?.didPressBookmarksOption(safeSelf)
            } onFollowPressed: {
                [weak self] in
                
                guard let safeSelf = self else {
                    return
                }
                
                safeSelf.interactionsHandler?.didPressFollowOption(safeSelf)
            }
        } else {
            trailing.configure(
                withTweet: tweet
            ) {
                [weak self] in
                
                guard let safeSelf = self else {
                    return
                }
                
                safeSelf.interactionsHandler?.didPressLike(safeSelf)
            } onCommentPressed: {
                [weak self] in
                
                guard let safeSelf = self else {
                    return
                }
                
                safeSelf.interactionsHandler?.didPressComment(safeSelf)
            } onOptionsPressed: {
                [weak self] in
                
                guard let safeSelf = self else {
                    return
                }
                
                safeSelf.interactionsHandler?.didPressOption(safeSelf)
            }
        }
    }
}
