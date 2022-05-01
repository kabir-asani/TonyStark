//
//  EditBioViewController.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 01/05/22.
//

import UIKit

class EditBioViewController: TXViewController {
    // Declare
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
        navigationItem.title = "Bio"
        
        navigationItem.rightBarButtonItem = TXBarButtonItem(
            barButtonSystemItem: .done,
            target: self,
            action: #selector(onDonePressed(_:))
        )
    }
    
    private func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.tableHeaderView = .init(frame: .zero)
        
        tableView.pin(
            to: view,
            byBeingSafeAreaAware: true
        )
    }
    
    // Populate
    
    // Interact
    @objc private func onDonePressed(_ sender: TXBarButtonItem) {
        print(#function)
    }
}

// MARK: TXTableViewDataSource
extension EditBioViewController: TXTableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
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

// MARK: TXTextViewDelegate
extension EditBioViewController: TXTableViewDelegate {
    
}
