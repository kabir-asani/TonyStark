//
//  TweetViewController.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 26/04/22.
//

import UIKit

class TweetViewController: TXViewController {
    struct Options {
        static var `default`: Options {
            Options(
                autoFocus: false
            )
        }
        
        let autoFocus: Bool
    }
    
    enum TweetsTableViewSection: Int, CaseIterable {
        case tweet
        case comments
    }
    
    private(set) var tweet: Tweet = .default
    private(set) var options: Options = .default
    
    private var state: State<Paginated<Comment>, CommentsFailure> = .processing
    
    // Declare
    private let tableView: TXTableView = {
        let tableView = TXTableView()
        
        tableView.enableAutolayout()
        
        return tableView
    }()
    
    private let commentInputBar: CommentInputBar = {
        let commentInputBar = CommentInputBar()
        
        commentInputBar.enableAutolayout()
        
        return commentInputBar
    }()
    
    private let separator: TXView = {
        let separator = TXView()
        
        separator.enableAutolayout()
        separator.backgroundColor = .separator
        
        return separator
    }()
    
    private let bottomInputBar: TXView = {
        let bottomBar = TXView()
        
        bottomBar.enableAutolayout()
        bottomBar.backgroundColor = .systemBackground
        
        return bottomBar
    }()
    
    // Configure
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSubviews()
        
        configureEventListener()
        
        configureNavigationBar()
        configureTableView()
        configureRefreshControl()
        configureCommentInputBar()
        configureSeparator()
        configureBottomInputBar()
        
        populateTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        startKeyboardAwareness()
        
        tabBarController?.tabBar.clipsToBounds = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        stopKeyboardAwareness()
        
        tabBarController?.tabBar.clipsToBounds = false
        tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if options.autoFocus {
            _ = commentInputBar.becomeFirstResponder()
        }
        
        tableView.reloadData()
    }
    
    private func addSubviews() {
        bottomInputBar.addSubview(separator)
        bottomInputBar.addSubview(commentInputBar)
        
        view.addSubview(tableView)
        view.addSubview(bottomInputBar)
    }
    
    private func configureNavigationBar() {
        navigationItem.title = "Tweet"
        navigationItem.backButtonTitle = ""
    }
    
    private func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.appendSpacerOnHeader()
        
        tableView.keyboardDismissMode = .onDrag
        
        tableView.register(
            TweetTableViewCell.self,
            forCellReuseIdentifier: TweetTableViewCell.reuseIdentifier
        )
        tableView.register(
            CommentTableViewCell.self,
            forCellReuseIdentifier: CommentTableViewCell.reuseIdentifer
        )
        
        tableView.pin(
            toTopOf: view,
            byBeingSafeAreaAware: true
        )
        tableView.pin(
            toLeftOf: view,
            byBeingSafeAreaAware: true
        )
        tableView.pin(
            toRightOf: view,
            byBeingSafeAreaAware: true
        )
        tableView.attach(
            bottomToTopOf: bottomInputBar,
            byBeingSafeAreaAware: true
        )
    }
    
    private func configureRefreshControl() {
        let refreshControl = TXRefreshControl()
        refreshControl.delegate = self
        
        tableView.refreshControl = refreshControl
    }
    
    private func configureCommentInputBar() {
        commentInputBar.configure(
            withData: (
                inputPlaceholder: "Enter a comment ...",
                buttonText: "Post"
            )
        ) { text in
            Task {
                [weak self] in
                guard let strongSelf = self else {
                    return
                }
                
                let commentResult = await CommentsDataStore.shared.createComment(
                    withText: text,
                    onTweetWithId: strongSelf.tweet.id
                )
                
                commentResult.map {
                    strongSelf.refreshTableView()
                } onFailure: { failure in
                    strongSelf.showUnknownFailureSnackBar()
                }
            }
        }
        
        commentInputBar.pin(
            to: bottomInputBar,
            withInsets: TXEdgeInsets(
                top: 0,
                right: 16,
                bottom: 0,
                left: 16
            )
        )
    }
    
    private func configureSeparator() {
        separator.fixHeight(to: 0.5)
        
        separator.pin(
            toRightOf: bottomInputBar,
            byBeingSafeAreaAware: true
        )
        separator.pin(
            toLeftOf: bottomInputBar,
            byBeingSafeAreaAware: true
        )
    }
    
    private func configureBottomInputBar() {
        bottomInputBar.fixHeight(to: 50)
        bottomInputBar.pin(
            toRightOf: view,
            byBeingSafeAreaAware: true
        )
        bottomInputBar.pin(
            toLeftOf: view,
            byBeingSafeAreaAware: true
        )
        bottomInputBar.pin(
            toBottomOf: view,
            byBeingSafeAreaAware: true
        )
    }
    
    // Populate
    func populate(
        withTweet tweet: Tweet,
        options: Options = .default
    ) {
        self.tweet = tweet
        self.options = options
    }
    
    // Interact
    override func onKeyboardWillShow(_ notification: Notification) {
        super.onKeyboardWillShow(notification)
        
        tableView.scrollToRow(
            at: IndexPath(
                row: 0,
                section: 0
            ),
            at: .top,
            animated: true
        )
    }
}

