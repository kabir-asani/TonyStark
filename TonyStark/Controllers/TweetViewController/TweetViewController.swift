//
//  TweetViewController.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 26/04/22.
//

import UIKit

struct TweetViewControllerOptions {
    static var `default`: TweetViewControllerOptions {
        TweetViewControllerOptions(
            autoFocus: false
        )
    }
    
    let autoFocus: Bool
}

class TweetViewController: TXViewController {
    enum Section: Int, CaseIterable {
        case tweet
        case comments
    }
    
    private var tweet: Tweet!
    private var state: Result<Paginated<Comment>, CommentsFailure> = .success(.default())
    private var options: TweetViewControllerOptions!
    
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
        configureCommentInputBar()
        configureSeparator()
        configureBottomInputBar()
        
        populateTableViewWithComments()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        addKeyboardListenersToAdjustConstraintsOnBottomMostView()
        
        tabBarController?.tabBar.clipsToBounds = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        removeKeyboardListeners()
        
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
    }
    
    private func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableHeaderView = TXView(frame: .zero)
        
        tableView.register(
            TweetTableViewCell.self,
            forCellReuseIdentifier: TweetTableViewCell.reuseIdentifier
        )
        
        tableView.register(
            CommentTableViewCell.self,
            forCellReuseIdentifier: CommentTableViewCell.reuseIdentifer
        )
        
        tableView.keyboardDismissMode = .onDrag
        
        tableView.pin(toTopOf: view, byBeingSafeAreaAware: true)
        tableView.pin(toLeftOf: view, byBeingSafeAreaAware: true)
        tableView.pin(toRightOf: view, byBeingSafeAreaAware: true)
        tableView.attach(bottomToTopOf: bottomInputBar, byBeingSafeAreaAware: true)
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
        
        separator.pin(toRightOf: bottomInputBar, byBeingSafeAreaAware: true)
        separator.pin(toLeftOf: bottomInputBar, byBeingSafeAreaAware: true)
    }
    
    private func configureBottomInputBar() {
        bottomInputBar.fixHeight(to: 50)
        bottomInputBar.pin(toRightOf: view, byBeingSafeAreaAware: true)
        bottomInputBar.pin(toLeftOf: view, byBeingSafeAreaAware: true)
        bottomInputBar.pin(
            toBottomOf: view,
            byBeingSafeAreaAware: true
        )
    }
    
    // Populate
    func populate(
        withTweet tweet: Tweet,
        options: TweetViewControllerOptions = .default
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
    private func populateTableViewWithComments() {
        tableView.showActivityIndicatorAtTheBottomOfTableView()
        
        Task {
            [weak self] in
            guard let strongSelf = self else {
                return
            }
            
            let result = await CommentsProvider.shared.comments()
            
            strongSelf.tableView.hideActivityIndicatorAtTheBottomOfTableView()
            
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
            let cell = tableView.dequeueReusableCellWithIndexPath(
                withIdentifier: TweetTableViewCell.reuseIdentifier,
                for: indexPath
            ) as! TweetTableViewCell
            
            cell.configure(withTweet: tweet)
            
            return cell
        case Section.comments.rawValue:
            switch state {
            case .success(let paginated):
                let comment = paginated.page[indexPath.row]
                
                let cell = tableView.dequeueReusableCellWithIndexPath(
                    withIdentifier: CommentTableViewCell.reuseIdentifer,
                    for: indexPath
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
        if indexPath.section == Section.comments.rawValue {
            switch state {
            case .success(let paginated):
                if indexPath.row  == paginated.page.count - 1 {
                    cell.separatorInset = .empty
                } else {
                    cell.separatorInset = .leading(20)
                }
            default:
                break
            }
        }
    }
}

extension TweetViewController: CommentTableViewCellInteractionsHandler {
    func didPressProfileImage(_ commentTableViewCell: CommentTableViewCell) {
        switch state {
        case .success(let paginated):
            let comment = paginated.page[commentTableViewCell.indexPath.row]
            
            let user = comment.author
            
            if user.id == UserProvider.current.user.id {
                navigationController?.popViewController(animated: true)
                
                let event =  HomeViewTabSwitchEvent(tab: HomeViewController.TabItem.user)
                
                TXEventBroker.shared.emit(event: event)
            } else {
                let otherUserViewController = OtherUserViewController()
                
                otherUserViewController.populate(withUser: user)
                
                navigationController?.pushViewController(
                    otherUserViewController,
                    animated: true
                )
            }
        default:
            break
        }
    }
}
