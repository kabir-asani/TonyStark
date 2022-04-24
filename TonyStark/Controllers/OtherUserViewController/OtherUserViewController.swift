//
//  OtherUserViewController.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 23/04/22.
//

import UIKit

class OtherUserViewController: TXTableViewController {
    // Declare
    private var user: User!
    
    // Arrange
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar()
        configureTableView()
    }
    
    private func configureNavigationBar() {
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationBar.isTranslucent = true
    }
    
    private func configureTableView() {
        tableView.tableHeaderView = TXView(frame: .zero)
        
        tableView.register(
            OtherUserTableViewCell.self,
            forCellReuseIdentifier: OtherUserTableViewCell.reuseIdentifier
        )
    }
    
    // Configure
    func configure(withUser user: User) {
        self.user = user
    }
    
    // Interact
}

// MARK: UIScrollViewDelegate
extension OtherUserViewController {
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentYOffset = scrollView.contentOffset.y
        
        if currentYOffset < 140 {
            navigationItem.title = nil
        }
        
        if currentYOffset > 140 && navigationItem.title == nil {
            navigationItem.title = user.name
        }
    }
}

// MARK: UITableViewDataSource
extension OtherUserViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return 1
    }
}

// MARK: UITableViewDelegate
extension OtherUserViewController {
    override func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIndexPath(
            withIdentifier: OtherUserTableViewCell.reuseIdentifier,
            for: indexPath
        ) as! OtherUserTableViewCell
        
        cell.configure(withUser: user)
        
        return cell
    }
}
