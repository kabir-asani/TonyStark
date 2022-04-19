//
//  TweetOptions.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 18/04/22.
//

import Foundation
import UIKit

protocol TweetOptionsInteractionsHandler: TweetViewCellTrailingFooter {
    @available(iOS 14.0, *)
    func didPressBookmark(_ tweetOptions: TweetOptions)
    
    @available(iOS 14.0, *)
    func didPressFollow(_ tweetOptions: TweetOptions)
    
    @available(iOS, deprecated: 14)
    func didPressOptions(_ tweetOptions: TweetOptions)
}

class TweetOptions: UIView {
    // Declare
    weak var interactionsHandler: TweetOptionsInteractionsHandler?
    
    private let optionsButton: UIButton = {
        let optionsButton = UIButton()
        
        optionsButton.enableAutolayout()
        optionsButton.tintColor = .gray
        optionsButton.setImage(
            UIImage(systemName: "tray.full"),
            for: .normal
        )
        if #available(iOS 14.0, *) {
            optionsButton.showsMenuAsPrimaryAction = true
        }
        
        optionsButton.heightConstaint(with: 20)
        
        return optionsButton
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
        addSubview(optionsButton)
        
        optionsButton.pin(to: self)
    }
    
    // Configure
    func configure(
        withTweet tweet: Tweet
    ) {
        if #available(iOS 14.0, *) {
            configureOptionsButton(
                withData: (
                    isBookmarked: tweet.viewables.bookmarked,
                    isFollower: tweet.author.viewables.follower
                )
            )
        } else {
            optionsButton.addTarget(
                self,
                action: #selector(onOptionsPressed(_:)),
                for: .touchUpInside
            )
        }
    }
    
    @available(iOS 14.0, *)
    private func configureOptionsButton(
        withData data: (
            isBookmarked: Bool,
            isFollower: Bool
        )
    ) {
        optionsButton.showsMenuAsPrimaryAction = true
        optionsButton.menu = UIMenu(
            children: [
                UIAction(
                    title: data.isBookmarked ? "Remove bookmark" : "Bookmark",
                    image: UIImage(systemName: data.isBookmarked ? "bookmark.fill" : "bookmark")
                ) { [weak self] action in
                    guard let safeSelf = self else {
                        return
                    }
                    
                    safeSelf.interactionsHandler?.didPressBookmark(safeSelf)
                },
                UIAction(
                    title: data.isFollower
                    ? "Unfollow"
                    : "Follow",
                    image: UIImage(
                        systemName: data.isFollower
                        ? "person.badge.plus.fill"
                        : "person.badge.plus"
                    )
                ) { [weak self] action in
                    guard let safeSelf = self else {
                        return
                    }
                    
                    safeSelf.interactionsHandler?.didPressFollow(safeSelf)
                }
            ]
        )
    }
    
    // Interact
    @objc private func onOptionsPressed(_ sender: TXButton) {
        interactionsHandler?.didPressOptions(self)
    }
}
