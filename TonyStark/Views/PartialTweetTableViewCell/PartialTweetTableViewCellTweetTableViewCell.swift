//
//  TweetTableViewCell.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 14/04/22.
//

import UIKit

protocol PartialTweetTableViewCellInteractionsHandler: AnyObject {
    func didPressLike(_ cell: PartialTweetTableViewCell)
    
    func didPressComment(_ cell: PartialTweetTableViewCell)
    
    func didPressProfileImage(_ cell: PartialTweetTableViewCell)
    
    @available(iOS 14, *)
    func didPressBookmarksOption(_ cell: PartialTweetTableViewCell)
    
    @available(iOS 14, *)
    func didPressFollowOption(_ cell: PartialTweetTableViewCell)
    
    @available(iOS, deprecated: 14)
    func didPressOption(_ cell: PartialTweetTableViewCell)
}

class PartialTweetTableViewCell: TXTableViewCell {
    override class var reuseIdentifier: String {
        String(describing: PartialTweetTableViewCell.self)
    }
    
    // Declare
    weak var interactionsHandler: PartialTweetTableViewCellInteractionsHandler?
    
    private let leading: PartialTweetViewCellLeading = {
        let leading = PartialTweetViewCellLeading()
        
        leading.enableAutolayout()
        
        return leading
    }()
    
    private let trailing: PartialTweetViewCellTrailing = {
        let trailing = PartialTweetViewCellTrailing()
        
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
            
            guard let strongSelf = self else {
                return
            }
            
            strongSelf.interactionsHandler?.didPressProfileImage(strongSelf)
        }
        
        if #available(iOS 14, *) {
            trailing.configure(
                withTweet: tweet
            ) {
                [weak self] in
                
                guard let strongSelf = self else {
                    return
                }
                
                strongSelf.interactionsHandler?.didPressLike(strongSelf)
            } onCommentPressed: {
                [weak self] in
                
                guard let strongSelf = self else {
                    return
                }
                
                strongSelf.interactionsHandler?.didPressComment(strongSelf)
            } onBookmarksPressed: {
                [weak self] in
                
                guard let strongSelf = self else {
                    return
                }
                
                strongSelf.interactionsHandler?.didPressBookmarksOption(strongSelf)
            } onFollowPressed: {
                [weak self] in
                
                guard let strongSelf = self else {
                    return
                }
                
                strongSelf.interactionsHandler?.didPressFollowOption(strongSelf)
            }
        } else {
            trailing.configure(
                withTweet: tweet
            ) {
                [weak self] in
                
                guard let strongSelf = self else {
                    return
                }
                
                strongSelf.interactionsHandler?.didPressLike(strongSelf)
            } onCommentPressed: {
                [weak self] in
                
                guard let strongSelf = self else {
                    return
                }
                
                strongSelf.interactionsHandler?.didPressComment(strongSelf)
            } onOptionsPressed: {
                [weak self] in
                
                guard let strongSelf = self else {
                    return
                }
                
                strongSelf.interactionsHandler?.didPressOption(strongSelf)
            }
        }
    }
}
