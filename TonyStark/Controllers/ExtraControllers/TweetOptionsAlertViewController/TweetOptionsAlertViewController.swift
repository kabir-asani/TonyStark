//
//  TweetOptionsViewController.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 20/04/22.
//

import UIKit

protocol TweetOptionsAlertViewControllerInteractionsHandler: AnyObject {
    func didPressBookmark(_ tweetOptionsAlertViewController: TweetOptionsAlertViewController)
    
    func didPressFollow(_ tweetOptionsAlertViewController: TweetOptionsAlertViewController)
}

class TweetOptionsAlertViewController: UIAlertController {
    static func regular() -> TweetOptionsAlertViewController {
        return TweetOptionsAlertViewController(
            title: nil,
            message: nil,
            preferredStyle: .actionSheet
        )
    }
    
    // Declare
    weak var interactionsHandler: TweetOptionsAlertViewControllerInteractionsHandler?

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
            
            strongSelf.interactionsHandler?.didPressBookmark(strongSelf)
        }
        
        addAction(bookmarkAction)
        
        if tweet.author.id != UserProvider.current.user.id {
            let followAction = UIAlertAction(
                title: tweet.author.viewables.follower ? "Remove follow" : "Follow",
                style: .default
            ) {
                [weak self] action in
                guard let strongSelf = self else {
                    return
                }
                
                strongSelf.interactionsHandler?.didPressFollow(strongSelf)
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
