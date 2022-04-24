//
//  TweetOptions.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 18/04/22.
//

import Foundation
import UIKit

class TweetOptions: UIView {
    // Declare
    private var onBookmarkPressed: (() -> Void)?
    private var onFollowPressed: (() -> Void)?
    private var onOptionsPressed: (() -> Void)?
    
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
        
        optionsButton.fixHeight(to: 20)
        
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
        
        configureOptionsButton(
            withData: (
                isBookmarked: tweet.viewables.bookmarked,
                isFollower: tweet.author.viewables.follower
            )
        )
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
    private func configureOptionsButton(
        withData data: (
            isBookmarked: Bool,
            isFollower: Bool
        )
    ) {
        optionsButton.showsMenuAsPrimaryAction = true
        optionsButton.menu = TXMenu(
            children: [
                UIAction(
                    title: data.isBookmarked ? "Remove bookmark" : "Bookmark",
                    image: UIImage(systemName: data.isBookmarked ? "bookmark.fill" : "bookmark")
                ) { [weak self] action in
                    guard let strongSelf = self else {
                        return
                    }
                    
                    strongSelf.onBookmarkPressed?()
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
                    guard let strongSelf = self else {
                        return
                    }
                    
                    strongSelf.onFollowPressed?()
                }
            ]
        )
    }
    
    // Interact
    @objc private func onOptionsPressed(_ sender: TXButton) {
        onOptionsPressed?()
    }
}
