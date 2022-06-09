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
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if options.autoFocus {
            commentInputBar.focusTextField()
        }
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
            [weak self] in
            guard let strongSelf = self else {
                return
            }
            
            strongSelf.tableView.beginPaginating()
            
            let commentsResult = await CommentsDataStore.shared.comments(ofTweetWithId: tweet.id)
            
            strongSelf.tableView.endPaginating()
            
            commentsResult.map { paginatedComments in
                strongSelf.state = .success(paginatedComments)
            } onFailure: { cause in
                strongSelf.state = .failure(cause)
            }
            
            strongSelf.tableView.reloadData()
        }
    }
    
    private func refreshTableView() {
        Task {
            [weak self] in
            guard let strongSelf = self else {
                return
            }
            
            strongSelf.tableView.beginRefreshing()
            
            let commentsResult = await CommentsDataStore.shared.comments(ofTweetWithId: tweet.id)
            
            strongSelf.tableView.endRefreshing()
            
            commentsResult.map { paginatedComments in
                strongSelf.state = .success(paginatedComments)
            } onFailure: { cause in
                strongSelf.state = .failure(cause)
            }
            
            strongSelf.tableView.reloadData()
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
                    ofTweetWithId: tweet.id,
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
                assigning: indexPath
            ) as! TweetTableViewCell
            
            cell.interactionsHandler = self
            cell.configure(withTweet: tweet)
            
            return cell
        case TweetsTableViewSection.comments.rawValue:
            return state.mapOnSuccess { paginatedComments in
                let comment = paginatedComments.page[indexPath.row]
                
                let cell = tableView.dequeueReusableCell(
                    withIdentifier: CommentTableViewCell.reuseIdentifer,
                    assigning: indexPath
                ) as! CommentTableViewCell
                
                cell.interactionsHandler = self
                cell.configure(withComment: comment)
                
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
        if indexPath.row == tableView.numberOfRows(inSection: TweetsTableViewSection.comments.rawValue) - 1 {
            tableView.removeSeparatorOnCell(cell)
            
            extendTableView()
        } else {
            tableView.appendSeparatorOnCell(cell)
        }
    }
}

// MARK: TweetTableViewCellInteractionsHandler
extension TweetViewController: TweetTableViewCellInteractionsHandler {
    func tweetCellDidPressProfileImage(_ cell: TweetTableViewCell) {
        let user = tweet.viewables.author
        
        navigationController?.openUserViewController(withUser: user)
    }
    
    func tweetCellDidPressProfileDetails(_ cell: TweetTableViewCell) {
        let user = tweet.viewables.author
        
        navigationController?.openUserViewController(withUser: user)
    }
    
    func tweetCellDidPressLike(_ cell: TweetTableViewCell) {
        print(#function)
    }
    
    func tweetCellDidPressLikeDetails(_ cell: TweetTableViewCell) {
        if tweet.interactionDetails.likesCount > 0 {
            let likesViewController = LikesViewController()
            
            likesViewController.populate(withTweet: tweet)
            
            navigationController?.pushViewController(
                likesViewController,
                animated: true
            )
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
    
    func tweetCellDidPressBookmarkOption(_ cell: TweetTableViewCell) {
        print(#function)
    }
    
    func tweetCellDidPressFollowOption(_ cell: TweetTableViewCell) {
        print(#function)
    }
}

// MARK: CommentTableViewCellInteractionsHandler
extension TweetViewController: CommentTableViewCellInteractionsHandler {
    func commentCellDidPressProfileImage(_ commentTableViewCell: CommentTableViewCell) {
        state.mapOnlyOnSuccess { paginatedComments in
            let comment = paginatedComments.page[commentTableViewCell.indexPath.row]
            
            let user = comment.viewables.author
            
            navigationController?.openUserViewController(withUser: user)
        }
    }
}

// MARK:
extension TweetViewController: TweetOptionsAlertControllerInteractionsHandler {
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
