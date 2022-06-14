//
//  NotificationsViewController.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 16/03/22.
//

import UIKit

class NotificationsViewController: TXViewController {
    // Declare
    enum NotificationsTableViewSection: Int, CaseIterable {
        case main
    }
    
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
        navigationItem.title = ""
    }
    
    private func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(
            EmptyNotificationsTableViewCell.self,
            forCellReuseIdentifier: EmptyNotificationsTableViewCell.reuseIdentifier
        )
        
        tableView.appendSpacerOnHeader()
        
        tableView.pin(
            to: view,
            byBeingSafeAreaAware: true
        )
    }
    
    private func configureRefreshControl() {
        let refreshControl = TXRefreshControl()
        refreshControl.delegate = self
        
        tableView.refreshControl = refreshControl
    }
    
    // Populate
}

// MARK: TXTableViewDataSource
extension NotificationsViewController: TXTableViewDataSource {
    func numberOfSections(
        in tableView: UITableView
    ) -> Int {
        NotificationsTableViewSection.allCases.count
    }
    
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        1
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: EmptyNotificationsTableViewCell.reuseIdentifier,
            for: indexPath
        ) as! EmptyNotificationsTableViewCell
        
        return cell
    }
}

// MARK: TXTableViewDelegate
extension NotificationsViewController: TXTableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        willDisplay cell: UITableViewCell,
        forRowAt indexPath: IndexPath
    ) {
        if indexPath.row == tableView.numberOfRows(inSection: NotificationsTableViewSection.main.rawValue) - 1 {
            tableView.removeSeparatorOnCell(cell)
        } else {
            tableView.appendSeparatorOnCell(cell)
        }
    }
}

extension NotificationsViewController: TXRefreshControlDelegate {
    func refreshControlDidChange(_ control: TXRefreshControl) {
        print(#function)
    }
}
