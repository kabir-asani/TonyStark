//
//  FeedViewController.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 16/03/22.
//

import UIKit

class FeedViewController: TXFloatingActionViewController {
    // Declare
    enum FeedTableViewSection: Int, CaseIterable {
        case tweets
    }
    
    private var state: State<Paginated<Tweet>, FeedFailure> = .processing
    
    private let tableView: TXTableView = {
        let tableView = TXTableView()
        
        tableView.enableAutolayout()
        
        return tableView
    }()
    
    private let floatingButton: FloatingActionButton = {
        let floatingButton = FloatingActionButton()
        
        floatingButton.enableAutolayout()
        floatingButton.setImage(
            UIImage(systemName: "plus"),
            for: .normal
        )
        
        return floatingButton
    }()
    
    // Configure
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSubviews()
        
        configureEventListener()
        
        configureNavigationBar()
        configureTableView()
        configureRefreshControl()
        
        populateTableView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(
            animated
        )
        
        tableView.reloadData()
    }
    
    private func addSubviews() {
        containerView.addSubview(tableView)
    }
    
    private func configureNavigationBar() {
        let titleImage = TXImageView(image: TXBundledImage.twitterX)
        titleImage.contentMode = .scaleAspectFit
        
        navigationItem.backButtonTitle = ""
        navigationItem.titleView = titleImage
    }
    
    private func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.appendSpacerOnHeader()
        
        tableView.register(
            PartialTweetTableViewCell.self,
            forCellReuseIdentifier: PartialTweetTableViewCell.reuseIdentifier
        )
        tableView.register(
            EmptyFeedTableViewCell.self,
            forCellReuseIdentifier: EmptyFeedTableViewCell.reuseIdentifier
        )
        tableView.register(
            UnknownFailureTableViewCell.self,
            forCellReuseIdentifier: UnknownFailureTableViewCell.reuseIdentifier
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
    override func onFloatingActionPressed() {
        navigationController?.openComposeViewController()
    }
}

// MARK: TXTableViewDataSource
extension FeedViewController: TXTableViewDataSource {
    private func populateTableView() {
        Task {
            tableView.beginPaginating()
            
            let feedResult = await FeedDataStore.shared.feed()
            
            tableView.endPaginating()
            
            feedResult.map { paginatedFeed in
                state = .success(paginatedFeed)
                tableView.appendSpacerOnFooter()
            } onFailure: { failure in
                state = .failure(failure)
                tableView.removeSpacerOnFooter()
            }
            
            tableView.reloadData()
        }
    }
    
    private func refreshTableView() {
        Task {
            tableView.beginRefreshing()
            
            let feedResult = await FeedDataStore.shared.feed()
            
            tableView.endRefreshing()
            
            feedResult.map { paginatedFeed in
                state = .success(paginatedFeed)
                tableView.appendSpacerOnFooter()
            } onFailure: { failure in
                state = .failure(failure)
                tableView.removeSpacerOnFooter()
            }
            
            tableView.reloadData()
        }
    }
    
    private func extendTableView() {
        state.mapOnlyOnSuccess { previousPaginated in
            guard let nextToken = previousPaginated.nextToken else {
                return
            }
            
            Task {
                tableView.beginPaginating()
                
                let feedResult = await FeedDataStore.shared.feed(
                    after: nextToken
                )
                
                tableView.endPaginating()
                
                feedResult.map { latestPaginatedFeed in
                    
                    let updatedPaginatedFeed = Paginated<Tweet>(
                        page: previousPaginated.page + latestPaginatedFeed.page,
                        nextToken: latestPaginatedFeed.nextToken
                    )
                    
                    state = .success(updatedPaginatedFeed)
                    
                    tableView.reloadData()
                    
                    tableView.appendSepartorToLastMostVisibleCell()
                } onFailure: { failure in
                    showUnknownFailureSnackBar()
                }
            }
        }
    }
    
