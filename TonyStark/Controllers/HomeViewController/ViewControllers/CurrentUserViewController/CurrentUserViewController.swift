//
//  ProfileViewController.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 16/03/22.
//

import UIKit

class CurrentUserViewController: TXViewController {
    // Declare
    enum Section: Int, CaseIterable {
        case profile = 0
        case tweets = 1
    }
    
    private var state: Result<Paginated<Tweet>, TweetsProvider.TweetsFailure> = .success(.default())
    
    private var tableView: TXTableView = {
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
        
        populateTableView()
    }
    
    private func addSubviews() {
        view.addSubview(tableView)
    }
    
    private func configureNavigationBar() {
        navigationItem.backButtonTitle = ""
        navigationItem.rightBarButtonItem = TXBarButtonItem(
            image: UIImage(systemName: "line.3.horizontal"),
            style: .plain,
            target: self,
            action: #selector(onActionPressed(_:))
        )
    }
    
    private func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.tableHeaderView = TXView(frame: .zero)
        
        tableView.register(
            CurrentUserTableViewCell.self,
            forCellReuseIdentifier: CurrentUserTableViewCell.reuseIdentifier
        )
        
        tableView.register(
            PartialTweetTableViewCell.self,
            forCellReuseIdentifier: PartialTweetTableViewCell.reuseIdentifier
        )
        
        tableView.pin(
            to: view,
            byBeingSafeAreaAware: true
        )
    }
    
    // Populate
    
    // Interact
    @objc private func onActionPressed(
        _ sender: UIBarButtonItem
    ) {
        let alert = UIAlertController(
            title: nil,
            message: nil,
            preferredStyle: .actionSheet
        )
        
        let appInformationAction = UIAlertAction(
            title: "App Information",
            style: .default
        ) { action in
            // TODO:
        }
        
        let developerInformationAction = UIAlertAction(
            title: "Developer Information",
            style: .default
        ) { action in
            // TODO:
        }
        
        let bookmarksAction = UIAlertAction(
            title: "Bookmarks",
            style: .default
        ) { [weak self] action in
            guard let strongSelf = self else {
                return
            }
            
            let bookmarksViewController = BookmarksViewController()
            
            strongSelf.navigationController?.pushViewController(
                bookmarksViewController,
                animated: true
            )
        }
    
        let logOutAction = UIAlertAction(
            title: "Log Out?",
            style: .destructive
        ) { action in
            Task {
                await UserProvider.current.logOut()
                TXEventBroker.shared.emit(event: AuthenticationEvent())
            }
        }
        
        let cancelAction = UIAlertAction(
            title: "Cancel",
            style: .cancel
        ) { action in
            alert.dismiss(animated: true)
        }
        
        alert.addAction(appInformationAction)
        alert.addAction(developerInformationAction)
        alert.addAction(bookmarksAction)
        alert.addAction(logOutAction)
        alert.addAction(cancelAction)
        
        present(
            alert,
            animated: true
        )
    }
}

// MARK: TXTableViewDataSource
extension CurrentUserViewController: TXTableViewDataSource {
    private func populateTableView() {
        Task {
            [weak self] in
            guard let strongSelf = self else {
                return
            }
            
            let result = await TweetsProvider.shared.tweets(of: "mzaink")
            
            strongSelf.state = result
            strongSelf.tableView.reloadSections(
                [Section.tweets.rawValue],
                with: .automatic
            )
        }
    }
    
    func numberOfSections(
        in tableView: UITableView
    ) -> Int {
        return Section.allCases.count
    }
    
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        switch section {
        case Section.profile.rawValue:
            return 1
        case Section.tweets.rawValue:
            switch state {
            case .success(let paginated):
                return paginated.page.count
            case .failure(_):
                return 0
            }
        default:
            fatalError()
        }
        
    }
    
    func tableView(
        _ tableView: UITableView,
        estimatedHeightForRowAt indexPath: IndexPath
    ) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        switch indexPath.section {
        case Section.profile.rawValue:
            let cell = tableView.dequeueReusableCellWithIndexPath(
                withIdentifier: CurrentUserTableViewCell.reuseIdentifier,
                for: indexPath
            ) as! CurrentUserTableViewCell
            
            cell.interactionsHandler = self
            cell.configure(withUser: UserProvider.current.user)
            
            return cell
            
        case Section.tweets.rawValue:
            switch state {
            case .success(let paginated):
                let cell = tableView.dequeueReusableCellWithIndexPath(
                    withIdentifier: PartialTweetTableViewCell.reuseIdentifier,
                    for: indexPath
                ) as! PartialTweetTableViewCell
                
                cell.interactionsHandler = self
                cell.configure(withTweet: paginated.page[indexPath.row])
                
                return cell
            case .failure(_):
                return UITableViewCell()
            }
        default:
            fatalError()
        }
    }
}

