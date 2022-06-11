//
//  ProfileViewController.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 16/03/22.
//

import UIKit

class SelfViewController: TXFloatingActionViewController {
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        tableView.reloadData()
    }
    
    private func addSubviews() {
        containerView.addSubview(tableView)
    }
    
    private func configureNavigationBar() {
        navigationItem.backButtonTitle = ""
        navigationItem.rightBarButtonItem = TXBarButtonItem(
            image: UIImage(
                systemName: "line.3.horizontal"
            ),
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
            title: "Log Out",
            style: .destructive
        ) {
            [weak self] action in
            guard let strongSelf = self else {
                return
            }
            
            Task {
                strongSelf.showActivityIndicator()
                
                let result = await CurrentUserDataStore.shared.logOut()
                
                strongSelf.hideActivityIndicator()
                
                result.mapOnlyOnFailure { failure in
                    strongSelf.showUnknownFailureSnackBar()
                }
            }
        }
        
        let cancelAction = UIAlertAction(
            title: "Cancel",
            style: .cancel
        ) { action in
            alert.dismiss(animated: true)
        }
        
        alert.addAction(bookmarksAction)
        alert.addAction(logOutAction)
        alert.addAction(cancelAction)
        
        present(
            alert,
            animated: true
        )
    }
    
    override func onFloatingActionPressed() {
        navigationController?.openComposeViewController()
    }
    
}

// MARK: TXEventListener
extension SelfViewController {
    private func configureEventListener() {
        TXEventBroker.shared.listen {
            [weak self] event in
            guard let strongSelf = self else {
                return
            }
            
            if let event = event as? HomeTabSwitchEvent {
                strongSelf.onTabSwitched(to: event.tab)
            }
            
            if let event = event as? TweetCreatedEvent {
                strongSelf.onTweetCreated(
                    tweet: event.tweet
                )
            }
            
            if let event = event as? TweetDeletedEvent {
                strongSelf.onTweetDeleted(
                    withId: event.id
                )
            }
        }
    }
    
    private func onTabSwitched(
        to tab: HomeViewController.TabItem
    ) {
        if tab == .user {
            navigationController?.popToRootViewController(animated: true)
        }
    }
    
    private func onTweetCreated(
        tweet: Tweet
    ) {
        state.mapOnlyOnSuccess { previousPaginatedTweets in
            let updatedPaginatedTweets = Paginated<Tweet>(
                page: [tweet] + previousPaginatedTweets.page,
                nextToken: previousPaginatedTweets.nextToken
            )
            
            state = .success(updatedPaginatedTweets)
            
            DispatchQueue.main.asyncAfter (
                deadline: .now() + 0.1
            ) {
                [weak self] in
                guard let strongSelf = self else {
                    return
                }
                
                if strongSelf.tableView.window != nil {
                    strongSelf.tableView.insertRows(
                        at: [
                            IndexPath(
                                row: 0,
                                section: SelfTableViewSection.tweets.rawValue
                            )
                        ],
                        with: .automatic
                    )
                    strongSelf.tableView.reloadSections(
                        IndexSet(
                            integer: SelfTableViewSection.user.rawValue
                        ),
                        with: .none
                    )
                }
            }
        }
    }
    
    private func onTweetDeleted(
        withId id: String
    ) {
        state.mapOnlyOnSuccess { previousPaginatedTweets in
            let mayBeIndex = previousPaginatedTweets.page.firstIndex { tweet in
                tweet.id == id
            }

            if let index = mayBeIndex {
                let updatedPaginatedTweets = Paginated<Tweet>(
                    page: previousPaginatedTweets.page.filter({ tweet in
                        tweet.id != id
                    }),
                    nextToken: previousPaginatedTweets.nextToken
                )
                
                state = .success(updatedPaginatedTweets)
                
                DispatchQueue.main.asyncAfter (
                    deadline: .now() + 0.1
                ) {
                    [weak self] in
                    guard let strongSelf = self else {
                        return
                    }
                    
                    if strongSelf.tableView.window != nil {
                        strongSelf.tableView.deleteRows(
                            at: [
                                IndexPath(
                                    row: index,
                                    section: SelfTableViewSection.tweets.rawValue
                                )
                            ],
                            with: .automatic
                        )
                        strongSelf.tableView.reloadSections(
                            IndexSet(
                                integer: SelfTableViewSection.user.rawValue
                            ),
                            with: .none
                        )
                    }
                }
            }
        }
    }
}

// MARK: TXTableViewDataSource
extension SelfViewController: TXTableViewDataSource {
    private func populateTableView() {
        Task {
            tableView.beginPaginating()
            
            let tweetsResult = await TweetsDataStore.shared.tweets(
                ofUserWithId: CurrentUserDataStore.shared.user!.id
            )
            
            tableView.endPaginating()
            
            tweetsResult.map { paginatedTweets in
                state = .success(paginatedTweets)
                tableView.reloadSections(
                    IndexSet(
                        integer: SelfTableViewSection.tweets.rawValue
                    ),
                    with: .automatic
                )
                tableView.appendSpacerOnFooter()
            } onFailure: { cause in
                state = .failure(cause)
            }
        }
    }
    
    private func refreshTableView() {
        Task {
            tableView.beginRefreshing()
            
            await refreshUserSection()
            await refreshTweetsSection()
            
            tableView.endRefreshing()
        }
    }
    
