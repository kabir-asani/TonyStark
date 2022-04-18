//
//  TweetOptions.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 18/04/22.
//

import Foundation
import UIKit

class TweetOptions: UIView {
    private var tweet: Tweet!
    
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
    
    func configure(with tweet: Tweet) {
        self.tweet = tweet
        
        configureOptionsButton()
    }
    
    private func configureOptionsButton() {
        if #available(iOS 14.0, *) {
            optionsButton.showsMenuAsPrimaryAction = true
            optionsButton.menu = UIMenu(
                title: "",
                children: [
                    UIAction(
                        title: tweet.viewables.bookmarked ? "Remove bookmark" : "Bookmark",
                        image: UIImage(systemName: tweet.viewables.bookmarked ? "bookmark.fill" : "bookmark")
                    ) { action in
                        
                    },
                    UIAction(
                        title: tweet.author.viewables.follower
                        ? "Unfollow"
                        : "Follow",
                        image: UIImage(
                            systemName: tweet.author.viewables.follower
                            ? "person.badge.plus.fill"
                            : "person.badge.plus"
                        )
                    ) { action in
                        
                    }
                ]
            )
        } else {
            optionsButton.addTarget(
                self,
                action: #selector(onOptionsPressed(_:)),
                for: .touchUpInside
            )
        }
    }
    
    @objc private func onOptionsPressed(_ sender: TXButton) {
        print(#function)
    }
}