// MARK: TXTableViewDelegate
extension CurrentUserViewController: TXTableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        willDisplay cell: UITableViewCell,
        forRowAt indexPath: IndexPath
    ) {
        if indexPath.section == Section.tweets.rawValue {
            switch state {
            case .success(let paginated):
                if indexPath.row  == paginated.page.count - 1 {
                    cell.separatorInset = .leading(.infinity)
                } else {
                    cell.separatorInset = .leading(20)
                }
            default:
                break
            }
        }
    }
    
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        tableView.deselectRow(
            at: indexPath,
            animated: true
        )
        
        if indexPath.section == Section.tweets.rawValue {
            switch state {
            case .success(let paginated):
                let tweet = paginated.page[indexPath.row]
                
                let tweetViewController = TweetViewController()
                tweetViewController.populate(withTweet: tweet)
                
                navigationController?.pushViewController(
                    tweetViewController,
                    animated: true
                )
            default:
                break
            }
        }
    }
}

// MARK: TXScrollViewDelegate
extension CurrentUserViewController: TXScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentYOffset = scrollView.contentOffset.y
        
        if currentYOffset < 40 {
            navigationItem.title = nil
        }
        
        if currentYOffset > 40 && navigationItem.title == nil {
            navigationItem.title = UserProvider.current.user.name
        }
    }
}

// MARK: CurrentUserDetailsTableViewCellDelegate
extension CurrentUserViewController: CurrentUserTableViewCellInteractionsHandler {
    func didPressEdit(_ cell: CurrentUserTableViewCell) {
        let editUserDetailsViewController = EditUserDetailsViewController()
        
        editUserDetailsViewController.populate(withUser: UserProvider.current.user)
        
        let navigationViewController = TXNavigationController(
            rootViewController: editUserDetailsViewController
        )
        
        navigationViewController.modalPresentationStyle = .fullScreen
        
        present(
            navigationViewController,
            animated: true
        )
    }
    
    func didPressFollowers(_ cell: CurrentUserTableViewCell) {
        let followersViewController = FollowersViewController()
        
        followersViewController.populate(
            withUser: UserProvider.current.user
        )
        
        navigationController?.pushViewController(
            followersViewController, animated: true
        )
    }
    
    func didPressFollowings(_ cell: CurrentUserTableViewCell) {
        let followingsViewController = FollowingsViewController()
        
        followingsViewController.populate(
            withUser: UserProvider.current.user
        )
        
        navigationController?.pushViewController(
            followingsViewController, animated: true
        )
    }
}

// MARK: PartialTweetTableViewCellInteractionsHandler
extension CurrentUserViewController: PartialTweetTableViewCellInteractionsHandler {
    func didPressLike(_ cell: PartialTweetTableViewCell) {
        print(#function)
    }
    
    func didPressComment(_ cell: PartialTweetTableViewCell) {
        switch state {
        case .success(let paginated):
            let tweet = paginated.page[cell.indexPath.row]
            
            let tweetViewController = TweetViewController()
            
            tweetViewController.populate(
                withTweet: tweet,
                options: TweetViewControllerOptions(
                    autoFocus: true
                )
            )
            
            navigationController?.pushViewController(
                tweetViewController,
                animated: true
            )
        default:
            break
        }
    }
    
    func didPressProfileImage(_ cell: PartialTweetTableViewCell) {
        print(#function)
    }
    
    func didPressBookmarksOption(_ cell: PartialTweetTableViewCell) {
        print(#function)
    }
    
    func didPressFollowOption(_ cell: PartialTweetTableViewCell) {
        print(#function)
    }
    
    func didPressOption(_ cell: PartialTweetTableViewCell) {
        switch state {
        case .success(let paginated):
            let alert = TweetOptionsAlertViewController.regular()
            
            alert.configure(withTweet: paginated.page[cell.indexPath.row])
            
            present(
                alert,
                animated: true
            )
        default:
            break
        }
    }
}
