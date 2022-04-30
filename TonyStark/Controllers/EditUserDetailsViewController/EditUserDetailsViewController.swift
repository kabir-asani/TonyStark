//
//  EditProfileViewController.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 20/04/22.
//

import UIKit

class EditUserDetailsViewController: TXViewController {
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
        navigationItem.title = "Edit Profile"
        
        navigationItem.leftBarButtonItem = TXBarButtonItem(
            barButtonSystemItem: .cancel,
            target: self,
            action: #selector(onCancelPressed(_:))
        )
        
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
        tableView.keyboardDismissMode = .onDrag
        
        tableView.register(
            EditProfileImageTableViewCell.self,
            forCellReuseIdentifier: EditProfileImageTableViewCell.reuseIdentifier
        )
        tableView.register(
            EditNameTableViewCell.self,
            forCellReuseIdentifier: EditNameTableViewCell.reuseIdentifier
        )
        tableView.register(
            EditUsernameTableViewCell.self,
            forCellReuseIdentifier: EditUsernameTableViewCell.reuseIdentifier
        )
        tableView.register(
            EditBioTableViewCell.self,
            forCellReuseIdentifier: EditBioTableViewCell.reuseIdentifier
        )
        
        tableView.pin(
            to: view,
            byBeingSafeAreaAware: true
        )
    }
    
    // Populate
    func populate(withUser user: User) {
        self.user = user
    }
    
    // Interact
    @objc private func onCancelPressed(_ sender: TXBarButtonItem) {
        dismiss(animated: true)
    }
    
    @objc private func onDonePressed(_ sender: TXBarButtonItem) {
        print(#function)
    }
}

// MARK: TXTableViewDataSource
extension EditUserDetailsViewController: TXTableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return 4
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCellWithIndexPath(
                withIdentifier: EditProfileImageTableViewCell.reuseIdentifier,
                for: indexPath
            ) as! EditProfileImageTableViewCell
            
            cell.configure(withImageURL: user.image)
            
            return cell
            
        case 1:
            let cell = tableView.dequeueReusableCellWithIndexPath(
                withIdentifier: EditNameTableViewCell.reuseIdentifier,
                for: indexPath
            ) as! EditNameTableViewCell
            
            cell.configure(withText: user.name)
            
            return cell
        case 2:
            let cell = tableView.dequeueReusableCellWithIndexPath(
                withIdentifier: EditUsernameTableViewCell.reuseIdentifier,
                for: indexPath
            ) as! EditUsernameTableViewCell
            
            cell.configure(withText: user.username)
            
            return cell
        case 3:
            let cell = tableView.dequeueReusableCellWithIndexPath(
                withIdentifier: EditBioTableViewCell.reuseIdentifier,
                for: indexPath
            ) as! EditBioTableViewCell
            
            cell.configure(withText: user.bio)
            
            return cell
        default:
            fatalError("This cell should never be created!")
        }
    }
}

// MARK: TXTableViewDelegate
extension EditUserDetailsViewController: TXTableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        tableView.deselectRow(
            at: indexPath,
            animated: true
        )
    }
}
