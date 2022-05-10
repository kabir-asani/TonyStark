//
//  TweetViewController.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 26/04/22.
//

import UIKit

class TweetViewController: TXViewController {
    struct Options {
        static func `default`() -> Options {
            .init(
                autoFocus: false
            )
        }
        
        let autoFocus: Bool
    }
    
    enum Section: Int, CaseIterable {
        case tweet
        case comments
    }
    
    private(set) var tweet: Tweet = .default()
    private var state: Result<Paginated<Comment>, CommentsFailure> = .success(.default())
    private var options: Options = .default()
    
    // Declare
    private let tableView: TXTableView = {
        let tableView = TXTableView()
        
        tableView.enableAutolayout()
        
        return tableView
    }()
    
    private let refreshControl: TXRefreshControl = {
        let refreshControl = TXRefreshControl()
        
        return refreshControl
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
        
        tableView.addBufferOnHeader(withHeight: 0)
        tableView.refreshControl = refreshControl
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
        refreshControl.addTarget(
            self,
            action: #selector(onRefreshControllerChanged(_:)),
            for: .valueChanged
        )
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
        options: Options = .default()
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
    
    @objc private func onRefreshControllerChanged(_ refreshControl: TXRefreshControl) {
        if refreshControl.isRefreshing {
            refreshControl.endRefreshing()
        } else {
            // TODO: Add refresh logic
        }
    }
}

// MARK: TXTableViewDataSource
extension TweetViewController: TXTableViewDataSource {
    private func populateTableView() {
        tableView.beginPaginating()
        
        Task {
            [weak self] in
            guard let strongSelf = self else {
                return
            }
            
            let result = await CommentsDataStore.shared.comments(ofTweetWithId: tweet.id)
            
            strongSelf.tableView.endPaginating()
            
            strongSelf.state = result
            strongSelf.tableView.reloadData()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return Section.allCases.count
    }
    
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        switch section {
        case Section.tweet.rawValue:
            return 1
        case Section.comments.rawValue:
            switch state {
            case .success(let pagingated):
                return pagingated.page.count
            default:
                return 0
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
        case Section.tweet.rawValue:
            let cell = tableView.dequeueReusableCell(
                withIdentifier: TweetTableViewCell.reuseIdentifier,
                assigning: indexPath
            ) as! TweetTableViewCell
            
            cell.interactionsHandler = self
            cell.configure(withTweet: tweet)
            
            return cell
        case Section.comments.rawValue:
            switch state {
            case .success(let paginated):
                let comment = paginated.page[indexPath.row]
                
                let cell = tableView.dequeueReusableCell(
                    withIdentifier: CommentTableViewCell.reuseIdentifer,
                    assigning: indexPath
                ) as! CommentTableViewCell
                
                cell.interactionsHandler = self
                cell.configure(withComment: comment)
                
                return cell
            default:
                return UITableViewCell()
            }
        default:
            fatalError("No other sections are present")
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
        if indexPath.row == tableView.numberOfRows(inSection: 0) - 1 {
            cell.separatorInset = .leading(.infinity)
        }
    }
}

// MARK: TweetTableViewCellInteractionsHandler
extension TweetViewController: TweetTableViewCellInteractionsHandler {
    func tweetCellDidPressProfileImage(_ cell: TweetTableViewCell) {
        let user = tweet.author
        
        navigationController?.openUserViewController(withUser: user)
    }
    
    func tweetCellDidPressProfileDetails(_ cell: TweetTableViewCell) {
        let user = tweet.author
        
        navigationController?.openUserViewController(withUser: user)
    }
    
    func tweetCellDidPressLike(_ cell: TweetTableViewCell) {
        print(#function)
    }
    
    func tweetCellDidPressLikeDetails(_ cell: TweetTableViewCell) {
        if tweet.meta.likesCount > 0 {
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
        switch state {
        case .success(let paginated):
            let comment = paginated.page[commentTableViewCell.indexPath.row]
            
            let user = comment.author
            
            navigationController?.openUserViewController(withUser: user)
        default:
            break
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
}
