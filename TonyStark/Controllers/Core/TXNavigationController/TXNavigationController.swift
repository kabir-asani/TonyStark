//
//  TNavigationController.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 16/03/22.
//

import UIKit

protocol TXNavigationControllerDelegate: UINavigationControllerDelegate {
    
}

class TXNavigationController: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureBaseView()
        configureNavigationBar()
    }
    
    private func configureBaseView() {
        view.backgroundColor = .systemBackground
    }
    
    private func configureNavigationBar() {
        navigationBar.tintColor = .label
        navigationBar.isTranslucent = true
    }
}

extension UINavigationController {
    func openUserViewController(
        withUser user: User
    ) {
        if let currentUser = CurrentUserDataStore.shared.user, user.id == currentUser.id {
            TXEventBroker.shared.emit(
                event: HomeTabSwitchEvent(
                    tab: HomeViewController.TabItem.user
                )
            )
        } else {
            let mayBeOtherUserViewController = viewControllers.first { viewController in
                if let otherUserViewController = viewController as? OtherUserViewController {
                    if otherUserViewController.user.id == user.id {
                        return true
                    }
                }
                
                return false
            }
            
            if let otherUserViewController =  mayBeOtherUserViewController {
                popToViewController(
                    otherUserViewController,
                    animated: true
                )
            } else {
                let otherUserViewController = OtherUserViewController()
                
                otherUserViewController.populate(withUser: user)
                
                pushViewController(
                    otherUserViewController,
                    animated: true
                )
            }
        }
    }
    
    func openTweetViewController(
        withTweet tweet: Tweet,
        andOptions options: TweetViewController.Options = .default
    ) {
        let tweetViewController = TweetViewController()
        
        tweetViewController.populate(
            withTweet: tweet,
            options: options
        )
        
        pushViewController(
            tweetViewController,
            animated: true
        )
    }
    
    func openComposeViewController() {
        let composeViewController = TXNavigationController(
            rootViewController: ComposeViewController()
        )
        
        composeViewController.modalPresentationStyle = .fullScreen
        
        present(composeViewController, animated: true)
    }
}
