//
//  OtherUserViewController.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 23/04/22.
//

import UIKit

class OtherUserViewController: TXViewController {
    // Declare
    private var user: User!
    
    private let tableView: TXTableView = {
        let tableView = TXTableView()
        
        tableView.enableAutolayout()
        
        return tableView
    }()
    
    // Configure
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSubviews()
        
        configureNavigationBar()
        configureTableView()
    }
    
    private func addSubviews() {
        view.addSubview(tableView)
    }
    
    private func configureNavigationBar() {
        navigationItem.largeTitleDisplayMode = .never
    }
    
    private func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.tableHeaderView = TXView(frame: .zero)
        
        tableView.register(
            OtherUserTableViewCell.self,
            forCellReuseIdentifier: OtherUserTableViewCell.reuseIdentifier
        )
        
        tableView.pin(to: view)
    }
    
    // Populate
    func populate(withUser user: User) {
        self.user = user
    }
    
    // Interact
}

// MARK: TXScrollViewDelegate
extension OtherUserViewController: TXScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print(#function)
        let currentYOffset = scrollView.contentOffset.y
        
        if currentYOffset < 40 {
            navigationItem.title = nil
        }
        
        if currentYOffset > 40 && navigationItem.title == nil {
            navigationItem.title = user.name
        }
    }
}

// MARK: TXTableViewDataSource
extension OtherUserViewController: TXTableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return 1
    }
    
    func tableView(
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

// MARK: TXTableViewDelegate
extension OtherUserViewController: TXTableViewDelegate {
    
}
