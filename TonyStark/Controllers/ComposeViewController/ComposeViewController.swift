//
//  ComposeViewController.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 16/03/22.
//

import UIKit

class ComposeViewController: TXTableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar()
        configureTableView()
    }
    
    private func configureNavigationBar() {
        navigationItem.title = "Compose"
        
        navigationItem.leftBarButtonItem = TXBarButtonItem(
            barButtonSystemItem: .cancel,
            target: self,
            action: #selector(onCancelPressed(_:))
        )
        
        navigationItem.rightBarButtonItem = TXBarButtonItem(
            title: "Tweet",
            style: .done,
            target: self,
            action: #selector(onDonePressed(_:))
        )
    }
    
    private func configureTableView() {
        tableView.register(
            ComposeTableViewCell.self,
            forCellReuseIdentifier: ComposeTableViewCell.reuseIdentifer
        )
    }
    
    @objc private func onDonePressed(_ sender: UIBarButtonItem) {
    }
    
    @objc private func onCancelPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
}

// MARK: UITableViewDataSource
extension ComposeViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
}

// MARK: UITableViewDelegate
extension ComposeViewController {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: ComposeTableViewCell.reuseIdentifer,
            for: indexPath
        ) as! ComposeTableViewCell
        
        return cell
    }
}
