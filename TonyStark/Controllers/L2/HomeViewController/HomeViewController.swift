//
//  HomeViewController.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 16/03/22.
//

import UIKit

class HomeViewController: TxTabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViewControllers()
    }
    
    func configureViewControllers() {
        viewControllers = [
            makeFeedViewController(),
            makeExploreViewController(),
            makeComposeViewController(),
            makeNotificationsViewController(),
            makeProfileViewController()
        ]
    }
    
    func makeFeedViewController() -> UINavigationController {
        let feedViewController = FeedViewController()
        feedViewController.tabBarItem = TxTabBarItem(
            title: nil,
            image: UIImage(systemName: "house"),
            tag: 0
        )
        
        return TxNavigationController(rootViewController: feedViewController)
    }
    
    func makeExploreViewController() -> UINavigationController {
        let exploreViewController = ExploreViewController()
        exploreViewController.tabBarItem = TxTabBarItem(
            title: nil,
            image: UIImage(systemName: "magnifyingglass"),
            tag: 1
        )
        
        return TxNavigationController(rootViewController: exploreViewController)
    }
    
    func makeComposeViewController() -> UINavigationController {
        let composeViewController = ComposeViewController()
        composeViewController.tabBarItem = TxTabBarItem(
            title: nil,
            image: UIImage(systemName: "plus"),
            tag: 2
        )
        
        return TxNavigationController(rootViewController: composeViewController)
    }
    
    func makeNotificationsViewController() -> UINavigationController {
        let notificationsViewController = NotificationsViewController()
        notificationsViewController.tabBarItem = TxTabBarItem(
            title: nil,
            image: UIImage(systemName: "bell"),
            tag: 3
        )
        
        return TxNavigationController(rootViewController: notificationsViewController)
    }
    
    func makeProfileViewController() -> UINavigationController {
        let profileViewController = ProfileViewController()
        profileViewController.tabBarItem = TxTabBarItem(
            title: nil,
            image: UIImage(systemName: "person"),
            tag: 4
        )
        
        return TxNavigationController(rootViewController: profileViewController)
    }
}
