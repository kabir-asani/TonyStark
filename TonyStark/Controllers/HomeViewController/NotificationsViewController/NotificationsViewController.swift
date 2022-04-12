//
//  NotificationsViewController.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 16/03/22.
//

import UIKit

class NotificationsViewController: TXTableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureBaseView()
        configureNavigationBar()
    }
    
    private func configureBaseView() {
        view.backgroundColor = .systemRed
    }
    
    
    private func configureNavigationBar() {
        navigationItem.title = "Notifications"
    }
}