// MARK: TXTableViewDataSource
extension TweetViewController: TXTableViewDataSource {
    private func populateTableView() {
        Task {
            tableView.beginPaginating()
            
            let commentsResult = await CommentsDataStore.shared.comments(
                onTweetWithId: tweet.id
            )
            
            tableView.endPaginating()
            
            commentsResult.map { paginatedComments in
                state = .success(paginatedComments)
            } onFailure: { cause in
                state = .failure(cause)
            }
            
            tableView.reloadData()
        }
    }
    
    private func refreshTableView() {
        Task {
            tableView.beginRefreshing()
            
            let commentsResult = await CommentsDataStore.shared.comments(
                onTweetWithId: tweet.id
            )
            
            tableView.endRefreshing()
            
            commentsResult.map { paginatedComments in
                state = .success(paginatedComments)
            } onFailure: { cause in
                state = .failure(cause)
            }
            
            tableView.reloadData()
        }
    }
    
    private func extendTableView() {
        state.mapOnlyOnSuccess { previousPaginatedComments in
            guard let nextToken = previousPaginatedComments.nextToken else {
                return
            }
           
            Task {
                tableView.beginPaginating()
                
                let commentsResult = await CommentsDataStore.shared.comments(
                    onTweetWithId: tweet.id,
                    after: nextToken
                )
                
                tableView.endPaginating()
                
                commentsResult.mapOnlyOnSuccess { latestPaginatedComments in
                    let updatedPaginatedComments = Paginated<Comment>(
                        page: previousPaginatedComments.page + latestPaginatedComments.page,
                        nextToken: latestPaginatedComments.nextToken
                    )
                    
                    tableView.appendSepartorToLastMostVisibleCell()
                    
                    state = .success(updatedPaginatedComments)
                    tableView.reloadData()
                }
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        TweetsTableViewSection.allCases.count
    }
    
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        switch section {
        case TweetsTableViewSection.tweet.rawValue:
            return 1
        case TweetsTableViewSection.comments.rawValue:
            return state.mapOnSuccess { paginatedComments in
                paginatedComments.page.count
            } orElse: {
                0
            }
        default:
            fatalError("No other sections are present")
        }
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        switch indexPath.section {
        case TweetsTableViewSection.tweet.rawValue:
            let cell = tableView.dequeueReusableCell(
                withIdentifier: TweetTableViewCell.reuseIdentifier,
                for: indexPath
            ) as! TweetTableViewCell
            
            cell.interactionsHandler = self
            cell.configure(
                withTweet: tweet
            )
            
            return cell
        case TweetsTableViewSection.comments.rawValue:
            return state.mapOnSuccess { paginatedComments in
                let comment = paginatedComments.page[indexPath.row]
                
                let cell = tableView.dequeueReusableCell(
                    withIdentifier: CommentTableViewCell.reuseIdentifer,
                    for: indexPath
                ) as! CommentTableViewCell
                
                cell.interactionsHandler = self
                cell.configure(
                    withComment: comment
                )
                
                return cell
            } orElse: {
                TXTableViewCell()
            }
        default:
            fatalError("No other sections are present")
        }
    }
}

// MARK: TXRefreshControlDelegate
extension TweetViewController: TXRefreshControlDelegate {
    func refreshControlDidChange(_ control: TXRefreshControl) {
        if control.isRefreshing {
            refreshTableView()
        }
    }
}

// MARK: TXTableViewDelegate
extension TweetViewController: TXTableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        willDisplay cell: UITableViewCell,
        forRowAt indexPath: IndexPath
    ) {
        state.mapOnlyOnSuccess { paginatedComments in
            if paginatedComments.page.isEmpty {
                return
            }
            
            if indexPath.row == paginatedComments.page.count - 1 {
                extendTableView()
            }
        }
    }
}

// MARK: TweetTableViewCellInteractionsHandler
extension TweetViewController: TweetTableViewCellInteractionsHandler {
    func tweetCellDidPressProfileImage(
        _ cell: TweetTableViewCell
    ) {
        let user = tweet.viewables.author
        
        navigationController?.openUserViewController(
            withUser: user
        )
    }
    
    func tweetCellDidPressProfileDetails(
        _ cell: TweetTableViewCell
    ) {
        let user = tweet.viewables.author
        
        navigationController?.openUserViewController(
            withUser: user
        )
    }
    
