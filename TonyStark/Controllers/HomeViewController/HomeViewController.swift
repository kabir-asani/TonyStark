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
        let navigationController = TXNavigationController(
            rootViewController: feedViewController
        )
        
        navigationController.tabBarItem = TXTabBarItem(
            title: nil,
            image: UIImage(systemName: "house"),
            tag: 0
        )
        
        return navigationController
    }
    
    func makeExploreViewController() -> UINavigationController {
        let exploreViewController = ExploreViewController()
        let navigationController = TXNavigationController(
            rootViewController: exploreViewController
        )
        
        navigationController.tabBarItem = TXTabBarItem(
            title: nil,
            image: UIImage(systemName: "magnifyingglass"),
            tag: 1
        )
        
        return navigationController
    }

    func makeNotificationsViewController() -> UINavigationController {
        let notificationsViewController = NotificationsViewController()
        let navigationController = TXNavigationController(
            rootViewController: notificationsViewController
        )
        
        navigationController.tabBarItem = TXTabBarItem(
            title: nil,
            image: UIImage(systemName: "bell"),
            tag: 3
        )
        
        return navigationController
    }
    
    func makeProfileViewController() -> UINavigationController {
        let profileViewController = ProfileViewController()
        let navigationController = TXNavigationController(
            rootViewController: profileViewController
        )
        
        navigationController.tabBarItem = TXTabBarItem(
            title: nil,
            image: UIImage(systemName: "person"),
            tag: 4
        )
        
        return navigationController
    }
}
