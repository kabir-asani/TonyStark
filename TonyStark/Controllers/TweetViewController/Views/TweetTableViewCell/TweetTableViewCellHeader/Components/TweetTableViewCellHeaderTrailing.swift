//
//  PartialUserTableViewCellHeaderTrailing.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 25/04/22.
//

import UIKit

class TweetTableViewCellHeaderTrailing: TXView {
    // Declare
    private var onBookmarkPressed: (() -> Void)?
    private var onFollowPressed: (() -> Void)?
    private var onOptionsPressed: (() -> Void)?
    
    private let optionsButton: TXButton = {
        let optionsButton = TXButton()
        
        optionsButton.enableAutolayout()
        optionsButton.setImage(
            UIImage(systemName: "ellipsis"),
            for: .normal
        )
        optionsButton.imageView?.tintColor = .systemGray
        
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
    @available (iOS 14.0, *)
    func configure(
        withTweet tweet: Tweet,
        onBookmarkPressed: @escaping () -> Void,
        onFollowPressed: @escaping () -> Void
    ) {
        self.onBookmarkPressed = onBookmarkPressed
        self.onFollowPressed = onFollowPressed
        
        configureOptionsButton(withTweet: tweet)
    }
    
    @available (iOS, deprecated: 14.0)
    func configure(onOptionsPressed: @escaping () -> Void) {
        self.onOptionsPressed = onOptionsPressed
        
        optionsButton.addTarget(
            self,
            action: #selector(onOptionsPressed(_:)),
            for: .touchUpInside
        )
    }
    
    @available(iOS 14.0, *)
    private func configureOptionsButton(withTweet tweet: Tweet) {
        optionsButton.showsMenuAsPrimaryAction = true
        
        var children = [
            UIAction(
                title: tweet.viewables.bookmarked ? "Remove bookmark" : "Bookmark",
                image: UIImage(
                    systemName: tweet.viewables.bookmarked
                    ? "bookmark.fill"
                    : "bookmark"
                )
            ) { [weak self] action in
                guard let strongSelf = self else {
                    return
                }
                
                strongSelf.onBookmarkPressed?()
            }
        ]
        
        if tweet.author.id != CurrentUserDataStore.shared.user!.id {
            children.append(
                UIAction(
                    title: tweet.author.viewables.follower
                    ? "Unfollow"
                    : "Follow",
                    image: UIImage(
                        systemName: tweet.author.viewables.follower
                        ? "person.badge.plus.fill"
                        : "person.badge.plus"
                    )
                ) { [weak self] action in
                    guard let strongSelf = self else {
                        return
                    }
                    
                    strongSelf.onFollowPressed?()
                }
            )
        }
        
        optionsButton.menu = TXMenu(children: children)
    }
    
    // Interact
    @objc private func onOptionsPressed(_ sender: TXButton) {
        onOptionsPressed?()
    }
    
    // Interact
}
