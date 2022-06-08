//
//  TweetOptionsViewController.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 20/04/22.
//

import UIKit

protocol TweetOptionsAlertControllerInteractionsHandler: AnyObject {
    func tweetOptionsAlertControllerDidPressBookmark(_ controller: TweetOptionsAlertController)
    
    func tweetOptionsAlertControllerDidPressFollow(_ controller: TweetOptionsAlertController)
}

class TweetOptionsAlertController: TXAlertController {
    static func regular() -> TweetOptionsAlertController {
        return TweetOptionsAlertController(
            title: nil,
            message: nil,
            preferredStyle: .actionSheet
        )
    }
    
    // Declare
    weak var interactionsHandler: TweetOptionsAlertControllerInteractionsHandler?

    // Configure
    func configure(withTweet tweet: Tweet) {
        let bookmarkAction = UIAlertAction(
            title: tweet.viewables.bookmarked ? "Remove bookmark" : "Bookmark",
            style: .default
        ) {
            [weak self] action in
            guard let strongSelf = self else {
                return
            }
            
            strongSelf.interactionsHandler?.tweetOptionsAlertControllerDidPressBookmark(strongSelf)
        }
        
        addAction(bookmarkAction)
        
        if tweet.viewables.author.id != CurrentUserDataStore.shared.user!.id {
            let followAction = UIAlertAction(
                title: tweet.viewables.author.viewables.following ? "Remove follow" : "Follow",
                style: .default
            ) {
                [weak self] action in
                guard let strongSelf = self else {
                    return
                }
                
                strongSelf.interactionsHandler?.tweetOptionsAlertControllerDidPressFollow(strongSelf)
            }
            
            addAction(followAction)
        }
        
        let cancelAction = UIAlertAction(
            title: "Cancel",
            style: .cancel
        ) {
            [weak self] action in
            guard let strongSelf = self else {
                return
            }
            
            strongSelf.dismiss(animated: true)
        }
        
        addAction(cancelAction)
    }
}
