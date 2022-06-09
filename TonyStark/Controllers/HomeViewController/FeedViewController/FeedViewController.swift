//
//  FeedViewController.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 16/03/22.
//

import UIKit

class FeedViewController: TXViewController {
    // Declare
    enum FeedTableViewSection: Int, CaseIterable {
        case tweets = 0
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
        configureFloatingActionButton()
        
        populateTableView()
    }
    
    private func configureEventListener() {
        TXEventBroker.shared.listen {
            [weak self] event in
            guard let strongSelf = self else {
                return
            }
            
            if event is TweetCreatedEvent {
                strongSelf.onTweetCreated()
            }
            
            if let event = event as? TweetDeletedEvent {
                strongSelf.onTweetDeleted(
                    withId: event.id
                )
            }
        }
    }
    
    private func addSubviews() {
        view.addSubview(tableView)
        view.addSubview(floatingButton)
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
    
    private func configureFloatingActionButton() {
        floatingButton.pin(
            toBottomOf: view,
            withInset: 20,
            byBeingSafeAreaAware: true
        )
        
        floatingButton.pin(
            toRightOf: view,
            withInset: 20,
            byBeingSafeAreaAware: true
        )
        
        floatingButton.addTarget(
            self,
            action: #selector(onComposePressed(_:)),
            for: .touchUpInside
        )
    }
    
    // Populate
    
    // Interact
    @objc private func onComposePressed(_ sender: UITapGestureRecognizer) {
        navigationController?.openComposeViewController()
    }
    
    private func onTweetCreated() {
        refreshTableView()
    }
    
    private func onTweetDeleted(withId id: String) {
        refreshTableView()
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
                    tableView.appendSpacerOnFooter()
                    
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
        state.mapOnSuccess { paginatedFeed in
            return paginatedFeed.page.count > 0
            ? paginatedFeed.page.count
            : 1
        } orElse: {
            0
        }
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        state.mapOnSuccess { paginatedFeed in
            if paginatedFeed.page.count > 0 {
                let cell = tableView.dequeueReusableCell(
                    withIdentifier: PartialTweetTableViewCell.reuseIdentifier,
                    assigning: indexPath
                ) as! PartialTweetTableViewCell
                
                cell.interactionsHandler = self
                cell.configure(withTweet: paginatedFeed.page[indexPath.row])
                
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(
                    withIdentifier: EmptyFeedTableViewCell.reuseIdentifier,
                    assigning: indexPath
                ) as! EmptyFeedTableViewCell
                
                return cell
            }
        } orElse: {
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
        if indexPath.row == tableView.numberOfRows(inSection: FeedTableViewSection.tweets.rawValue) - 1 {
            tableView.removeSeparatorOnCell(cell)
            
            extendTableView()
        } else {
            tableView.appendSeparatorOnCell(cell)
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
            if paginatedFeed.page.count > 0 {
                let tweet = paginatedFeed.page[indexPath.row]
                
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
extension FeedViewController: TXRefreshControlDelegate {
    func refreshControlDidChange(_ control: TXRefreshControl) {
        if control.isRefreshing {
            refreshTableView()
        }
    }
}

// MARK: TweetTableViewCellInteractionsHandler
extension FeedViewController: PartialTweetTableViewCellInteractionsHandler {
    func partialTweetCellDidPressLike(_ cell: PartialTweetTableViewCell) {
        print(#function)
    }
    
    func partialTweetCellDidPressComment(_ cell: PartialTweetTableViewCell) {
        state.mapOnlyOnSuccess { paginatedFeed in
            let tweet = paginatedFeed.page[cell.indexPath.row]
            
            navigationController?.openTweetViewController(
                withTweet: tweet,
                andOptions: .init(
                    autoFocus: true
                )
            )
        }
    }
    
    func partialTweetCellDidPressProfileImage(_ cell: PartialTweetTableViewCell) {
        state.mapOnlyOnSuccess { paginatedFeed in
            let tweet = paginatedFeed.page[cell.indexPath.row]
            
            let user = tweet.viewables.author
            
            navigationController?.openUserViewController(withUser: user)
        }
    }
    
    func partialTweetCellDidPressBookmarksOption(_ cell: PartialTweetTableViewCell) {
        print(#function)
    }
    
    func partialTweetCellDidPressFollowOption(_ cell: PartialTweetTableViewCell) {
        print(#function)
    }
    
    func partialTweetCellDidPressDeleteOption(_ cell: PartialTweetTableViewCell) {
        state.mapOnlyOnSuccess { paginatedFeed in
            Task {
                cell.prepareForDelete()
                
                let tweetDeletionResult = await TweetsDataStore.shared.deleteTweet(
                    withId: paginatedFeed.page[cell.indexPath.row].id
                )
                
                tweetDeletionResult.mapOnlyOnFailure { failure in
                    cell.revertPreparationsDoneForDelete()
                    showUnknownFailureSnackBar()
                }
            }
            return
        }
    }
    
    func partialTweetCellDidPressOptions(_ cell: PartialTweetTableViewCell) {
        state.mapOnlyOnSuccess { paginatedFeed in
            let alert = TweetOptionsAlertController.regular()
            
            alert.interactionsHandler = self
            alert.configure(withTweet: paginatedFeed.page[cell.indexPath.row])
            
            present(
                alert,
                animated: true
            )
        }
    }
}

// MARK: TweetOptionsAlertViewControllerInteractionsHandler
extension FeedViewController: TweetOptionsAlertControllerInteractionsHandler {
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
