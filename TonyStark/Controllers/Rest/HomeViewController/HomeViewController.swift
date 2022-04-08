//
//  HomeViewController.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 16/03/22.
//

import UIKit

class HomeViewController: TXTabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViewControllers()
    }
    
    func configureViewControllers() {
        viewControllers = [
            makeFeedViewController(),
            makeExploreViewController(),
            makeNotificationsViewController(),
            makeProfileViewController()
        ]
    }
    
    func makeFeedViewController() -> UINavigationController {
        let feedViewController = FeedViewController()
        feedViewController.tabBarItem = TXTabBarItem(
            title: nil,
            image: UIImage(systemName: "house"),
            tag: 0
        )
        
        return TXNavigationController(rootViewController: feedViewController)
    }
    
    func makeExploreViewController() -> UINavigationController {
        let exploreViewController = ExploreViewController()
        exploreViewController.tabBarItem = TXTabBarItem(
            title: nil,
            image: UIImage(systemName: "magnifyingglass"),
            tag: 1
        )
        
        return TXNavigationController(rootViewController: exploreViewController)
    }

    func makeNotificationsViewController() -> UINavigationController {
        let notificationsViewController = NotificationsViewController()
        notificationsViewController.tabBarItem = TXTabBarItem(
            title: nil,
            image: UIImage(systemName: "bell"),
            tag: 3
        )
        
        return TXNavigationController(rootViewController: notificationsViewController)
    }
    
    func makeProfileViewController() -> UINavigationController {
        let profileViewController = ProfileViewController()
        profileViewController.tabBarItem = TXTabBarItem(
            title: nil,
            image: UIImage(systemName: "person"),
            tag: 4
        )
        
        return TXNavigationController(rootViewController: profileViewController)
    }
}
