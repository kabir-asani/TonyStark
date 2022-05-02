//
//  EditProfileViewController.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 20/04/22.
//

import UIKit

class EditUserDetailsViewController: TXViewController {
    enum Editables: Int, CaseIterable {
        case profilePicture
        case name
        case username
        case bio
    }
    
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
            ProfileImageTableViewCell.self,
            forCellReuseIdentifier: ProfileImageTableViewCell.reuseIdentifier
        )
        tableView.register(
            NameTableViewCell.self,
            forCellReuseIdentifier: NameTableViewCell.reuseIdentifier
        )
        tableView.register(
            UsernameTableViewCell.self,
            forCellReuseIdentifier: UsernameTableViewCell.reuseIdentifier
        )
        tableView.register(
            BioTableViewCell.self,
            forCellReuseIdentifier: BioTableViewCell.reuseIdentifier
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
        return Editables.allCases.count
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        switch indexPath.row {
        case Editables.profilePicture.rawValue:
            let cell = tableView.dequeueReusableCellWithIndexPath(
                withIdentifier: ProfileImageTableViewCell.reuseIdentifier,
                for: indexPath
            ) as! ProfileImageTableViewCell
            
            cell.configure(withImageURL: user.image)
            
            return cell
        case Editables.name.rawValue:
            let cell = tableView.dequeueReusableCellWithIndexPath(
                withIdentifier: NameTableViewCell.reuseIdentifier,
                for: indexPath
            ) as! NameTableViewCell
            
            cell.configure(withText: user.name)
            
            return cell
        case Editables.username.rawValue:
            let cell = tableView.dequeueReusableCellWithIndexPath(
                withIdentifier: UsernameTableViewCell.reuseIdentifier,
                for: indexPath
            ) as! UsernameTableViewCell
            
            cell.configure(withText: user.username)
            
            return cell
        case Editables.bio.rawValue:
            let cell = tableView.dequeueReusableCellWithIndexPath(
                withIdentifier: BioTableViewCell.reuseIdentifier,
                for: indexPath
            ) as! BioTableViewCell
            
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
        
        switch indexPath.row {
        case Editables.username.rawValue:
            let editUsernameViewController = EditUsernameViewController()
            
            navigationController?.pushViewController(
                editUsernameViewController,
                animated: true
            )
        case Editables.bio.rawValue:
            let editBioViewController = EditBioViewController()
            
            editBioViewController.populate(withBio: user.bio)
            
            navigationController?.pushViewController(
                editBioViewController,
                animated: true
            )
        default:
            // Do nothing
            break
        }
    }
}