    private func extendTableView() {
        state.mapOnlyOnSuccess { previousPaginatedTweets in
            if let nextToken = previousPaginatedTweets.nextToken {
                Task {
                    tableView.beginPaginating()
                    
                    let tweetsResult = await TweetsDataStore.shared.tweets(
                        ofUserWithId: CurrentUserDataStore.shared.user!.id,
                        after: nextToken
                    )
                    
                    tableView.endPaginating()
                    
                    tweetsResult.map { latestPaginatedTweets in
                        let updatedPaginatedTweets = Paginated<Tweet>(
                            page: previousPaginatedTweets.page + latestPaginatedTweets.page,
                            nextToken: latestPaginatedTweets.nextToken
                        )
                        
                        state = .success(updatedPaginatedTweets)
                        
                        tableView.reloadData()
                        
                        tableView.appendSepartorToLastMostVisibleCell()
                    } onFailure: { cause in
                        showUnknownFailureSnackBar()
                    }
                }
            }
        }
    }
    
    private func refreshUserSection() async {
        let userRefreshResult = await CurrentUserDataStore.shared.refreshUser()
        
        userRefreshResult.mapOnSuccess {
            DispatchQueue.main.async {
                [weak self] in
                guard let strongSelf = self else {
                    return
                }
                
                strongSelf.tableView.reloadSections(
                    IndexSet(
                        integer: SelfTableViewSection.user.rawValue
                    ),
                    with: .none
                )
            }
        } orElse: {
            showUnknownFailureSnackBar()
        }
    }
    
    private func refreshTweetsSection() async {
        let tweetsResult = await TweetsDataStore.shared.tweets(
            ofUserWithId: CurrentUserDataStore.shared.user!.id
        )
        
        tweetsResult.mapOnSuccess {
            paginatedTweets in
            
            DispatchQueue.main.async {
                [weak self] in
                guard let strongSelf = self else {
                    return
                }
                
                strongSelf.state = .success(paginatedTweets)
                strongSelf.tableView.reloadSections(
                    IndexSet(
                        integer: SelfTableViewSection.tweets.rawValue
                    ),
                    with: .none
                )
                strongSelf.tableView.appendSpacerOnFooter()
            }
        } orElse: {
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
                for: indexPath
            ) as! CurrentUserTableViewCell
            
            cell.interactionsHandler = self
            cell.configure(withUser: CurrentUserDataStore.shared.user!)
            
            return cell
        case SelfTableViewSection.tweets.rawValue:
            return state.mapOnSuccess { paginatedTweets in
                let cell = tableView.dequeueReusableCell(
                    withIdentifier: PartialTweetTableViewCell.reuseIdentifier,
                    for: indexPath
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
            state.mapOnlyOnSuccess { paginatedTweets in
                let tweet = paginatedTweets.page[indexPath.row]
                
                let tweetViewController = TweetViewController()
                tweetViewController.populate(withTweet: tweet)
                
                navigationController?.pushViewController(
                    tweetViewController,
                    animated: true
                )
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
            navigationItem.title = CurrentUserDataStore.shared.user!.name
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
        let editUserDetailsViewController = EditSelfViewController()
        
        editUserDetailsViewController.populate(
            withUser: CurrentUserDataStore.shared.user!
        )
        
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
        if CurrentUserDataStore.shared.user!.socialDetails.followeesCount > 0 {
            let followingsViewController = FolloweesViewController()
            
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
extension SelfViewController: PartialTweetTableViewCellInteractionsHandler {
    func partialTweetCellDidPressLike(_ cell: PartialTweetTableViewCell) {
        print(#function)
    }
    
    func partialTweetCellDidPressComment(_ cell: PartialTweetTableViewCell) {
        state.mapOnlyOnSuccess { paginatedTweets in
            guard let tweet = paginatedTweets.page.first(where: { $0.id == cell.tweet.id }) else {
                return
            }
            
            navigationController?.openTweetViewController(
                withTweet: tweet,
                andOptions: .init(
                    autoFocus: true
                )
            )
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
    
    func partialTweetCellDidPressDeleteOption(_ cell: PartialTweetTableViewCell) {
        state.mapOnlyOnSuccess { paginatedTweets in
            guard let tweet = paginatedTweets.page.first(where: { $0.id == cell.tweet.id }) else {
                return
            }
            
            Task {
                cell.prepareForDelete()
                
                let tweetDeletionResult = await TweetsDataStore.shared.deleteTweet(
                    withId: tweet.id
                )
                
                tweetDeletionResult.mapOnlyOnFailure { failure in
                    cell.revertAllPreparationsMadeForDelete()
                    showUnknownFailureSnackBar()
                }
            }
            return
        }
    }
    
    func partialTweetCellDidPressOptions(_ cell: PartialTweetTableViewCell) {
        state.mapOnlyOnSuccess { paginatedTweets in
            guard let tweet = paginatedTweets.page.first(where: { $0.id == cell.tweet.id }) else {
                return
            }
            
            let alert = TweetOptionsAlertController.regular()
            
            alert.interactionsHandler = self
            alert.configure(
                withTweet: tweet
            )
            
            present(
                alert,
                animated: true
            )
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
    
    func tweetOptionsAlertControllerDidPressDelete(_ controller: TweetOptionsAlertController) {
        print(#function)
    }
}
