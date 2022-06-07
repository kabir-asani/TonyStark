//
//  ProfileViewController.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 16/03/22.
//

import UIKit

class SelfViewController: TXViewController {
    // Declare
    enum SelfTableViewSection: Int, CaseIterable {
        case user
        case tweets
    }
    
    private var state: State<Paginated<Tweet>, TweetsFailure> = .processing
    
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
        
        tableView.appendSpacerOnHeader()
        
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
                
                result.mapOnSuccess {
                    TXEventBroker.shared.emit(
                        event: AuthenticationEvent()
                    )
                } orElse: {
                    TXEventBroker.shared.emit(
                        event: ShowSnackBarEvent(
                            text: "Something Went Wrong!",
                            variant: .failure
                        )
                    )
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
extension SelfViewController: TXTableViewDataSource {
    private func populateTableView() {
        CurrentUserDataStore.shared.state.map { currentUser in
            Task {
                [weak self] in
                guard let strongSelf = self else {
                    return
                }
                
                strongSelf.tableView.beginPaginating()
                
                let tweetsResult = await TweetsDataStore.shared.tweets(
                    ofUserWithId: currentUser.user.id
                )
                
                strongSelf.tableView.endPaginating()
                
                tweetsResult.map { paginatedTweets in
                    strongSelf.state = .success(data: paginatedTweets)
                    
                    strongSelf.tableView.reloadData()
                } onFailure: { cause in
                    strongSelf.state = .failure(cause: cause)
                }
            }
        } onAbsent: {
            showUnknownFailureSnackBar()
        }
    }
    
    private func refreshTableView() {
        CurrentUserDataStore.shared.state.map { currentUser in
            Task {
                [weak self] in
                guard let strongSelf = self else {
                    return
                }
                
                strongSelf.tableView.beginRefreshing()
                
                let tweetsResult = await TweetsDataStore.shared.tweets(
                    ofUserWithId: currentUser.user.id
                )
                
                strongSelf.tableView.endRefreshing()
                
                tweetsResult.map { paginatedTweets in
                    strongSelf.state = .success(data: paginatedTweets)
                    strongSelf.tableView.reloadData()
                } onFailure: { cause in
                    strongSelf.state = .failure(cause: cause)
                }
            }
        } onAbsent: {
            showUnknownFailureSnackBar()
        }
    }
    
    private func extendTableView() {
        CurrentUserDataStore.shared.state.map { currentUser in
            state.mapOnSuccess { previousPaginatedTweets in
                if let nextToken = previousPaginatedTweets.nextToken {
                    Task {
                        [weak self] in
                        guard let strongSelf = self else {
                            return
                        }
                        
                        strongSelf.tableView.beginPaginating()
                        
                        let tweetsResult = await TweetsDataStore.shared.tweets(
                            ofUserWithId: currentUser.user.id,
                            after: nextToken
                        )
                        
                        strongSelf.tableView.endPaginating()
                        
                        tweetsResult.map { latestPaginatedTweets in
                            let updatedPaginatedTweets = Paginated<Tweet>(
                                page: previousPaginatedTweets.page + latestPaginatedTweets.page,
                                nextToken: latestPaginatedTweets.nextToken
                            )
                            
                            strongSelf.tableView.appendSepartorToLastMostVisibleCell()
                            
                            strongSelf.state = .success(data: updatedPaginatedTweets)
                            strongSelf.tableView.reloadData()
                        } onFailure: { cause in
                            // TODO: Communicate via SnackBar
                        }
                    }
                }
            } orElse: {
                // Do nothing
            }
        } onAbsent: {
            showUnknownFailureSnackBar()
        }
    }
    
    func numberOfSections(
        in tableView: UITableView
    ) -> Int {
        SelfTableViewSection.allCases.count
    }
    
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        switch section {
        case SelfTableViewSection.user.rawValue:
            return 1
        case SelfTableViewSection.tweets.rawValue:
            return state.mapOnSuccess { paginatedTweets in
                paginatedTweets.page.count
            } orElse: {
                0
            }
        default:
            fatalError()
        }
    }
    
    func tableView(
        _ tableView: UITableView,
        estimatedHeightForRowAt indexPath: IndexPath
    ) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        switch indexPath.section {
        case SelfTableViewSection.user.rawValue:
            let cell = tableView.dequeueReusableCell(
                withIdentifier: CurrentUserTableViewCell.reuseIdentifier,
                assigning: indexPath
            ) as! CurrentUserTableViewCell
            
            cell.interactionsHandler = self
            let user = CurrentUserDataStore.shared.state.map { currentUser in
                currentUser.user
            } onAbsent: {
                User.default()
            }

            cell.configure(withUser: user)
            
            return cell
        case SelfTableViewSection.tweets.rawValue:
            return state.mapOnSuccess { paginatedTweets in
                let cell = tableView.dequeueReusableCell(
                    withIdentifier: PartialTweetTableViewCell.reuseIdentifier,
                    assigning: indexPath
                ) as! PartialTweetTableViewCell
                
                cell.interactionsHandler = self
                cell.configure(withTweet: paginatedTweets.page[indexPath.row])
                
                return cell
            } orElse: {
                UITableViewCell()
            }
        default:
            fatalError()
        }
    }
}

