//
//  TTabBarController.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 16/03/22.
//

import UIKit

class TXTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureBaseView()
        configureTabBar()
    }
    
    private func configureBaseView() {
        view.backgroundColor = .systemBackground
    }
    
    private func configureTabBar() {
        tabBar.tintColor = .label
        tabBar.isTranslucent = true
    }
}
