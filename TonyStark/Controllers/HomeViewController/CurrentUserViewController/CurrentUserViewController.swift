//
//  ProfileViewController.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 16/03/22.
//

import UIKit

enum CurrentUserViewControllerState {
    case success(data: Paginated<Tweet>)
    case failure(reason: TweetsFailure)
    case processing
}

class CurrentUserViewController: TXViewController {
    // Declare
    enum Section: Int, CaseIterable {
        case profile = 0
        case tweets = 1
    }
    
    private var state: CurrentUserViewControllerState = .processing
    
    private var tableView: TXTableView = {
        let tableView = TXTableView()
        
        tableView.enableAutolayout()
        
        return tableView
    }()
    
    // Configure
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureEventListener()
        
        addSubviews()
        
        configureNavigationBar()
        configureTableView()
        configureRefreshControl()
        
        populateTableView()
    }
    
    private func configureEventListener() {
        TXEventBroker.shared.listen {
            [weak self] event in
            guard let strongSelf = self else {
                return
            }
            
            if let event = event as? HomeTabSwitchEvent {
                if event.tab == .user {
                    strongSelf.navigationController?.popToRootViewController(animated: true)
                }
            }
        }
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
        
        tableView.addBufferOnHeader(withHeight: 0)
        
        tableView.register(
            CurrentUserTableViewCell.self,
            forCellReuseIdentifier: CurrentUserTableViewCell.reuseIdentifier
        )
        tableView.register(
            PartialTweetTableViewCell.self,
            forCellReuseIdentifier: PartialTweetTableViewCell.reuseIdentifier
        )
        tableView.register(
            EmptyTweetsTableViewCell.self,
            forCellReuseIdentifier: EmptyTweetsTableViewCell.reuseIdentifier
        )
        
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
                let result = await CurrentUserDataStore.shared.logOut()
                
                switch result {
                case .success():
                    TXEventBroker.shared.emit(event: AuthenticationEvent())
                case .failure(_):
                    // TODO: Implement failure cases
                    break
                }
                
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
        tableView.beginRefreshing()
        
        Task {
            [weak self] in
            guard let strongSelf = self else {
                return
            }
            
            let result = await TweetsDataStore.shared.tweets(
                ofUserWithId: CurrentUserDataStore.shared.user!.id
            )
            
            strongSelf.tableView.endRefreshing()
            
            switch result {
            case .success(let latestFeed):
                strongSelf.state = .success(data: latestFeed)
                
                strongSelf.tableView.reloadData()
            case .failure(let reason):
                strongSelf.state = .failure(reason: reason)
            }
        }
    }
    
    private func extendTableView() {
        switch state {
        case .success(let previousPaginated):
            if let nextToken = previousPaginated.nextToken {
                tableView.beginPaginating()
                
                Task {
                    [weak self] in
                    guard let strongSelf = self else {
                        return
                    }
                    
                    let result = await TweetsDataStore.shared.tweets(
                        ofUserWithId: CurrentUserDataStore.shared.user!.id,
                        after: nextToken
                    )
                    
                    strongSelf.tableView.endPaginating()
                    
                    switch result {
                    case .success(let latestPaginated):
                        let updatedPaginated = Paginated<Tweet>(
                            page: previousPaginated.page + latestPaginated.page,
                            nextToken: latestPaginated.nextToken
                        )
                        
                        strongSelf.state = .success(data: updatedPaginated)
                        strongSelf.tableView.reloadData()
                    case .failure(let reason):
                        strongSelf.state = .failure(reason: reason)
                    }
                }
            }
        default:
            break
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
            case .success(let latestTweets):
                return latestTweets.page.count
            default:
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
            let cell = tableView.dequeueReusableCell(
                withIdentifier: CurrentUserTableViewCell.reuseIdentifier,
                assigning: indexPath
            ) as! CurrentUserTableViewCell
            
            cell.interactionsHandler = self
            cell.configure(withUser: CurrentUserDataStore.shared.user!)
            
            return cell
        case Section.tweets.rawValue:
            switch state {
            case .success(let paginated):
                let cell = tableView.dequeueReusableCell(
                    withIdentifier: PartialTweetTableViewCell.reuseIdentifier,
                    assigning: indexPath
                ) as! PartialTweetTableViewCell
                
                cell.interactionsHandler = self
                cell.configure(withTweet: paginated.page[indexPath.row])
                
                return cell
            default:
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
        switch indexPath.section {
        case Section.profile.rawValue:
            cell.separatorInset = .leading(0)
        case Section.tweets.rawValue:
            if indexPath.row == tableView.numberOfRows(inSection: Section.tweets.rawValue) - 1 {
                extendTableView()
            }
        default:
            break
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
                if paginated.page.isEmpty {
                    // Do nothing
                } else {
                    let tweet = paginated.page[indexPath.row]
                    
                    let tweetViewController = TweetViewController()
                    tweetViewController.populate(withTweet: tweet)
                    
                    navigationController?.pushViewController(
                        tweetViewController,
                        animated: true
                    )
                }
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
        
        if currentYOffset < 120 {
            navigationItem.title = nil
        }
        
        if currentYOffset > 120 && navigationItem.title == nil {
            navigationItem.title = CurrentUserDataStore.shared.user!.name
        }
    }
}

// MARK: TXRefreshControlDelegate
extension CurrentUserViewController: TXRefreshControlDelegate {
    func refreshControlDidChange(_ control: TXRefreshControl) {
        if control.isRefreshing {
            populateTableView()
        }
    }
}

// MARK: CurrentUserDetailsTableViewCellDelegate
extension CurrentUserViewController: CurrentUserTableViewCellInteractionsHandler {
    func currentUserCellDidPressEdit(_ cell: CurrentUserTableViewCell) {
        let editUserDetailsViewController = EditUserDetailsViewController()
        
        editUserDetailsViewController.populate(withUser: CurrentUserDataStore.shared.user!)
        
        let navigationViewController = TXNavigationController(
            rootViewController: editUserDetailsViewController
        )
        
        navigationViewController.modalPresentationStyle = .fullScreen
        
        present(
            navigationViewController,
            animated: true
        )
    }
    
    func currentUserCellDidPressFollowers(_ cell: CurrentUserTableViewCell) {
        if CurrentUserDataStore.shared.user!.socialDetails.followersCount > 0 {
            let followersViewController = FollowersViewController()
            
            followersViewController.populate(
                withUser: CurrentUserDataStore.shared.user!
            )
            
            navigationController?.pushViewController(
                followersViewController, animated: true
            )
        }
    }
    
    func currentUserCellDidPressFollowings(_ cell: CurrentUserTableViewCell) {
        if CurrentUserDataStore.shared.user!.socialDetails.followingsCount > 0 {
            let followingsViewController = FollowingsViewController()
            
            followingsViewController.populate(
                withUser: CurrentUserDataStore.shared.user!
            )
            
            navigationController?.pushViewController(
                followingsViewController, animated: true
            )
        }
    }
}

// MARK: PartialTweetTableViewCellInteractionsHandler
extension CurrentUserViewController: PartialTweetTableViewCellInteractionsHandler {
    func partialTweetCellDidPressLike(_ cell: PartialTweetTableViewCell) {
        print(#function)
    }
    
    func partialTweetCellDidPressComment(_ cell: PartialTweetTableViewCell) {
        switch state {
        case .success(let paginated):
            let tweet = paginated.page[cell.indexPath.row]
            
            navigationController?.openTweetViewController(
                withTweet: tweet,
                andOptions: .init(
                    autoFocus: true
                )
            )
        default:
            break
        }
    }
    
    func partialTweetCellDidPressProfileImage(_ cell: PartialTweetTableViewCell) {
        print(#function)
    }
    
    func partialTweetCellDidPressBookmarksOption(_ cell: PartialTweetTableViewCell) {
        print(#function)
    }
    
    func partialTweetCellDidPressFollowOption(_ cell: PartialTweetTableViewCell) {
        print(#function)
    }
    
    func partialTweetCellDidPressOptions(_ cell: PartialTweetTableViewCell) {
        switch state {
        case .success(let paginated):
            let alert = TweetOptionsAlertController.regular()
            
            alert.interactionsHandler = self
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

// MARK: TweetOptionsAlertViewControllerInteractionsHandler
extension CurrentUserViewController: TweetOptionsAlertControllerInteractionsHandler {
    func tweetOptionsAlertControllerDidPressBookmark(_ controller: TweetOptionsAlertController) {
        print(#function)
    }
    
    func tweetOptionsAlertControllerDidPressFollow(_ controller: TweetOptionsAlertController) {
        print(#function)
    }
}
