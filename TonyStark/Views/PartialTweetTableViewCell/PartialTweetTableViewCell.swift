//
//  TweetTableViewCell.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 14/04/22.
//

import UIKit

protocol PartialTweetTableViewCellInteractionsHandler: AnyObject {
    func partialTweetCellDidPressLike(_ cell: PartialTweetTableViewCell)
    
    func partialTweetCellDidPressComment(_ cell: PartialTweetTableViewCell)
    
    func partialTweetCellDidPressProfileImage(_ cell: PartialTweetTableViewCell)
    
    @available(iOS 14, *)
    func partialTweetCellDidPressBookmarksOption(_ cell: PartialTweetTableViewCell)
    
    @available(iOS 14, *)
    func partialTweetCellDidPressFollowOption(_ cell: PartialTweetTableViewCell)
    
    @available(iOS 14, *)
    func partialTweetCellDidPressDeleteOption(_ cell: PartialTweetTableViewCell)
    
    @available(iOS, deprecated: 14)
    func partialTweetCellDidPressOptions(_ cell: PartialTweetTableViewCell)
}

class PartialTweetTableViewCell: TXTableViewCell {
    override class var reuseIdentifier: String {
        String(describing: PartialTweetTableViewCell.self)
    }
    
    // Declare
    weak var interactionsHandler: PartialTweetTableViewCellInteractionsHandler?
    
    private let leading: Leading = {
        let leading = Leading()
        
        leading.enableAutolayout()
        
        return leading
    }()
    
    private let trailing: Trailing = {
        let trailing = Trailing()
        
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
        self.separatorInset = defaultSeparatorInsets
    }
    
    private func arrangeSubviews() {
        let combinateStackView = makeCombinedStackView()
        
        addSubview(combinateStackView)
        
        combinateStackView.pin(
            to: self,
            withInsets: .all(16)
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
            
            strongSelf.interactionsHandler?.partialTweetCellDidPressProfileImage(strongSelf)
        }
        
        if #available(iOS 14, *) {
            trailing.configure(
                withTweet: tweet
            ) {
                [weak self] in
                
                guard let strongSelf = self else {
                    return
                }
                
                strongSelf.interactionsHandler?.partialTweetCellDidPressLike(strongSelf)
            } onCommentPressed: {
                [weak self] in
                
                guard let strongSelf = self else {
                    return
                }
                
                strongSelf.interactionsHandler?.partialTweetCellDidPressComment(strongSelf)
            } onBookmarksPressed: {
                [weak self] in
                
                guard let strongSelf = self else {
                    return
                }
                
                strongSelf.interactionsHandler?.partialTweetCellDidPressBookmarksOption(strongSelf)
            } onFollowPressed: {
                [weak self] in
                
                guard let strongSelf = self else {
                    return
                }
                
                strongSelf.interactionsHandler?.partialTweetCellDidPressFollowOption(strongSelf)
            } onDeletePressed: {
                [weak self] in
                guard let strongSelf = self else {
                    return
                }
                
                strongSelf.interactionsHandler?.partialTweetCellDidPressDeleteOption(strongSelf)
            }
        } else {
            trailing.configure(
                withTweet: tweet
            ) {
                [weak self] in
                
                guard let strongSelf = self else {
                    return
                }
                
                strongSelf.interactionsHandler?.partialTweetCellDidPressLike(strongSelf)
            } onCommentPressed: {
                [weak self] in
                
                guard let strongSelf = self else {
                    return
                }
                
                strongSelf.interactionsHandler?.partialTweetCellDidPressComment(strongSelf)
            } onOptionsPressed: {
                [weak self] in
                
                guard let strongSelf = self else {
                    return
                }
                
                strongSelf.interactionsHandler?.partialTweetCellDidPressOptions(strongSelf)
            }
        }
    }
}