// MARK: TXTableViewDelegate
extension SelfViewController: TXTableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        willDisplay cell: UITableViewCell,
        forRowAt indexPath: IndexPath
    ) {
        switch indexPath.section {
        case SelfTableViewSection.user.rawValue:
            tableView.appendSeparatorOnCell(cell, withInset: .leading(0))
        case SelfTableViewSection.tweets.rawValue:
            if indexPath.row == tableView.numberOfRows(inSection: SelfTableViewSection.tweets.rawValue) - 1 {
                tableView.removeSeparatorOnCell(cell)
                
                extendTableView()
            } else {
                tableView.appendSeparatorOnCell(cell)
            }
        default:
            fatalError()
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
        
        if indexPath.section == SelfTableViewSection.tweets.rawValue {
            state.mapOnSuccess { paginatedTweets in
                let tweet = paginatedTweets.page[indexPath.row]
                
                let tweetViewController = TweetViewController()
                tweetViewController.populate(withTweet: tweet)
                
                navigationController?.pushViewController(
                    tweetViewController,
                    animated: true
                )
            } orElse: {
                // Do nothing
            }
        }
    }
}

// MARK: TXScrollViewDelegate
extension SelfViewController: TXScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentYOffset = scrollView.contentOffset.y
        
        if currentYOffset < 120 {
            navigationItem.title = nil
        }
        
        if currentYOffset > 120 && navigationItem.title == nil {
            navigationItem.title = CurrentUserDataStore.shared.state.map { currentUser in
                currentUser.user.name
            } onAbsent: {
                ""
            }
        }
    }
}

// MARK: TXRefreshControlDelegate
extension SelfViewController: TXRefreshControlDelegate {
    func refreshControlDidChange(_ control: TXRefreshControl) {
        if control.isRefreshing {
            refreshTableView()
        }
    }
}

// MARK: CurrentUserDetailsTableViewCellDelegate
extension SelfViewController: CurrentUserTableViewCellInteractionsHandler {
    func currentUserCellDidPressEdit(_ cell: CurrentUserTableViewCell) {
        CurrentUserDataStore.shared.state.map { currentUser in
            let editUserDetailsViewController = EditSelfViewController()
            
            editUserDetailsViewController.populate(withUser: currentUser.user)
            
            let navigationViewController = TXNavigationController(
                rootViewController: editUserDetailsViewController
            )
            
            navigationViewController.modalPresentationStyle = .fullScreen
            
            present(
                navigationViewController,
                animated: true
            )
        } onAbsent: {
            showUnknownFailureSnackBar()
            return
        }

    }
    
    func currentUserCellDidPressFollowers(_ cell: CurrentUserTableViewCell) {
        CurrentUserDataStore.shared.state.map { currentUser in
            if currentUser.user.socialDetails.followersCount > 0 {
                let followersViewController = FollowersViewController()
                
                followersViewController.populate(
                    withUser: currentUser.user
                )
                
                navigationController?.pushViewController(
                    followersViewController, animated: true
                )
            }
        } onAbsent: {
            showUnknownFailureSnackBar()
            return
        }
    }
    
    func currentUserCellDidPressFollowings(_ cell: CurrentUserTableViewCell) {
        CurrentUserDataStore.shared.state.map { currentUser in
            if currentUser.user.socialDetails.followeesCount > 0 {
                let followingsViewController = FolloweesViewController()
                
                followingsViewController.populate(
                    withUser: currentUser.user
                )
                
                navigationController?.pushViewController(
                    followingsViewController, animated: true
                )
            }
        } onAbsent: {
            showUnknownFailureSnackBar()
            return
        }
        
    }
}

// MARK: PartialTweetTableViewCellInteractionsHandler
extension SelfViewController: PartialTweetTableViewCellInteractionsHandler {
    func partialTweetCellDidPressLike(_ cell: PartialTweetTableViewCell) {
        print(#function)
    }
    
    func partialTweetCellDidPressComment(_ cell: PartialTweetTableViewCell) {
        state.mapOnSuccess { paginatedTweets in
            let tweet = paginatedTweets.page[cell.indexPath.row]
            
            navigationController?.openTweetViewController(
                withTweet: tweet,
                andOptions: .init(
                    autoFocus: true
                )
            )
        } orElse: {
            // Do nothing
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
        state.mapOnSuccess { paginatedTweets in
            let alert = TweetOptionsAlertController.regular()
            
            alert.interactionsHandler = self
            alert.configure(withTweet: paginatedTweets.page[cell.indexPath.row])
            
            present(
                alert,
                animated: true
            )
        } orElse: {
            // Do nothing
        }
    }
}

// MARK: TweetOptionsAlertViewControllerInteractionsHandler
extension SelfViewController: TweetOptionsAlertControllerInteractionsHandler {
    func tweetOptionsAlertControllerDidPressBookmark(_ controller: TweetOptionsAlertController) {
        print(#function)
    }
    
    func tweetOptionsAlertControllerDidPressFollow(_ controller: TweetOptionsAlertController) {
        print(#function)
    }
}
