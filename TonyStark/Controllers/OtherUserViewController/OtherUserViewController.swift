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
        
        configureEventListener()
        
        configureNavigationBar()
        configureTableView()
        configureRefreshControl()
        
        populateTableView()
    }
    
    override func viewDidAppear(
        _ animated: Bool
    ) {
        super.viewDidAppear(
            animated
        )
        
        tableView.reloadData()
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
            
            await refreshUserSection()
            await refreshTweetsSection()
            
            tableView.endRefreshing()
        }
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
    
    private func refreshUserSection() async {
        let userRefreshResult = await OtherUserDataStore.shared.user(
            userId: user.id
        )
        
        userRefreshResult.mapOnSuccess { latestUser in
            self.user = latestUser
            
            DispatchQueue.main.async {
                [weak self] in
                guard let strongSelf = self else {
                    return
                }
                
                strongSelf.tableView.reloadSections(
                    IndexSet(
                        integer: OtherUserTableViewSection.user.rawValue
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
                        integer: OtherUserTableViewSection.tweets.rawValue
                    ),
                    with: .none
                )
                strongSelf.tableView.appendSpacerOnFooter()
            }
        } orElse: {
            showUnknownFailureSnackBar()
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
            cell.configure(
                withUser: user
            )
            
            return cell
        case OtherUserTableViewSection.tweets.rawValue:
            return state.mapOnSuccess { paginatedTweets in
                let cell = tableView.dequeueReusableCell(
                    withIdentifier: PartialTweetTableViewCell.reuseIdentifier,
                    for: indexPath
                ) as! PartialTweetTableViewCell
                
                let tweet = paginatedTweets.page[indexPath.row]
                
                cell.interactionsHandler = self
                cell.configure(
                    withTweet: tweet
                )
                
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
            state.mapOnlyOnSuccess { paginatedTweets in
                if paginatedTweets.page.isEmpty {
                    return
                }
                
                if indexPath.row == paginatedTweets.page.count - 1 {
                    extendTableView()
                }
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
    func otherUserCellDidPressFollow(
        _ cell: OtherUserTableViewCell
    ) {
        if cell.user.viewables.following {
            onUserUnfollowed()
        } else {
            onUserFollowed()
        }
        
        Task {
            if cell.user.viewables.following {
                let unfollowResult = await SocialsDataStore.shared.unfollow(
                    userWithId: cell.user.id
                )
                
                unfollowResult.map {
                    showUnfollowSuccessfulSnackBar(
                        user: cell.user
                    )
                } onFailure: { failure in
                    showUnknownFailureSnackBar()
                    onUserFollowed()
                }

                
                unfollowResult.mapOnlyOnFailure { failure in
                    showUnknownFailureSnackBar()
                    onUserFollowed()
                }
            } else {
                let followResult = await SocialsDataStore.shared.follow(
                    userWithId: cell.user.id
                )
                
                followResult.map {
                    showFollowSuccesfulSnackBar(
                        user: cell.user
                    )
                } onFailure: { failure in
                    showUnknownFailureSnackBar()
                    onUserUnfollowed()
                }
            }
        }
    }
    
    func otherUserCellDidPressFollowers(
        _ cell: OtherUserTableViewCell
    ) {
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
    
    func otherUserCellDidPressFollowings(
        _ cell: OtherUserTableViewCell
    ) {
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
    
    func partialTweetCellDidPressProfileImage(
        _ cell: PartialTweetTableViewCell
    ) {
        navigationController?.openUserViewController(withUser: user)
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
        
        Task {
            if cell.tweet.viewables.author.viewables.following {
                let unfollowResult = await SocialsDataStore.shared.unfollow(
                    userWithId: cell.tweet.viewables.author.id
                )
                
                unfollowResult.mapOnlyOnFailure { failure in
                    showUnknownFailureSnackBar()
                }
            } else {
                let followResult = await SocialsDataStore.shared.follow(
                    userWithId: cell.tweet.viewables.author.id
                )
                
                followResult.mapOnlyOnFailure { failure in
                    showUnknownFailureSnackBar()
                }
            }
        }
    }
    
    func partialTweetCellDidPressDeleteOption(
        _ cell: PartialTweetTableViewCell
    ) {
        print(#function)
    }
    
    func partialTweetCellDidPressOptions(
        _ cell: PartialTweetTableViewCell
    ) {
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
extension OtherUserViewController {
    private func configureEventListener() {
        TXEventBroker.shared.listen {
            [weak self] event in
            guard let strongSelf = self else {
                return
            }
            
            if let event = event as? FollowCreatedEvent, event.userId == strongSelf.user.id {
                strongSelf.onUserFollowed()
            }
            
            if let event = event as? FollowDeletedEvent, event.userId == strongSelf.user.id {
                strongSelf.onUserUnfollowed()
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
    
    private func onUserFollowed() {
        if !user.viewables.following {
            let viewables = user.viewables
            let updatedViewables = viewables.copyWith(
                following: true
            )
            
            let socialDetails = user.socialDetails
            let updatedSocialDetails = socialDetails.copyWith(
                followersCount: socialDetails.followersCount + 1
            )
            
            user = user.copyWith(
                socialDetails: updatedSocialDetails,
                viewables: updatedViewables
            )
            
            state.mapOnlyOnSuccess { paginatedTweets in
                let updatedPaginatedTweets = paginatedTweets.copyWith(
                    page: paginatedTweets.page.map { tweet in
                        let viewables = tweet.viewables
                        let author = viewables.author
                        
                        let authorViewables = author.viewables
                        let updatedAuthorViewables = authorViewables.copyWith(
                            following: true
                        )
                        
                        let socialDetails = author.socialDetails
                        let updatedSocialDetails = socialDetails.copyWith(
                            followersCount: socialDetails.followeesCount + 1
                        )
                        
                        let updatedAuthor = author.copyWith(
                            socialDetails: updatedSocialDetails,
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
    
    private func onUserUnfollowed() {
        if user.viewables.following {
            let viewables = user.viewables
            let updatedViewables = viewables.copyWith(
                following: false
            )
            
            let socialDetails = user.socialDetails
            let updatedSocialDetails = socialDetails.copyWith(
                followersCount: socialDetails.followersCount - 1
            )
            
            user = user.copyWith(
                socialDetails: updatedSocialDetails,
                viewables: updatedViewables
            )
            
            state.mapOnlyOnSuccess { paginatedTweets in
                let updatedPaginatedTweets = paginatedTweets.copyWith(
                    page: paginatedTweets.page.map { tweet in
                        let viewables = tweet.viewables
                        let author = viewables.author
                        
                        let authorViewables = author.viewables
                        let updatedAuthorViewables = authorViewables.copyWith(
                            following: false
                        )
                        
                        let socialDetails = author.socialDetails
                        let updatedSocialDetails = socialDetails.copyWith(
                            followersCount: socialDetails.followeesCount - 1
                        )
                        
                        let updatedAuthor = author.copyWith(
                            socialDetails: updatedSocialDetails,
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
