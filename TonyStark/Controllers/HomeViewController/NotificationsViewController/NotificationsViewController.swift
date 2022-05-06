//
//  NotificationsViewController.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 16/03/22.
//

import UIKit

class NotificationsViewController: TXViewController {
    // Declare
    private let refreshControl: TXRefreshControl = {
        let refreshControl = TXRefreshControl()
        
        return refreshControl
    }()
    
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
        configureRefreshControl()
    }
    
    private func addSubviews() {
        view.addSubview(tableView)
    }
    
    private func configureNavigationBar() {
        navigationItem.title = "Notifications"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.refreshControl = refreshControl
        
        tableView.register(
            PartialTweetTableViewCell.self,
            forCellReuseIdentifier: PartialTweetTableViewCell.reuseIdentifier
        )
        
        tableView.addBufferOnHeader(withHeight: 0)
        
        tableView.pin(
            to: view,
            byBeingSafeAreaAware: true
        )
    }
    
    private func configureRefreshControl() {
        refreshControl.addTarget(
            self,
            action: #selector(onRefreshControllerChanged(_:)),
            for: .valueChanged
        )
    }
    
    // Populate
    
    // Interact
    @objc private func onRefreshControllerChanged(_ refreshControl: TXRefreshControl) {
        if refreshControl.isRefreshing {
            refreshControl.endRefreshing()
        } else {
            // TODO: Add refresh logic
        }
    }
}

// MARK: TXTableViewDataSource
extension NotificationsViewController: TXTableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 0
    }
    
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return 0
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        return UITableViewCell()
    }
}

// MARK: TXTableViewDelegate
extension NotificationsViewController: TXTableViewDelegate {
    
}
