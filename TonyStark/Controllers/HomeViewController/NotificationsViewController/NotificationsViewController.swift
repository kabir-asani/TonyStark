//
//  NotificationsViewController.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 16/03/22.
//

import UIKit

class NotificationsViewController: TXTableViewController {
    // Declare
    
    // Configure
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar()
    }
    
    private func configureNavigationBar() {
        navigationItem.title = "Notifications"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    // Populate
    
    // Ineteract
}