    func numberOfSections(
        in tableView: UITableView
    ) -> Int {
        FeedTableViewSection.allCases.count
    }
    
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        state.map { paginatedFeed in
            if paginatedFeed.page.isEmpty {
                return 1
            } else {
                return paginatedFeed.page.count
            }
        } onFailure: { failure in
            1
        } onProcessing: {
            0
        }
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        state.map { paginatedFeed in
            if paginatedFeed.page.isEmpty {
                let cell = tableView.dequeueReusableCell(
                    withIdentifier: EmptyFeedTableViewCell.reuseIdentifier,
                    for: indexPath
                ) as! EmptyFeedTableViewCell
                
                cell.intractionsHandler = self
                
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(
                    withIdentifier: PartialTweetTableViewCell.reuseIdentifier,
                    for: indexPath
                ) as! PartialTweetTableViewCell
                
                cell.interactionsHandler = self
                cell.configure(
                    withTweet: paginatedFeed.page[indexPath.row]
                )
                
                return cell
            }
        } onFailure: { failure in
            let cell = tableView.dequeueReusableCell(
                withIdentifier: UnknownFailureTableViewCell.reuseIdentifier,
                for: indexPath
            ) as! UnknownFailureTableViewCell
            
            return cell
        } onProcessing: {
            TXTableViewCell()
        }
    }
}

// MARK: TXTableViewDelegate
extension FeedViewController: TXTableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        willDisplay cell: UITableViewCell,
        forRowAt indexPath: IndexPath
    ) {
        state.mapOnlyOnSuccess { paginatedTweets in
            if paginatedTweets.page.isEmpty {
                return
            }
            
            if indexPath.row == paginatedTweets.page.count - 1 {
                extendTableView()
            }
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
        didSelectRowAt indexPath: IndexPath
    ) {
        tableView.deselectRow(
            at: indexPath,
            animated: true
        )
        
        state.mapOnlyOnSuccess { paginatedFeed in
            if paginatedFeed.page.isEmpty {
                return
            }
            
            let tweet = paginatedFeed.page[indexPath.row]
            
            let tweetViewController = TweetViewController()
            
            tweetViewController.populate(
                withTweet: tweet
            )
            
            navigationController?.pushViewController(
                tweetViewController,
                animated: true
            )
        }
    }
}

// MARK: TXRefreshControlDelegate
extension FeedViewController: TXRefreshControlDelegate {
    func refreshControlDidChange(
        _ control: TXRefreshControl
    ) {
        if control.isRefreshing {
            refreshTableView()
        }
    }
}

// MARK: EmptyFeedTableViewCellInteractionsHandler
extension FeedViewController: EmptyFeedTableViewCellInteractionsHandler {
    func emtpyFeedCellDidPressSearch(
        _ cell: EmptyFeedTableViewCell
    ) {
        TXEventBroker.shared.emit(
            event: HomeTabSwitchEvent(
                tab: .explore
            )
        )
    }
}

