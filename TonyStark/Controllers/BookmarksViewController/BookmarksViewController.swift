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

// MARK: TXTableViewDataSource
extension BookmarksViewController: TXTableViewDataSource {
    private func populateTableView() {
        Task {
            [weak self] in
            guard let strongSelf = self else {
                return
            }
            
            strongSelf.tableView.beginPaginating()
            
            let bookmarksResult = await BookmarksDataStore.shared.bookmarks()
            
            strongSelf.tableView.endPaginating()
            
            bookmarksResult.map { paginatedBookmarks in
                strongSelf.state = .success(data: paginatedBookmarks)
                strongSelf.tableView.reloadData()
            } onFailure: { cause in
                strongSelf.state = .failure(cause: cause)
            }
        }
    }
    
    private func refreshTableView() {
        Task {
            [weak self] in
            guard let strongSelf = self else {
                return
            }
            
            strongSelf.tableView.beginRefreshing()
            
            let bookmarksResult = await BookmarksDataStore.shared.bookmarks()
            
            strongSelf.tableView.endRefreshing()
            
            bookmarksResult.map { paginatedBookmarks in
                strongSelf.state = .success(data: paginatedBookmarks)
                strongSelf.tableView.reloadData()
            } onFailure: { cause in
                strongSelf.state = .failure(cause: cause)
            }
        }
    }
    
    private func extendTableView() {
        state.mapOnSuccess { previousPaginatedBookmarks in
            guard let nextToken = previousPaginatedBookmarks.nextToken else {
                return
            }
            
            Task {
                [weak self] in
                guard let strongSelf = self else {
                    return
                }
                
                strongSelf.tableView.beginPaginating()
                
                let bookmarksResult = await BookmarksDataStore.shared.bookmarks(
                    after: nextToken
                )
                
                strongSelf.tableView.endPaginating()
                
                bookmarksResult.map { latestPaginatedBookmarks in
                    let updatedPaginatedBookmarks = Paginated<Bookmark>(
                        page: previousPaginatedBookmarks.page + latestPaginatedBookmarks.page,
                        nextToken: latestPaginatedBookmarks.nextToken
                    )
                    
                    strongSelf.tableView.appendSepartorToLastMostVisibleCell()
                    
                    strongSelf.state = .success(data: updatedPaginatedBookmarks)
                    strongSelf.tableView.reloadData()
                } onFailure: { cause in
                    // TODO: Communicate via SnackBar
                }
            }
        } orElse: {
            // Do nothing
        }
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
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
                assigning: indexPath
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
        if indexPath.row == tableView.numberOfRows(inSection: BookmarksTableViewSection.bookmarks.rawValue) - 1 {
            tableView.removeSeparatorOnCell(cell)
            
            extendTableView()
        } else {
            tableView.appendSeparatorOnCell(cell)
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
        
        state.mapOnSuccess { paginatedBookmarks in
            let bookmark = paginatedBookmarks.page[indexPath.row]
            
            navigationController?.openTweetViewController(withTweet: bookmark.viewables.tweet)
        } orElse: {
            // Do nothing
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
    func partialTweetCellDidPressLike(_ cell: PartialTweetTableViewCell) {
        print(#function)
    }
    
    func partialTweetCellDidPressComment(_ cell: PartialTweetTableViewCell) {
        state.mapOnSuccess { paginatedBookmarks in
            let bookmark = paginatedBookmarks.page[cell.indexPath.row]
            
            navigationController?.openTweetViewController(
                withTweet: bookmark.viewables.tweet,
                andOptions: .init(
                    autoFocus: true
                )
            )
        } orElse: {
            // Do nothing
        }
    }
    
    func partialTweetCellDidPressProfileImage(_ cell: PartialTweetTableViewCell) {
        state.mapOnSuccess { paginatedBookmarks in
            let bookmark = paginatedBookmarks.page[cell.indexPath.row]
            
            navigationController?.openUserViewController(withUser: bookmark.viewables.tweet.viewables.author)
        } orElse: {
            // Do nothing
        }
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
        state.mapOnSuccess { paginatedBookmarks in
            let bookmark = paginatedBookmarks.page[cell.indexPath.row]
            
            let alert = TweetOptionsAlertController.regular()
            
            alert.interactionsHandler = self
            alert.configure(withTweet: bookmark.viewables.tweet)
            
            present(
                alert,
                animated: true
            )
        } orElse: {
            // Do nothing
        }
    }
}

extension BookmarksViewController: TweetOptionsAlertControllerInteractionsHandler {
    func tweetOptionsAlertControllerDidPressBookmark(_ controller: TweetOptionsAlertController) {
        print(#function)
    }
    
    func tweetOptionsAlertControllerDidPressFollow(_ controller: TweetOptionsAlertController) {
        print(#function)
    }
}
