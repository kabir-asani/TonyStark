//
//  EditUsernameViewController.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 01/05/22.
//

import UIKit

protocol EditUsernameViewControllerInteractionsHandler: AnyObject {
    func editUsernameViewController(
        _ controller: EditUsernameViewController,
        didUpdateUsername username: String
    )
}

class EditUsernameViewController: TXViewController {
    // Declare
    enum EditUsernameTableViewSection: Int, CaseIterable {
        case username
    }
    
    weak var interactionsHandler: EditUsernameViewControllerInteractionsHandler?
    
    private var username: String!
    
    private let tableView: TXTableView = {
        let tableView = TXTableView(
            frame: .zero,
            style: .insetGrouped
        )
        
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        startKeyboardAwareness()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        stopKeyboardAwareness()
    }
    
    private func addSubviews() {
        view.addSubview(tableView)
    }
    
    private func configureNavigationBar() {
        navigationItem.title = "Username"
        
        navigationItem.rightBarButtonItem = TXBarButtonItem(
            barButtonSystemItem: .done,
            target: self,
            action: #selector(onDonePressed(_:))
        )
    }
    
    private func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.appendSpacerOnHeader()
        tableView.keyboardDismissMode = .onDrag
        
        tableView.register(
            EditUsernameTableViewCell.self,
            forCellReuseIdentifier: EditUsernameTableViewCell.reuseIdentifier
        )
        
        tableView.pin(
            to: view,
            byBeingSafeAreaAware: true
        )
    }
    
    // Populate
    func populate(withUsername username: String) {
        self.username = username
        
        if username.isEmpty {
            navigationItem.rightBarButtonItem?.isEnabled = false
        } else {
            navigationItem.rightBarButtonItem?.isEnabled = true
        }
    }
    
    // Interact
    @objc private func onDonePressed(_ sender: TXBarButtonItem) {
        // TOOD: Validate username
        
        interactionsHandler?.editUsernameViewController(
            self,
            didUpdateUsername: username
        )
    }
}

// MARK: TXTableViewDataSource
extension EditUsernameViewController: TXTableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        EditUsernameTableViewSection.allCases.count
    }
    
    func tableView(
        _ tableView: UITableView,
        titleForFooterInSection section: Int
    ) -> String? {
        switch section {
        case EditUsernameTableViewSection.username.rawValue:
            return "Username is a unique and cool way to identify yourself"
        default:
            return nil
        }
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
            withIdentifier: EditUsernameTableViewCell.reuseIdentifier,
            for: indexPath
        ) as! EditUsernameTableViewCell
        
        cell.delegate = self
        cell.configure(withText: username)
        
        return cell
    }
}

// MARK: TXTextViewDelegate
extension EditUsernameViewController: TXTableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        estimatedHeightForRowAt indexPath: IndexPath
    ) -> CGFloat {
        TXTableView.automaticDimension
    }
}

// MARK: EditUsernameTableViewCellDelegate
extension EditUsernameViewController: EditUsernameTableViewCellDelegate {
    func cell(
        _ cell: EditUsernameTableViewCell,
        didChangeText text: String
    ) {
        populate(withUsername: text)
    }
}