// MARK: TweetTableViewCellInteractionsHandler
extension FeedViewController: PartialTweetTableViewCellInteractionsHandler {
    func partialTweetCellDidPressLike(
        _ cell: PartialTweetTableViewCell
    ) {
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
    
    func partialTweetCellDidPressComment(
        _ cell: PartialTweetTableViewCell
    ) {
        state.mapOnlyOnSuccess { paginatedFeed in
            guard let tweet = paginatedFeed.page.first(where: { $0.id == cell.tweet.id }) else {
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
    
    func partialTweetCellDidPressProfileImage(
        _ cell: PartialTweetTableViewCell
    ) {
        state.mapOnlyOnSuccess { paginatedFeed in
            guard let tweet = paginatedFeed.page.first(where: { $0.id == cell.tweet.id }) else {
                return
            }
            
            let user = tweet.viewables.author
            
            navigationController?.openUserViewController(withUser: user)
        }
    }
    
    func partialTweetCellDidPressBookmarkOption(
        _ cell: PartialTweetTableViewCell
    ) {
        Task {
            if cell.tweet.viewables.bookmarked {
                let bookmarkDeletionResult = await BookmarksDataStore.shared.deleteBookmark(
                    onTweetWithId: cell.tweet.id
                )
                
                bookmarkDeletionResult.map {
                    showBookmarkDeletedSnackBar()
                } onFailure: { failure in
                    showUnknownFailureSnackBar()
                }
            } else {
                let bookmarkCreationResult = await BookmarksDataStore.shared.createBookmark(
                    onTweetWithId: cell.tweet.id
                )
                
                bookmarkCreationResult.map {
                    showBookmarkCreatedSnackBar()
                } onFailure: { failure in
                    showUnknownFailureSnackBar()
                }
            }
        }
    }
    
    func partialTweetCellDidPressFollowOption(
        _ cell: PartialTweetTableViewCell
    ) {
        guard cell.tweet.viewables.author.id != CurrentUserDataStore.shared.user?.id else {
            return
        }
        
        if cell.tweet.viewables.author.viewables.following {
            onSomeoneUnfollowed(
                withId: cell.tweet.viewables.author.id
            )
        } else {
            onSomeoneFollowed(
                withId: cell.tweet.viewables.author.id
            )
        }
        
        Task {
            if cell.tweet.viewables.author.viewables.following {
                let unfollowResult = await SocialsDataStore.shared.unfollow(
                    userWithId: cell.tweet.viewables.author.id
                )
                
                unfollowResult.map {
                    showUnfollowSuccessfulSnackBar(
                        user: cell.tweet.viewables.author
                    )
                } onFailure: { failure in
                    showUnknownFailureSnackBar()
                    onSomeoneFollowed(
                        withId: cell.tweet.viewables.author.id
                    )
                }
            } else {
                let followResult = await SocialsDataStore.shared.follow(
                    userWithId: cell.tweet.viewables.author.id
                )
                
                followResult.map {
                    showFollowSuccesfulSnackBar(
                        user: cell.tweet.viewables.author
                    )
                } onFailure: { failure in
                    showUnknownFailureSnackBar()
                    onSomeoneUnfollowed(
                        withId: cell.tweet.viewables.author.id
                    )
                }

            }
        }
    }
    
    func partialTweetCellDidPressDeleteOption(
        _ cell: PartialTweetTableViewCell
    ) {
        state.mapOnlyOnSuccess { paginatedFeed in
            guard let tweet = paginatedFeed.page.first(where: { $0.id == cell.tweet.id }) else {
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
    
    func partialTweetCellDidPressOptions(
        _ cell: PartialTweetTableViewCell
    ) {
        state.mapOnlyOnSuccess { paginatedFeed in
            guard let tweet = paginatedFeed.page.first(where: { $0.id == cell.tweet.id }) else {
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
extension FeedViewController: TweetOptionsAlertControllerInteractionsHandler {
    func tweetOptionsAlertControllerDidPressBookmark(
        _ controller: TweetOptionsAlertController
    ) {
        print(#function)
    }
    
    func tweetOptionsAlertControllerDidPressFollow(
        _ controller: TweetOptionsAlertController
    ) {
        print(#function)
    }
    
    func tweetOptionsAlertControllerDidPressDelete(
        _ controller: TweetOptionsAlertController
    ) {
        print(#function)
    }
}

// MARK: EventListener
extension FeedViewController {
    private func configureEventListener() {
        TXEventBroker.shared.listen {
            [weak self] event in
            guard let strongSelf = self else {
                return
            }
            
            if event is RefreshedCurrentUserEvent {
                strongSelf.onCurrentUserRefreshed()
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
            
            if let event = event as? BookmarkCreatedEvent {
                strongSelf.onBookmarkCreated(
                    ofTweetWithId: event.tweetId
                )
            }
            
            if let event = event as? BookmarkDeletedEvent {
                strongSelf.onBookmarkDeleted(
                    ofTweetWithId: event.tweetId
                )
            }
            
            if let event = event as? FollowCreatedEvent {
                strongSelf.onSomeoneFollowed(
                    withId: event.userId
                )
            }
            
            if let event = event as? FollowDeletedEvent {
                strongSelf.onSomeoneUnfollowed(
                    withId: event.userId
                )
            }
        }
    }
    
    private func onCurrentUserRefreshed() {
        if let currentUser = CurrentUserDataStore.shared.user {
            state.mapOnlyOnSuccess { previousPaginatedTweets in
                var indices: [Int] = []
                
                previousPaginatedTweets.page.enumerated().forEach { index, tweet in
                    if tweet.viewables.author.id == currentUser.id {
                        indices.append(
                            index
                        )
                    }
                }
                
                let updatedPaginatedTweets = Paginated<Tweet>(
                    page: previousPaginatedTweets.page.map { tweet in
                        if tweet.viewables.author.id == currentUser.id {
                            let viewables = tweet.viewables
                            let updatedViewables = viewables.copyWith(
                                author: currentUser
                            )
                            
                            return tweet.copyWith(
                                viewables: updatedViewables
                            )
                        } else {
                            return tweet
                        }
                    },
                    nextToken: previousPaginatedTweets.nextToken
                )
                
                state = .success(updatedPaginatedTweets)
                
                DispatchQueue.main.asyncAfter(
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
    
    private func onTweetCreated(
        tweet: Tweet
    ) {
        state.mapOnlyOnSuccess { previousPaginatedTweets in
            let updatedPaginatedTweets = Paginated<Tweet>(
                page: [tweet] + previousPaginatedTweets.page,
                nextToken: previousPaginatedTweets.nextToken
            )
            
            state = .success(updatedPaginatedTweets)
            
            DispatchQueue.main.asyncAfter(
                deadline: .now() + 0.1
            ) {
                [weak self] in
                guard let strongSelf = self, strongSelf.tableView.window != nil else {
                    return
                }
                
                strongSelf.tableView.reloadData()
                strongSelf.tableView.appendSepartorToLastMostVisibleCell()
            }
        }
    }
    
    private func onTweetDeleted(
        withId id: String
    ) {
        state.mapOnlyOnSuccess { previousPaginatedTweets in
            let updatedPaginatedTweets = Paginated<Tweet>(
                page: previousPaginatedTweets.page.filter { $0.id != id },
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
    
    private func onSomeoneFollowed(
        withId id: String
    ) {
        state.mapOnlyOnSuccess { previousPaginatedTweets in
            let updatedPaginatedTweets = previousPaginatedTweets.copyWith(
                page: previousPaginatedTweets.page.map { tweet in
                    let viewables = tweet.viewables
                    let author = viewables.author
                    
                    if author.id != id || author.viewables.following {
                        return tweet
                    }
                    
                    let authorViewables = author.viewables
                    let updatedAuthorViewables = authorViewables.copyWith(
                        following: true
                    )
                    
                    let authorSocialDetails = author.socialDetails
                    let updatedAuthorSocialDetails = authorSocialDetails.copyWith(
                        followersCount: authorSocialDetails.followersCount + 1
                    )
                    
                    let updatedAuthor = author.copyWith(
                        socialDetails: updatedAuthorSocialDetails,
                        viewables: updatedAuthorViewables
                    )
                    
                    let updatedViewables = viewables.copyWith(
                        author: updatedAuthor
                    )
                    
                    return tweet.copyWith(
                        viewables: updatedViewables
                    )
                }
            )
            
            state = .success(updatedPaginatedTweets)
        }
    }
    
    private func onSomeoneUnfollowed(
        withId id: String
    ) {
        state.mapOnlyOnSuccess { previousPaginatedTweets in
            let updatedPaginatedTweets = previousPaginatedTweets.copyWith(
                page: previousPaginatedTweets.page.map { tweet in
                    let viewables = tweet.viewables
                    let author = viewables.author
                    
                    if author.id != id || !author.viewables.following {
                        return tweet
                    }
                    
                    let authorViewables = author.viewables
                    let updatedAuthorViewables = authorViewables.copyWith(
                        following: false
                    )
                    
                    let authorSocialDetails = author.socialDetails
                    let updatedAuthorSocialDetails = authorSocialDetails.copyWith(
                        followersCount: authorSocialDetails.followersCount - 1
                    )
                    
                    let updatedAuthor = author.copyWith(
                        socialDetails: updatedAuthorSocialDetails,
                        viewables: updatedAuthorViewables
                    )
                    
                    let updatedViewables = viewables.copyWith(
                        author: updatedAuthor
                    )
                    
                    return tweet.copyWith(
                        viewables: updatedViewables
                    )
                }
            )
            
            state = .success(updatedPaginatedTweets)
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
    
    private func onBookmarkCreated(
        ofTweetWithId tweetId: String
    ) {
        state.mapOnlyOnSuccess { previousPaginatedTweets in
            let updatedPaginatedTweets = Paginated<Tweet>(
                page: previousPaginatedTweets.page.map { tweet in
                    if tweet.id == tweetId && !tweet.viewables.bookmarked {
                        let viewables = tweet.viewables
                        let updatedViewables = viewables.copyWith(
                            bookmarked: true
                        )
                        
                        return tweet.copyWith(
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
    
    private func onBookmarkDeleted(
        ofTweetWithId tweetId: String
    ) {
        state.mapOnlyOnSuccess { previousPaginatedTweets in
            let updatedPaginatedTweets = Paginated<Tweet>(
                page: previousPaginatedTweets.page.map { tweet in
                    if tweet.id == tweetId && tweet.viewables.bookmarked {
                        let viewables = tweet.viewables
                        let updatedViewables = viewables.copyWith(
                            bookmarked: false
                        )
                        
                        return tweet.copyWith(
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
