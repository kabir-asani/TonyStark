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
    }
    
    private func configureBaseView() {
        view.backgroundColor = .systemBackground
        
        tabBar.tintColor = .label
    }
}