    func tweetCellDidPressLike(
        _ cell: TweetTableViewCell
    ) {
        if cell.tweet.viewables.liked {
            onTweetUnliked()
        } else {
            onTweetLiked()
        }
        
        Task {
            if cell.tweet.viewables.liked {
                let likeCreationResult = await LikesDataStore.shared.deleteLike(
                    onTweetWithId: tweet.id
                )
                
                likeCreationResult.mapOnlyOnFailure { failure in
                    showUnknownFailureSnackBar()
                    
                    onTweetLiked()
                }
            } else {
                let likeDeletionResult = await LikesDataStore.shared.createLike(
                    onTweetWithId: tweet.id
                )
                
                likeDeletionResult.mapOnlyOnFailure { failure in
                    showUnknownFailureSnackBar()
                    
                    onTweetUnliked()
                }
            }
        }
    }
    
    func tweetCellDidPressLikeDetails(
        _ cell: TweetTableViewCell
    ) {
        if tweet.interactionDetails.likesCount > 0 {
            let likesViewController = LikesViewController()
            
            likesViewController.populate(withTweet: tweet)
            
            navigationController?.pushViewController(
                likesViewController,
                animated: true
            )
        }
    }
    
    func tweetCellDidPressBookmarkOption(_ cell: TweetTableViewCell) {
        Task {
            if tweet.viewables.bookmarked {
                let bookmarkDeletionResult = await BookmarksDataStore.shared.deleteBookmark(
                    onTweetWithId: tweet.id
                )
                
                bookmarkDeletionResult.map {
                    showBookmarkDeletedSnackBar()
                } onFailure: { failure in
                    showUnknownFailureSnackBar()
                }
            } else {
                let bookmarkCreationResult = await BookmarksDataStore.shared.createBookmark(
                    onTweetWithId: tweet.id
                )
                
                bookmarkCreationResult.map {
                    showBookmarkCreatedSnackBar()
                } onFailure: { failure in
                    showUnknownFailureSnackBar()
                }
            }
        }
    }
    
