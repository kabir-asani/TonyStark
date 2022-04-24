//
//  FeedViewController.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 16/03/22.
//

import UIKit

class FeedViewController: TXTableViewController {
    // Decalre
    private var state: Result<Paginated<Tweet>, TweetsProvider.TweetsFailure> = .success(.default())
    
    init() {
        super.init(style: .plain)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Configure
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar()
        configureTableView()
        
        populateTableViewWithFeed()
    }
    
    private func configureNavigationBar() {
        let titleImage = TXImageView(image: TXBundledImage.twitterX)
        titleImage.contentMode = .scaleAspectFit
        
        navigationItem.backButtonTitle = ""
        navigationItem.titleView = titleImage
        
        navigationItem.rightBarButtonItem = TXBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(onComposePressed(_:))
        )
    }
    
    private func configureTableView() {
        tableView.register(
            PartialTweetTableViewCell.self,
            forCellReuseIdentifier: PartialTweetTableViewCell.reuseIdentifier
        )
        
        tableView.tableHeaderView = TXView(frame: .zero)
    }
    
    // Populate
    
    // Interact
    @objc private func onComposePressed(_ sender: UIBarButtonItem) {
        let composeViewController = TXNavigationController(
            rootViewController: ComposeViewController()
        )
        
        composeViewController.modalPresentationStyle = .fullScreen
        
        present(composeViewController, animated: true)
    }
}

// MARK: UITableViewDataSource
extension FeedViewController {
    private func populateTableViewWithFeed() {
        tableView.showActivityIndicatorAtTheBottomOfTableView()
        
        Task {
            [weak self] in
            let result = await TweetsProvider.shared.tweets()
            
            self?.tableView.hideActivityIndicatorAtTheBottomOfTableView()
            
            self?.state = result
            self?.tableView.reloadData()
        }
    }
    
    override func numberOfSections(
        in tableView: UITableView
    ) -> Int {
        return 1
    }
    
    override func tableView(
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
}

// MARK: UITableViewDelegate
extension FeedViewController {
    override func tableView(
        _ tableView: UITableView,
        willDisplay cell: UITableViewCell,
        forRowAt indexPath: IndexPath
    ) {
        switch state {
        case .success(let paginated):
            if indexPath.row  == paginated.page.count - 1 {
                cell.separatorInset = .empty
            }
        default:
            break
        }
    }
    
    override func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        switch state {
        case .success(let paginated):
            let cell = tableView.dequeueReusableCellWithIndexPath(
                withIdentifier: PartialTweetTableViewCell.reuseIdentifier,
                for: indexPath
            ) as! PartialTweetTableViewCell
            
            cell.interactionsHandler = self
            cell.configure(withTweet: paginated.page[indexPath.row])
            
            return cell
        case .failure(_):
            return UITableViewCell()
        }
    }
    
    override func tableView(
        _ tableView: UITableView,
        estimatedHeightForRowAt indexPath: IndexPath
    ) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: TweetTableViewCellInteractionsHandler
extension FeedViewController: PartialTweetTableViewCellInteractionsHandler {
    func didPressLike(_ cell: PartialTweetTableViewCell) {
        print(#function)
    }
    
    func didPressComment(_ cell: PartialTweetTableViewCell) {
        let commentsViewController = CommentsViewController()
        
        let navigationController = TXNavigationController(
            rootViewController: commentsViewController
        )
        
        present(
            navigationController,
            animated: true
        )
    }
    
    func didPressProfileImage(_ cell: PartialTweetTableViewCell) {
        switch state {
        case .success(let paginated):
            let tweet = paginated.page[cell.indexPath.row]
            
            let user = tweet.author
            
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
    
    func didPressBookmarksOption(_ cell: PartialTweetTableViewCell) {
        print(#function)
    }
    
    func didPressFollowOption(_ cell: PartialTweetTableViewCell) {
        print(#function)
    }
    
    func didPressOption(_ cell: PartialTweetTableViewCell) {
        switch state {
        case .success(let paginated):
            let alert = TweetOptionsAlertViewController.regular()
            
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
