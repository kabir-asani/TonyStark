//
//  ProfileViewController.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 16/03/22.
//

import UIKit

enum ProfileViewControllerSection: Int, CaseIterable {
    case profile = 0
    case tweets = 1
}

class ProfileViewController: TXTableViewController {
    private var userState: Result<User, CurrentUserProviderFailure> = .success(User.empty())
    private var tweetsState: Result<Paginated<Tweet>, TweetsProviderFailure> = .success(Paginated<Tweet>.empty())
    
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
            CurrentUserTableViewCell.self,
            forCellReuseIdentifier: CurrentUserTableViewCell.reuseIdentifier
        )
        
        tableView.register(
            TweetTableViewCell.self,
            forCellReuseIdentifier: TweetTableViewCell.reuseIdentifier
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
            
            self?.userState = result
            self?.tableView.reloadSections(
                [ProfileViewControllerSection.profile.rawValue],
                with: .automatic
            )
        }
        
        Task {
            [weak self] in
            let result = await TweetsProvider.shared.tweets(of: "mzaink")
            
            self?.tweetsState = result
            self?.tableView.reloadSections(
                [ProfileViewControllerSection.tweets.rawValue],
                with: .automatic
            )
        }
    }
    
    override func numberOfSections(
        in tableView: UITableView
    ) -> Int {
        return ProfileViewControllerSection.allCases.count
    }
    
    override func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        switch section {
        case ProfileViewControllerSection.profile.rawValue:
            return 1
        case ProfileViewControllerSection.tweets.rawValue:
            switch tweetsState {
            case .success(let paginated):
                return paginated.page.count
            case .failure(_):
                return 0
            }
        default:
            fatalError()
        }
        
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
        switch indexPath.section {
        case ProfileViewControllerSection.profile.rawValue:
            switch userState {
            case .success(let user):
                let cell = tableView.dequeueReusableCell(
                    withIdentifier: CurrentUserTableViewCell.reuseIdentifier,
                    for: indexPath
                ) as! CurrentUserTableViewCell
                
                cell.identifier = user.id
                cell.configure(
                    with: user
                )
                cell.delegate = self
                
                return cell
            case .failure(_):
                return UITableViewCell()
            }
        case ProfileViewControllerSection.tweets.rawValue:
            switch tweetsState {
            case .success(let paginated):
                let cell = tableView.dequeueReusableCell(
                    withIdentifier: TweetTableViewCell.reuseIdentifier,
                    for: indexPath
                ) as! TweetTableViewCell
                
                cell.identifier = paginated.page[indexPath.row].id
                cell.populate(
                    with: paginated.page[indexPath.row]
                )
                
                return cell
            case .failure(_):
                return UITableViewCell()
            }
        default:
            fatalError()
        }
    }
}

// MARK: UIScrollViewDelegate
extension ProfileViewController {
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentYOffset = scrollView.contentOffset.y
        
        if currentYOffset < 140 {
            navigationItem.title = nil
        }
        
        if currentYOffset > 140 && navigationItem.title == nil {
            switch userState {
            case .success(let user):
                navigationItem.title = user.name
            default:
                break
            }
        }
    }
}

// MARK: CurrentUserDetailsTableViewCellDelegate
extension ProfileViewController: CurrentUserTableViewCellDelegate {
    func didPressEdit(_ cell: CurrentUserTableViewCell) {
        print(#function)
    }
    
    func didPressFollowers(_ cell: CurrentUserTableViewCell) {
        print(#function)
    }
    
    func didPressFollowings(_ cell: CurrentUserTableViewCell) {
        print(#function)
    }
}
