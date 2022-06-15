//
//  OtherUserViewController.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 23/04/22.
//

import UIKit

class OtherUserViewController: TXViewController {
    enum OtherUserTableViewSection: Int, CaseIterable {
        case user
        case tweets
    }
    
    // Declare
    private(set) var user: User = .default
    
    private var state: State<Paginated<Tweet>, TweetsFailure> = .processing
    
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
        configureRefreshControl()
        
        populateTableView()
    }
    
    private func addSubviews() {
        view.addSubview(tableView)
    }
    
    private func configureNavigationBar() {
        navigationItem.backButtonTitle = ""
        navigationItem.largeTitleDisplayMode = .never
    }
    
    private func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.appendSpacerOnHeader()
        
        tableView.register(
            OtherUserTableViewCell.self,
            forCellReuseIdentifier: OtherUserTableViewCell.reuseIdentifier
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
    func populate(withUser user: User) {
        self.user = user
    }
}

// MARK: EventListener
extension OtherUserViewController {
    private func configureEventListener() {
        TXEventBroker.shared.listen {
            [weak self] event in
            guard let strongSelf = self else {
                return
            }
            
            if let event = event as? LikeCreatedEvent {
                strongSelf.onTweetLiked(
                    withId: event.tweetId
                )
            }
            
            if let event = event as? LikeDeletedEvent {
                strongSelf.onTweetUnliked(
                    withId: event.tweetId
                )
            }
        }
    }
    
    private func onTweetLiked(withId id: String) {
        state.mapOnlyOnSuccess { previousPaginatedTweets in
            let updatedPaginatedTweets = Paginated<Tweet>(
                page: previousPaginatedTweets.page.map { tweet in
                    if tweet.id == id && !tweet.viewables.liked {
                        let interactionDetails = tweet.interactionDetails
                        let updatedInteractionDetails = interactionDetails.copyWith(
                            likesCount: interactionDetails.likesCount + 1
                        )
                        
                        let viewables = tweet.viewables
                        let updatedViewables = viewables.copyWith(
                            liked: true
                        )
                        
                        return tweet.copyWith(
                            interactionDetails: updatedInteractionDetails,
                            viewables: updatedViewables
                        )
                    } else {
                        return tweet
                    }
                },
                nextToken: previousPaginatedTweets.nextToken
            )
            
            state = .success(updatedPaginatedTweets)
            
            DispatchQueue.main.asyncAfter (
                deadline: .now() + 0.1
            ) {
                [weak self] in
                guard let strongSelf = self, strongSelf.tableView.window != nil else {
                    return
                }
                
                strongSelf.tableView.reloadData()
            }
        }
    }
    
    private func onTweetUnliked(withId id: String) {
        state.mapOnlyOnSuccess { previousPaginatedTweets in
            let updatedPaginatedTweets = Paginated<Tweet>(
                page: previousPaginatedTweets.page.map { tweet in
                    if tweet.id == id && tweet.viewables.liked {
                        let interactionDetails = tweet.interactionDetails
                        let updatedInteractionDetails = interactionDetails.copyWith(
                            likesCount: interactionDetails.likesCount - 1
                        )
                        
                        let viewables = tweet.viewables
                        let updatedViewables = viewables.copyWith(
                            liked: false
                        )
                        
                        return tweet.copyWith(
                            interactionDetails: updatedInteractionDetails,
                            viewables: updatedViewables
                        )

                    } else {
                        return tweet
                    }
                },
                nextToken: previousPaginatedTweets.nextToken
            )
            
            state = .success(updatedPaginatedTweets)
            
            DispatchQueue.main.asyncAfter (
                deadline: .now() + 0.1
            ) {
                [weak self] in
                guard let strongSelf = self, strongSelf.tableView.window != nil else {
                    return
                }
                
                strongSelf.tableView.reloadData()
            }
        }
    }
}

// MARK: TXScrollViewDelegate
extension OtherUserViewController: TXScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentYOffset = scrollView.contentOffset.y
        
        if currentYOffset < 120 {
            navigationItem.title = nil
        }
        
        if currentYOffset > 120 && navigationItem.title == nil {
            navigationItem.title = user.name
        }
    }
}

// MARK: TXTableViewDataSource
extension OtherUserViewController: TXTableViewDataSource {
    private func populateTableView() {
        Task {
            tableView.beginPaginating()
            
            let tweetsResult = await TweetsDataStore.shared.tweets(
                ofUserWithId: user.id
            )
            
            tableView.endPaginating()
            
            tweetsResult.map { paginatedTweets in
                state = .success(paginatedTweets)
            } onFailure: { cause in
                state = .failure(cause)
            }
            
            tableView.reloadData()
        }
    }
    
    private func refreshTableView() {
        Task {
            tableView.beginRefreshing()
            
            let tweetsResult = await TweetsDataStore.shared.tweets(
                ofUserWithId: user.id
            )
            
            tableView.endRefreshing()
            
            tweetsResult.map { paginatedTweets in
                state = .success(paginatedTweets)
            } onFailure: { cause in
                state = .failure(cause)
            }
            
            tableView.reloadData()
        }
    }
    