    func tweetCellDidPressFollowOption(
        _ cell: TweetTableViewCell
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
    
    func tweetCellDidPressDeleteOption(_ cell: TweetTableViewCell) {
        Task {
            DispatchQueue.main.async {
                [weak self]  in
                guard let strongSelf = self else {
                    return
                }
                
                strongSelf.view.alpha = 0.4
                strongSelf.view.isUserInteractionEnabled = false
            }
            
            let deleteTweetResult = await TweetsDataStore.shared.deleteTweet(
                withId: cell.tweet.id
            )
            
            deleteTweetResult.mapOnSuccess {
                DispatchQueue.main.async {
                    [weak self] in
                    guard let strongSelf = self else {
                        return
                    }
                    
                    strongSelf.navigationController?.popViewController(
                        animated: true
                    )
                }
            } orElse: {
                DispatchQueue.main.async {
                    [weak self] in
                    guard let strongSelf = self else {
                        return
                    }
                    
                    strongSelf.showUnknownFailureSnackBar()
                }
            }
            
            DispatchQueue.main.async {
                [weak self]  in
                guard let strongSelf = self else {
                    return
                }
                
                strongSelf.view.alpha = 1.0
                strongSelf.view.isUserInteractionEnabled = false
            }
        }
    }
    
    func tweetCellDidPressOptions(_ cell: TweetTableViewCell) {
        let alert = TweetOptionsAlertController.regular()
        
        alert.interactionsHandler = self
        alert.configure(withTweet: tweet)
        
        present(
            alert,
            animated: true
        )
    }
}

// MARK: CommentTableViewCellInteractionsHandler
extension TweetViewController: CommentTableViewCellInteractionsHandler {
    func commentCellDidPressProfileImage(_ cell: CommentTableViewCell) {
        state.mapOnlyOnSuccess { paginatedComments in
            guard let comment = paginatedComments.page.first(where: { $0.id == cell.comment.id }) else {
                return
            }
            
            let user = comment.viewables.author
            
            navigationController?.openUserViewController(withUser: user)
        }
    }
}

// MARK: TweetOptionsAlertControllerInteractionsHandler
extension TweetViewController: TweetOptionsAlertControllerInteractionsHandler {
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
extension TweetViewController {
    private func configureEventListener() {
        TXEventBroker.shared.listen {
            [weak self] event in
            guard let strongSelf = self else {
                return
            }
            
            if event is RefreshedCurrentUserEvent {
                strongSelf.onCurrentUserRefreshed()
            }
            
            if let event = event as? LikeCreatedEvent, event.tweetId == strongSelf.tweet.id {
                strongSelf.onTweetLiked()
            }
            
            if let event = event as? LikeDeletedEvent, event.tweetId == strongSelf.tweet.id {
                strongSelf.onTweetUnliked()
            }
            
            if let event = event as? BookmarkCreatedEvent, event.tweetId == strongSelf.tweet.id {
                strongSelf.onBookmarkCreated()
            }
            
            if let event = event as? BookmarkDeletedEvent, event.tweetId == strongSelf.tweet.id {
                strongSelf.onBookmarkDeleted()
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
            if tweet.viewables.author.id == currentUser.id {
                let viewables = tweet.viewables
                let updatedViewables = viewables.copyWith(
                    author: currentUser
                )
                
                tweet = tweet.copyWith(
                    viewables: updatedViewables
                )
                
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
            
            state.mapOnlyOnSuccess { previousPaginatedComments in
                var indices: [Int] = []
                
                previousPaginatedComments.page.enumerated().forEach { index, comment in
                    if comment.viewables.author.id == currentUser.id {
                        indices.append(
                            index
                        )
                    }
                }
                
                let updatedPaginatedComments = Paginated<Comment>(
                    page: previousPaginatedComments.page.map { comment in
                        if comment.viewables.author.id == currentUser.id {
                            let viewables = comment.viewables
                            let updatedViewables = viewables.copyWith(
                                author: currentUser
                            )
                            
                            return comment.copyWith(
                                viewables: updatedViewables
                            )
                        } else {
                            return comment
                        }
                    },
                    nextToken: previousPaginatedComments.nextToken
                )
                
                state = .success(updatedPaginatedComments)
                
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
    
    private func onTweetLiked() {
        if !tweet.viewables.liked {
            let intractionDetails = tweet.interactionDetails
            let updatedInteractionDetails = intractionDetails.copyWith(
                likesCount: intractionDetails.likesCount + 1
            )
            
            let viewables = tweet.viewables
            let updatedViewables = viewables.copyWith(
                liked: true
            )
            
            tweet = tweet.copyWith(
                interactionDetails: updatedInteractionDetails,
                viewables: updatedViewables
            )
            
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
    
    private func onTweetUnliked() {
        if tweet.viewables.liked {
            let intractionDetails = tweet.interactionDetails
            let updatedInteractionDetails = intractionDetails.copyWith(
                likesCount: intractionDetails.likesCount - 1
            )
            
            let viewables = tweet.viewables
            let updatedViewables = viewables.copyWith(
                liked: false
            )
            
            tweet = tweet.copyWith(
                interactionDetails: updatedInteractionDetails,
                viewables: updatedViewables
            )
            
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
    
    private func onBookmarkCreated() {
        let viewables = tweet.viewables
        let updatedViewables = viewables.copyWith(
            bookmarked: true
        )
        
        tweet = tweet.copyWith(
            viewables: updatedViewables
        )
        
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
    
    private func onBookmarkDeleted() {
        let viewables = tweet.viewables
        let updatedViewables = viewables.copyWith(
            bookmarked: false
        )
        
        tweet = tweet.copyWith(
            viewables: updatedViewables
        )
        
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
    
    private func onSomeoneFollowed(
        withId id: String
    ) {
        let viewables = tweet.viewables
        let author = viewables.author
        
        if author.id == id && author.viewables.following {
            let authorViewables = author.viewables
            let authorSocialDetails = author.socialDetails
            
            let updatedAuthorViewables = authorViewables.copyWith(
                following: true
            )
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
            
            tweet = tweet.copyWith(
                viewables: updatedViewables
            )
            
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
        
        state.mapOnlyOnSuccess { previousPaginatedComments in
            let updatedPaginatedComments = previousPaginatedComments.copyWith(
                page: previousPaginatedComments.page.map { comment in
                    let viewables = comment.viewables
                    let author = viewables.author
                    
                    if author.id != id || author.viewables.following {
                        return comment
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
                    
                    return comment.copyWith(
                        viewables: updatedViewables
                    )
                }
            )
            
            state = .success(updatedPaginatedComments)
            
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
    
    private func onSomeoneUnfollowed(
        withId id: String
    ) {
        let viewables = tweet.viewables
        let author = viewables.author
        
        if author.id == id && author.viewables.following {
            let authorViewables = author.viewables
            let authorSocialDetails = author.socialDetails
            
            let updatedAuthorViewables = authorViewables.copyWith(
                following: false
            )
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
            
            tweet = tweet.copyWith(
                viewables: updatedViewables
            )
            
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
        
        state.mapOnlyOnSuccess { previousPaginatedComments in
            let updatedPaginatedComments = previousPaginatedComments.copyWith(
                page: previousPaginatedComments.page.map { comment in
                    let viewables = comment.viewables
                    let author = viewables.author
                    
                    if author.id != id || !author.viewables.following {
                        return comment
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
                    
                    return comment.copyWith(
                        viewables: updatedViewables
                    )
                }
            )
            
            state = .success(updatedPaginatedComments)
            
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
