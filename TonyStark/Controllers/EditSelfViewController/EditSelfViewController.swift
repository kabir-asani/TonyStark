//
//  EditProfileViewController.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 20/04/22.
//

import UIKit

class EditSelfViewController: TXViewController {
    enum EditSelfTableViewSection: Int, CaseIterable {
        case editables
    }
    
    enum Details: Int, CaseIterable {
        // TODO: Add profile picture edition
        //        case profilePicture
        case name
        case username
        case bio
    }
    
    // Declare
    private(set) var user: User!
    
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
    
    private func addSubviews() {
        view.addSubview(tableView)
    }
    
    private func configureNavigationBar() {
        navigationItem.title = "Edit Profile"
        
        configureLeftBarButtonWithCancelButton()
        configureRightBarButtonWithTweetBarButton()
    }
    
    private func configureLeftBarButtonWithCancelButton() {
        let cancelBarButtonItem = TXBarButtonItem(
            barButtonSystemItem: .cancel,
            target: self,
            action: #selector(onCancelPressed(_:))
        )
        
        navigationItem.leftBarButtonItem = cancelBarButtonItem
    }
    
    private func configureRightBarButtonWithTweetBarButton() {
        let tweetBarButtonItem = TXBarButtonItem(
            title: "Done",
            style: .done,
            target: self,
            action: #selector(onDonePressed(_:))
        )
        
        navigationItem.rightBarButtonItem = tweetBarButtonItem
    }
    
    private func configureRightBarButtonWithActivityIndicator() {
        let activityIndicator = TXActivityIndicatorView()
        
        activityIndicator.startAnimating()
        
        let activityIndicatorBarButtonItem = TXBarButtonItem(
            customView: activityIndicator
        )
        
        navigationItem.rightBarButtonItem = activityIndicatorBarButtonItem
    }
    
    private func showActivityIndicatorOnNavigationBar() {
        configureRightBarButtonWithActivityIndicator()
        view.isUserInteractionEnabled = false
    }
    
    private func hideActivityIndicatorOnNavigationBar() {
        configureRightBarButtonWithTweetBarButton()
        view.isUserInteractionEnabled = true
    }
    
    private func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.tableHeaderView = .init(frame: .zero)
        tableView.keyboardDismissMode = .onDrag
        
        // TODO: Add profile picture edition
        //        tableView.register(
        //            ProfileImageTableViewCell.self,
        //            forCellReuseIdentifier: ProfileImageTableViewCell.reuseIdentifier
        //        )
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
        dismiss(
            animated: true
        )
    }
    
    @objc private func onDonePressed(_ sender: TXBarButtonItem) {
        Task {
            showActivityIndicatorOnNavigationBar()
            
            let currentUserUpdationResult = await CurrentUserDataStore.shared.updateUser(
                to: user
            )
            
            hideActivityIndicatorOnNavigationBar()
            
            currentUserUpdationResult.mapOnSuccess {
                dismiss(
                    animated: true
                )
            } orElse: {
                showUnknownFailureSnackBar()
            }
            
            currentUserUpdationResult.map {
                dismiss(
                    animated: true
                )
            } onFailure: { failure in
                if failure == UpdateUserFailure.usernameUnavailable {
                    showSnackBar(
                        text: "Uh oh! That username is not available!",
                        variant: .warning
                    )
                } else {
                    showUnknownFailureSnackBar()
                }
            }
        }
    }
}

// MARK: TXTableViewDataSource
extension EditSelfViewController: TXTableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        EditSelfTableViewSection.allCases.count
    }
    
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        Details.allCases.count
    }
    
    func tableView(
        _ tableView: UITableView,
        estimatedHeightForRowAt indexPath: IndexPath
    ) -> CGFloat {
        TXTableView.automaticDimension
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        switch indexPath.row {
            // TODO: Add profile picture edition
            //        case Details.profilePicture.rawValue:
            //            let cell = tableView.dequeueReusableCell(
            //                withIdentifier: ProfileImageTableViewCell.reuseIdentifier,
            //                for: indexPath
            //            ) as! ProfileImageTableViewCell
            //
            //            cell.configure(
            //                withImageURL: user.image
            //            )
            //
            //            return cell
        case Details.name.rawValue:
            let cell = tableView.dequeueReusableCell(
                withIdentifier: NameTableViewCell.reuseIdentifier,
                for: indexPath
            ) as! NameTableViewCell
            
            cell.delegate = self
            cell.configure(
                withText: user.name
            )
            
            return cell
        case Details.username.rawValue:
            let cell = tableView.dequeueReusableCell(
                withIdentifier: UsernameTableViewCell.reuseIdentifier,
                for: indexPath
            ) as! UsernameTableViewCell
            
            cell.configure(
                withText: user.username
            )
            
            return cell
        case Details.bio.rawValue:
            let cell = tableView.dequeueReusableCell(
                withIdentifier: BioTableViewCell.reuseIdentifier,
                for: indexPath
            ) as! BioTableViewCell
            
            cell.configure(
                withText: user.description
            )
            
            return cell
        default:
            fatalError("This cell should never be created!")
        }
    }
}

// MARK: TXTableViewDelegate
extension EditSelfViewController: TXTableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        tableView.deselectRow(
            at: indexPath,
            animated: true
        )
        
        switch indexPath.row {
        case Details.username.rawValue:
            let editUsernameViewController = EditUsernameViewController()
            
            editUsernameViewController.interactionsHandler = self
            editUsernameViewController.populate(
                withUsername: user.username
            )
            
            navigationController?.pushViewController(
                editUsernameViewController,
                animated: true
            )
        case Details.bio.rawValue:
            let editBioViewController = EditBioViewController()
            
            editBioViewController.interactionsHandler = self
            editBioViewController.populate(
                withBio: user.description
            )
            
            navigationController?.pushViewController(
                editBioViewController,
                animated: true
            )
        default:
            break
        }
    }
}

// MARK:
extension EditSelfViewController: EditUsernameViewControllerInteractionsHandler {
    func editUsernameViewController(
        _ controller: EditUsernameViewController,
        didUpdateUsername username: String
    ) {
        user = user.copyWith(
            username: username
        )
        
        DispatchQueue.main.asyncAfter(
            deadline: .now() + 0.1
        ) {
            [weak self]  in
            guard let strongSelf = self, strongSelf.tableView.window != nil else {
                return
            }
            
            strongSelf.tableView.reloadData()
        }
    }
}

// MARK:
extension EditSelfViewController: EditBioViewControllerInteractionsHandler {
    func editBioViewController(
        _ controller: EditBioViewController,
        didUpdateBio bio: String
    ) {
        user = user.copyWith(
            description: bio
        )
        
        DispatchQueue.main.asyncAfter(
            deadline: .now() + 0.1
        ) {
            [weak self]  in
            guard let strongSelf = self, strongSelf.tableView.window != nil else {
                return
            }
            
            strongSelf.tableView.reloadData()
        }
    }
}

extension EditSelfViewController: NameTableViewCellDelegate {
    func nameCell(
        _ cell: NameTableViewCell,
        didUpdateName name: String
    ) {
        if name.isEmpty {
            navigationItem.rightBarButtonItem?.isEnabled = false
        } else {
            navigationItem.rightBarButtonItem?.isEnabled = true
            user = user.copyWith(
                name: name
            )
        }
    }
}
