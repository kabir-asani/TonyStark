//
//  BookmarksViewController.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 27/04/22.
//

import UIKit

class BookmarksViewController: TXViewController {
    private var state: Result<Paginated<Tweet>, BookmarksFailure> = .success(.default())
    
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
        
        tableView.addBufferOnHeader(withHeight: 0)
        tableView.refreshControl = refreshControl
        
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
        refreshControl.addTarget(
            self,
            action: #selector(onRefreshControllerChanged(_:)),
            for: .valueChanged
        )
    }
    
    // Populate
    
    // Interact
    @objc private func onRefreshControllerChanged(_ refreshControl: TXRefreshControl) {
        if refreshControl.isRefreshing {
            refreshControl.endRefreshing()
        } else {
            // TODO: Add refresh logic
        }
    }
}

// MARK: TXTableViewDataSource
extension BookmarksViewController: TXTableViewDataSource {
    func populateTableView() {
        Task {
            [weak self] in
            guard let strongSelf = self else {
                return
            }
            
            let result = await BookmarksDataStore.shared.bookmarks()
            
            strongSelf.state = result
            strongSelf.tableView.reloadData()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        switch state {
        case .success(let paginated):
            return paginated.page.count
        default:
            return 0
        }
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        switch state {
        case .success(let paginated):
            let cell = tableView.dequeueReusableCell(
                withIdentifier: PartialTweetTableViewCell.reuseIdentifier,
                assigning: indexPath
            ) as! PartialTweetTableViewCell
            
            let tweet = paginated.page[indexPath.row]
            
            cell.interactionsHandler = self
            cell.configure(withTweet: tweet)
            
            return cell
        default:
            return UITableViewCell()
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
        if indexPath.row == tableView.numberOfRows(inSection: 0) - 1 {
            cell.separatorInset = .leading(.infinity)
        }
    }
    
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        print(#function)
        tableView.deselectRow(
            at: indexPath,
            animated: true
        )
        
        switch state {
        case .success(let paginated):
            let tweet = paginated.page[indexPath.row]
            
            navigationController?.openTweetViewController(withTweet: tweet)
        default:
            print("default")
            break
        }
    }
}

extension BookmarksViewController: PartialTweetTableViewCellInteractionsHandler {
    func partialTweetCellDidPressLike(_ cell: PartialTweetTableViewCell) {
        print(#function)
    }
    
    func partialTweetCellDidPressComment(_ cell: PartialTweetTableViewCell) {
        switch state {
        case .success(let paginated):
            let tweet = paginated.page[cell.indexPath.row]
            
            navigationController?.openTweetViewController(
                withTweet: tweet,
                andOptions: .init(
                    autoFocus: true
                )
            )
        default:
            break
        }
    }
    
    func partialTweetCellDidPressProfileImage(_ cell: PartialTweetTableViewCell) {
        switch state {
        case .success(let paginated):
            let author = paginated.page[cell.indexPath.row].author
            
            navigationController?.openUserViewController(withUser: author)
        default:
            break
        }
    }
    
    func partialTweetCellDidPressBookmarksOption(_ cell: PartialTweetTableViewCell) {
        print(#function)
    }
    
    func partialTweetCellDidPressFollowOption(_ cell: PartialTweetTableViewCell) {
        print(#function)
    }
    
    func partialTweetCellDidPressOptions(_ cell: PartialTweetTableViewCell) {
        switch state {
        case .success(let paginated):
            let alert = TweetOptionsAlertController.regular()
            
            alert.interactionsHandler = self
            alert.configure(withTweet: paginated.page[cell.indexPath.row])
            
            present(
                alert,
                animated: true
            )
        default:
            break
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