    private func extendTableView() {
        state.mapOnlyOnSuccess { previousPaginatedTweets in
            guard let nextToken = previousPaginatedTweets.nextToken else {
               return
            }
            
            Task {
                tableView.beginPaginating()
                
                let tweetsResult = await TweetsDataStore.shared.tweets(
                    ofUserWithId: user.id,
                    after: nextToken
                )
                
                tableView.endPaginating()
                
                tweetsResult.mapOnlyOnSuccess { latestPaginatedTweets in
                    let updatedPaginatedTweets = Paginated<Tweet>(
                        page: previousPaginatedTweets.page + latestPaginatedTweets.page,
                        nextToken: latestPaginatedTweets.nextToken
                    )
                    
                    tableView.appendSepartorToLastMostVisibleCell()
                    
                    state = .success(updatedPaginatedTweets)
                    tableView.reloadData()
                }
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        OtherUserTableViewSection.allCases.count
    }
    
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        switch section {
        case OtherUserTableViewSection.user.rawValue:
            return 1
        case OtherUserTableViewSection.tweets.rawValue:
            return state.mapOnlyOnSuccess { paginatedTweets in
                paginatedTweets.page.count
            } ?? 0
        default:
            fatalError("Only two sections can exists. Something has gone wrong.")
        }
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        switch indexPath.section {
        case OtherUserTableViewSection.user.rawValue:
            let cell = tableView.dequeueReusableCell(
                withIdentifier: OtherUserTableViewCell.reuseIdentifier,
                for: indexPath
            ) as! OtherUserTableViewCell
            
            cell.interactionsHandler = self
            cell.configure(withUser: user)
            
            return cell
        case OtherUserTableViewSection.tweets.rawValue:
            return state.mapOnSuccess { paginatedTweets in
                let cell = tableView.dequeueReusableCell(
                    withIdentifier: PartialTweetTableViewCell.reuseIdentifier,
                    for: indexPath
                ) as! PartialTweetTableViewCell
                
                let tweet = paginatedTweets.page[indexPath.row]
                
                cell.interactionsHandler = self
                cell.configure(withTweet: tweet)
                
                return cell
            } orElse: {
                TXTableViewCell()
            }
        default:
            fatalError()
        }
    }
}

// MARK: TXTableViewDelegate
extension OtherUserViewController: TXTableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        willDisplay cell: UITableViewCell,
        forRowAt indexPath: IndexPath
    ) {
        switch indexPath.section {
        case OtherUserTableViewSection.user.rawValue:
            tableView.appendSeparatorOnCell(
                cell,
                withInset: .leading(0)
            )
        case OtherUserTableViewSection.tweets.rawValue:
            if indexPath.row == tableView.numberOfRows(inSection: OtherUserTableViewSection.tweets.rawValue) - 1 {
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
        
        if indexPath.section == OtherUserTableViewSection.tweets.rawValue {
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

// MARK: TXRefreshControlDelegate
extension OtherUserViewController: TXRefreshControlDelegate {
    func refreshControlDidChange(_ control: TXRefreshControl) {
        if control.isRefreshing {
            refreshTableView()
        }
    }
}

// MARK: OtherUserTableViewCellInteractionsHandler
extension OtherUserViewController: OtherUserTableViewCellInteractionsHandler {
    func otherUserCellDidPressFollow(_ cell: OtherUserTableViewCell) {
        print(#function)
    }
    
    func otherUserCellDidPressFollowers(_ cell: OtherUserTableViewCell) {
        if user.socialDetails.followersCount > 0 {
            let followersViewController = FollowersViewController()
            followersViewController.populate(
                withUser: user
            )
            
            navigationController?.pushViewController(
                followersViewController, animated: true
            )
        }
    }
    
    func otherUserCellDidPressFollowings(_ cell: OtherUserTableViewCell) {
        if user.socialDetails.followeesCount > 0 {
            let followingsViewController = FolloweesViewController()
            
            followingsViewController.populate(
                withUser: user
            )
            
            navigationController?.pushViewController(
                followingsViewController, animated: true
            )
        }
    }
}

// MARK: PartialTweetTableViewCellInteractionsHandler
extension OtherUserViewController: PartialTweetTableViewCellInteractionsHandler {
    func partialTweetCellDidPressLike(_ cell: PartialTweetTableViewCell) {
        state.mapOnlyOnSuccess { paginatedFeed in
            if cell.tweet.viewables.liked {
                onTweetUnliked(
                    withId: cell.tweet.id
                )
            } else {
                onTweetLiked(
                    withId: cell.tweet.id
                )
            }
            
            Task {
                if cell.tweet.viewables.liked {
                    let likeCreationResult = await LikesDataStore.shared.deleteLike(
                        onTweetWithId: cell.tweet.id
                    )
                    
                    likeCreationResult.mapOnlyOnFailure { failure in
                        showUnknownFailureSnackBar()
                        
                        onTweetLiked(
                            withId: cell.tweet.id
                        )
                    }
                } else {
                    let likeDeletionResult = await LikesDataStore.shared.createLike(
                        onTweetWithId: cell.tweet.id
                    )
                    
                    likeDeletionResult.mapOnlyOnFailure { failure in
                        showUnknownFailureSnackBar()
                        
                        onTweetUnliked(
                            withId: cell.tweet.id
                        )
                    }
                }
            }
        }
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
        navigationController?.openUserViewController(withUser: user)
    }
    
    func partialTweetCellDidPressBookmarksOption(_ cell: PartialTweetTableViewCell) {
        print(#function)
    }
    
    func partialTweetCellDidPressFollowOption(_ cell: PartialTweetTableViewCell) {
        print(#function)
    }
    
    func partialTweetCellDidPressDeleteOption(_ cell: PartialTweetTableViewCell) {
        print(#function)
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
extension OtherUserViewController: TweetOptionsAlertControllerInteractionsHandler {
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
