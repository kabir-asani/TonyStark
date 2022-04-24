//
//  HomeViewController.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 16/03/22.
//

import UIKit

class HomeViewController: TXTabBarController {
    // Declare
    enum TabItem: Int {
        case feed
        case explore
        case notifications
        case user
    }
    
    // Configure
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureEventListener()
        configureViewControllers()
    }
    
    private func configureEventListener() {
        TXEventBroker.shared.listen {
            [weak self] event in
            guard let safeSelf = self else {
                return
            }
            
            if let event = event as? HomeViewTabSwitchEvent {
                safeSelf.selectedIndex = event.tab.rawValue
            }
        }
    }
    
    private func configureViewControllers() {
        viewControllers = [
            makeFeedViewController(),
            makeExploreViewController(),
            makeNotificationsViewController(),
            makeCurrentUserViewController()
        ]
    }
    
    private func makeFeedViewController() -> TXNavigationController {
        let feedViewController = FeedViewController()
        let navigationController = TXNavigationController(
            rootViewController: feedViewController
        )
        
        navigationController.tabBarItem = TXTabBarItem(
            title: nil,
            image: UIImage(systemName: "house"),
            tag: TabItem.feed.rawValue
        )
        
        return navigationController
    }
    
    private func makeExploreViewController() -> TXNavigationController {
        let exploreViewController = ExploreViewController()
        let navigationController = TXNavigationController(
            rootViewController: exploreViewController
        )
        
        navigationController.tabBarItem = TXTabBarItem(
            title: nil,
            image: UIImage(systemName: "magnifyingglass"),
            tag: TabItem.explore.rawValue
        )
        
        return navigationController
    }

    private func makeNotificationsViewController() -> TXNavigationController {
        let notificationsViewController = NotificationsViewController()
        let navigationController = TXNavigationController(
            rootViewController: notificationsViewController
        )
        
        navigationController.tabBarItem = TXTabBarItem(
            title: nil,
            image: UIImage(systemName: "bell"),
            tag: TabItem.notifications.rawValue
        )
        
        return navigationController
    }
    
    private func makeCurrentUserViewController() -> TXNavigationController {
        let currentUserViewController = CurrentUserViewController()
        let navigationController = TXNavigationController(
            rootViewController: currentUserViewController
        )
        
        navigationController.tabBarItem = TXTabBarItem(
            title: nil,
            image: UIImage(systemName: "person"),
            tag: TabItem.user.rawValue
        )
        
        return navigationController
    }
    
    // Populate
    
    // Interact
}

