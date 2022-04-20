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
    static let reuseIdentifier = String(describing: TweetTableViewCell.self)
    
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
            padding: UIEdgeInsets(
                top: 16,
                left: 16,
                bottom: -16,
                right: -16
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
        leading.interactionsHandler = self
        leading.configure(withTweet: tweet)
        
        trailing.interactionsHandler = self
        trailing.configure(withTweet: tweet)
    }
}

// MARK: TweetViewCellLeadingInteractionsHandler
extension TweetTableViewCell: TweetViewCellLeadingInteractionsHandler {
    func onProfileImagePressed() {
        interactionsHandler?.didPressProfileImage(self)
    }
}

// MARK: TweetViewCellTrailingInteractionsHandler
extension TweetTableViewCell: TweetViewCellTrailingInteractionsHandler {
    func didPressLike(_ tweetViewCellTrailing: TweetViewCellTrailing) {
        interactionsHandler?.didPressLike(self)
    }
    
    func didPressComment(_ tweetViewCellTrailing: TweetViewCellTrailing) {
        interactionsHandler?.didPressComment(self)
    }
    
    @available(iOS 14, *)
    func didPressBookmark(_ tweetViewCellTrailing: TweetViewCellTrailing) {
        interactionsHandler?.didPressBookmarksOption(self)
    }
    
    @available(iOS 14, *)
    func didPressFollow(_ tweetViewCellTrailing: TweetViewCellTrailing) {
        interactionsHandler?.didPressFollowOption(self)
    }
    
    func didPressOptions(_ tweetViewCellTrailing: TweetViewCellTrailing) {
        interactionsHandler?.didPressOption(self)
    }
}
