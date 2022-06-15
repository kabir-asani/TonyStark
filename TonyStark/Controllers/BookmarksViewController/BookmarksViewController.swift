//
//  BookmarksViewController.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 27/04/22.
//

import UIKit

class BookmarksViewController: TXViewController {
    // Declare
    enum BookmarksTableViewSection: Int, CaseIterable {
        case bookmarks
    }
    
    private var state: State<Paginated<Bookmark>, BookmarksFailure> = .processing
    
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
    
    private func addSubviews() {
        view.addSubview(tableView)
    }
    
    private func configureNavigationBar() {
        navigationItem.title = "Bookmarks"
        navigationItem.backButtonTitle = ""
    }
    
    private func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.appendSpacerOnHeader()
        
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
}

// MARK: Event Listeners
extension BookmarksViewController {
    private func configureEventListener() {
        TXEventBroker.shared.listen {
            [weak self] event in
            guard let strongSelf = self else {
                return
            }
            
            if event is RefreshedCurrentUserEvent {
                strongSelf.onCurrentUserRefreshed()
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
            
            if let event = event as? BookmarkDeletedEvent {
                strongSelf.onBookmarkDeleted(
                    ofTweetWithId: event.tweetId
                )
            }
        }
    }
    
    private func onCurrentUserRefreshed() {
        if let currentUser = CurrentUserDataStore.shared.user {
            state.mapOnlyOnSuccess { previousPaginatedBookmarks in
                var indices: [Int] = []
                
                previousPaginatedBookmarks.page.enumerated().forEach { index, bookmark in
                    if bookmark.viewables.tweet.viewables.author.id == currentUser.id {
                        indices.append(
                            index
                        )
                    }
                }
                
                let updatedPaginatedBookmarks = Paginated<Bookmark>(
                    page: previousPaginatedBookmarks.page.map { bookmark in
                        if bookmark.viewables.tweet.viewables.author.id == currentUser.id {
                            let viewables = bookmark.viewables
                            let tweet = viewables.tweet
                            
                            let tweetViewables = viewables.tweet.viewables
                            let updatedTweetViewables = tweetViewables.copyWith(
                                author: currentUser
                            )
                            
                            let updatedTweet = tweet.copyWith(
                                viewables: updatedTweetViewables
                            )
                            let updatedViewables = viewables.copyWith(
                                tweet: updatedTweet
                            )
                            
                            return bookmark.copyWith(
                                viewables: updatedViewables
                            )
                        } else {
                            return bookmark
                        }
                    },
                    nextToken: previousPaginatedBookmarks.nextToken
                )
                
                state = .success(updatedPaginatedBookmarks)
                
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
    
    private func onTweetDeleted(
        withId id: String
    ) {
        state.mapOnlyOnSuccess { previousPaginatedBookmarks in
            let updatedPaginatedBookmarks = Paginated<Bookmark>(
                page: previousPaginatedBookmarks.page.filter { $0.viewables.tweet.id != id },
                nextToken: previousPaginatedBookmarks.nextToken
            )
            
            state = .success(updatedPaginatedBookmarks)
            
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
    
    private func onTweetLiked(
        withId id: String
    ) {
        state.mapOnlyOnSuccess { previousPaginatedBookmarks in
            let updatedPaginatedBookmarks = Paginated<Bookmark>(
                page: previousPaginatedBookmarks.page.map { bookmark in
                    if bookmark.viewables.tweet.id == id && !bookmark.viewables.tweet.viewables.liked {
                        let interactionDetails = bookmark.viewables.tweet.interactionDetails
                        let updatedInteractionDetails = interactionDetails.copyWith(
                            likesCount: interactionDetails.likesCount + 1
                        )
                        
                        let viewables = bookmark.viewables.tweet.viewables
                        let updatedTweetViewables = viewables.copyWith(
                            liked: true
                        )
                        
                        let updatedTweet = bookmark.viewables.tweet.copyWith(
                            interactionDetails: updatedInteractionDetails,
                            viewables: updatedTweetViewables
                        )
                        
                        return bookmark.copyWith(
                            viewables: bookmark.viewables.copyWith(
                                tweet: updatedTweet
                            )
                        )
                    } else {
                        return bookmark
                    }
                },
                nextToken: previousPaginatedBookmarks.nextToken
            )
            
            state = .success(updatedPaginatedBookmarks)
            
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
    
    private func onTweetUnliked(
        withId id: String
    ) {
        state.mapOnlyOnSuccess { previousPaginatedBookmarks in
            let updatedPaginatedBookmarks = Paginated<Bookmark>(
                page: previousPaginatedBookmarks.page.map { bookmark in
                    if bookmark.viewables.tweet.id == id && bookmark.viewables.tweet.viewables.liked {
                        let interactionDetails = bookmark.viewables.tweet.interactionDetails
                        let updatedInteractionDetails = interactionDetails.copyWith(
                            likesCount: interactionDetails.likesCount - 1
                        )
                        
                        let viewables = bookmark.viewables.tweet.viewables
                        let updatedTweetViewables = viewables.copyWith(
                            liked: false
                        )
                        
                        let updatedTweet = bookmark.viewables.tweet.copyWith(
                            interactionDetails: updatedInteractionDetails,
                            viewables: updatedTweetViewables
                        )
                        
                        return bookmark.copyWith(
                            viewables: bookmark.viewables.copyWith(
                                tweet: updatedTweet
                            )
                        )
                    } else {
                        return bookmark
                    }
                },
                nextToken: previousPaginatedBookmarks.nextToken
            )
            
            state = .success(updatedPaginatedBookmarks)
            
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
        state.mapOnlyOnSuccess { previousPaginatedBookmarks in
            let updatedPaginatedBookmarks = Paginated<Bookmark>(
                page: previousPaginatedBookmarks.page.filter { bookmark  in
                    bookmark.viewables.tweet.id != tweetId
                },
                nextToken: previousPaginatedBookmarks.nextToken
            )
            
            state = .success(updatedPaginatedBookmarks)
            
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

// MARK: TXTableViewDataSource
extension BookmarksViewController: TXTableViewDataSource {
    private func populateTableView() {
        Task {
            tableView.beginPaginating()
            
            let bookmarksResult = await BookmarksDataStore.shared.bookmarks()
            
            tableView.endPaginating()
            
            bookmarksResult.map { paginatedBookmarks in
                state = .success(paginatedBookmarks)
                tableView.reloadData()
            } onFailure: { cause in
                state = .failure(cause)
            }
        }
    }
    
    private func refreshTableView() {
        Task {
            tableView.beginRefreshing()
            
            let bookmarksResult = await BookmarksDataStore.shared.bookmarks()
            
            tableView.endRefreshing()
            
            bookmarksResult.map { paginatedBookmarks in
                state = .success(paginatedBookmarks)
                tableView.reloadData()
            } onFailure: { cause in
                state = .failure(cause)
            }
        }
    }
    
    private func extendTableView() {
        state.mapOnlyOnSuccess { previousPaginatedBookmarks in
            guard let nextToken = previousPaginatedBookmarks.nextToken else {
                return
            }
            
            Task {
                tableView.beginPaginating()
                
                let bookmarksResult = await BookmarksDataStore.shared.bookmarks(
                    after: nextToken
                )
                
                tableView.endPaginating()
                
                bookmarksResult.mapOnlyOnSuccess { latestPaginatedBookmarks in
                    let updatedPaginatedBookmarks = Paginated<Bookmark>(
                        page: previousPaginatedBookmarks.page + latestPaginatedBookmarks.page,
                        nextToken: latestPaginatedBookmarks.nextToken
                    )
                    
                    tableView.appendSepartorToLastMostVisibleCell()
                    
                    state = .success(updatedPaginatedBookmarks)
                    tableView.reloadData()
                }
            }
        }
    }
    
    
    func numberOfSections(
        in tableView: UITableView
    ) -> Int {
        BookmarksTableViewSection.allCases.count
    }
    
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        state.mapOnSuccess { paginatedBookmarks in
            paginatedBookmarks.page.count
        } orElse: {
            0
        }
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        state.mapOnSuccess { paginatedBookmarks in
            let cell = tableView.dequeueReusableCell(
                withIdentifier: PartialTweetTableViewCell.reuseIdentifier,
                for: indexPath
            ) as! PartialTweetTableViewCell
            
            let bookmark = paginatedBookmarks.page[indexPath.row]
            
            cell.interactionsHandler = self
            cell.configure(withTweet: bookmark.viewables.tweet)
            
            return cell
        } orElse: {
            TXTableViewCell()
        }
    }
}

// MARK: TXTableViewDelegate
extension BookmarksViewController: TXTableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        willDisplay cell: UITableViewCell,
        forRowAt indexPath: IndexPath
    ) {
        state.mapOnlyOnSuccess { paginatedBookmarks in
            if paginatedBookmarks.page.isEmpty {
                tableView.removeSeparatorOnCell(cell)
                return
            }
            
            if indexPath.row == paginatedBookmarks.page.count - 1 {
                tableView.removeSeparatorOnCell(cell)
                
                extendTableView()
            } else {
                tableView.appendSeparatorOnCell(cell)
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
        
        state.mapOnlyOnSuccess { paginatedBookmarks in
            let bookmark = paginatedBookmarks.page[indexPath.row]
            
            navigationController?.openTweetViewController(withTweet: bookmark.viewables.tweet)
        }
    }
}

// MARK: TXRefreshControlDelegate
extension BookmarksViewController: TXRefreshControlDelegate {
    func refreshControlDidChange(_ control: TXRefreshControl) {
        if control.isRefreshing {
            refreshTableView()
        }
    }
}

// MARK: PartialTweetTableViewCellInteractionsHandler
extension BookmarksViewController: PartialTweetTableViewCellInteractionsHandler {
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
        state.mapOnlyOnSuccess { paginatedBookmarks in
            guard let bookmark = paginatedBookmarks.page.first(where: { $0.id == cell.tweet.id }) else {
                return
            }
            
            navigationController?.openTweetViewController(
                withTweet: bookmark.viewables.tweet,
                andOptions: .init(
                    autoFocus: true
                )
            )
        }
    }
    
    func partialTweetCellDidPressProfileImage(
        _ cell: PartialTweetTableViewCell
    ) {
        state.mapOnlyOnSuccess { paginatedBookmarks in
            guard let bookmark = paginatedBookmarks.page.first(where: { $0.id == cell.tweet.id }) else {
                return
            }
            
            navigationController?.openUserViewController(withUser: bookmark.viewables.tweet.viewables.author)
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
        print(#function)
    }
    
    func partialTweetCellDidPressDeleteOption(
        _ cell: PartialTweetTableViewCell
    ) {
        print(#function)
    }
    
    func partialTweetCellDidPressOptions(
        _ cell: PartialTweetTableViewCell
    ) {
        state.mapOnlyOnSuccess { paginatedBookmarks in
            guard let bookmark = paginatedBookmarks.page.first(where: { $0.id == cell.tweet.id }) else {
                return
            }
            
            let alert = TweetOptionsAlertController.regular()
            
            alert.interactionsHandler = self
            alert.configure(
                withTweet: bookmark.viewables.tweet
            )
            
            present(
                alert,
                animated: true
            )
        }
    }
}

extension BookmarksViewController: TweetOptionsAlertControllerInteractionsHandler {
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
