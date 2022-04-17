//
//  ProfileViewController.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 16/03/22.
//

import UIKit

class ProfileViewController: TXTableViewController {
    private var state: Result<User, CurrentUserProviderFailure> = .success(User.empty())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar()
        configureTableView()
        
        populate()
    }
    
    private func configureNavigationBar() {
        navigationItem.rightBarButtonItem = TXBarButtonItem(
            image: UIImage(systemName: "line.3.horizontal"),
            style: .plain,
            target: self,
            action: #selector(onActionPressed(_:))
        )
        
    }
    
    private func configureTableView() {
        tableView.register(
            ProfileTableViewCell.self,
            forCellReuseIdentifier: ProfileTableViewCell.reuseIdentifier
        )
    }
    
    @objc private func onActionPressed(
        _ sender: UIBarButtonItem
    ) {
        print(#function)
    }
}

// MARK: UITableViewDataSource
extension ProfileViewController {
    private func populate() {
        Task {
            [weak self] in
            let result = await UserProvider.current.user()
            
            self?.state = result
            self?.tableView.reloadSections(
                [0],
                with: .automatic
            )
        }
    }
    
    override func numberOfSections(
        in tableView: UITableView
    ) -> Int {
        return 1
    }
    
    override func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return 1
    }
    
    override func tableView(
        _ tableView: UITableView,
        estimatedHeightForRowAt indexPath: IndexPath
    ) -> CGFloat {
        return UITableView.automaticDimension
    }
}

// MARK: UITableViewDelegate
extension ProfileViewController {
    override func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        switch state {
        case .success(let user):
            let cell = tableView.dequeueReusableCell(
                withIdentifier: ProfileTableViewCell.reuseIdentifier,
                for: indexPath
            ) as! ProfileTableViewCell
            
            cell.populate(with: user)
            
            return cell
        case .failure(_):
            return UITableViewCell()
        }
    }
}
