//
//  FeedViewController.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 16/03/22.
//

import UIKit

class FeedViewController: TXViewController {
    // Decalre
    private var state: Result<Paginated<Tweet>, TweetsProvider.TweetsFailure> = .success(.default())
    
    private let tableView: TXTableView = {
        let tableView = TXTableView()
        
        tableView.enableAutolayout()
        
        return tableView
    }()
    
    private let floatingActionButton: TXButton = {
        let floatingActionButton = TXButton()
        
        floatingActionButton.enableAutolayout()
        floatingActionButton.squareOff(withSide: 60)
        floatingActionButton.backgroundColor = .systemBlue
        floatingActionButton.tintColor = .white
        floatingActionButton.layer.cornerRadius = 30
        floatingActionButton.clipsToBounds = true
        floatingActionButton.setImage(
            UIImage(systemName: "plus"),
            for: .normal
        )
        
        return floatingActionButton
    }()
    
    // Configure
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSubviews()
        
        configureNavigationBar()
        configureTableView()
        configureFloatingActionButton()
        
        populateTableViewWithFeed()
    }
    
    private func addSubviews() {
        view.addSubview(tableView)
        view.addSubview(floatingActionButton)
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
        
        tableView.register(
            PartialTweetTableViewCell.self,
            forCellReuseIdentifier: PartialTweetTableViewCell.reuseIdentifier
        )
        
        tableView.tableHeaderView = TXView(frame: .zero)
        
        tableView.pin(to: view)
    }
    
    private func configureFloatingActionButton() {
        floatingActionButton.pin(
            toBottomOf: view,
            withInset: 20,
            byBeingSafeAreaAware: true
        )
        
        floatingActionButton.pin(
            toRightOf: view,
            withInset: 20,
            byBeingSafeAreaAware: true
        )
        
        floatingActionButton.addTarget(
            self,
            action: #selector(onComposePressed(_:)),
            for: .touchUpInside
        )
    }
    
    // Populate
    
    // Interact
    @objc private func onComposePressed(_ sender: UITapGestureRecognizer) {
        let composeViewController = TXNavigationController(
            rootViewController: ComposeViewController()
        )
        
        composeViewController.modalPresentationStyle = .fullScreen
        
        present(composeViewController, animated: true)
    }
}

// MARK: TXTableViewDataSource
extension FeedViewController: TXTableViewDataSource {
    private func populateTableViewWithFeed() {
        tableView.showActivityIndicatorAtTheBottomOfTableView()
        
        Task {
            [weak self] in
            guard let strongSelf = self else {
                return
            }
            
            let result = await TweetsProvider.shared.tweets()
            
            strongSelf.tableView.hideActivityIndicatorAtTheBottomOfTableView()
            
            strongSelf.state = result
            strongSelf.tableView.reloadData()
        }
    }
    
    func numberOfSections(
        in tableView: UITableView
    ) -> Int {
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
            let cell = tableView.dequeueReusableCellWithIndexPath(
                withIdentifier: PartialTweetTableViewCell.reuseIdentifier,
                for: indexPath
            ) as! PartialTweetTableViewCell
            
            cell.interactionsHandler = self
            cell.configure(withTweet: paginated.page[indexPath.row])
            
            return cell
        default:
            return UITableViewCell()
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
    
    func tableView(
        _ tableView: UITableView,
        estimatedHeightForRowAt indexPath: IndexPath
    ) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch state {
        case .success(let paginated):
            let tweet = paginated.page[indexPath.row]
            
            let tweetViewController = TweetViewController()
            
            tweetViewController.populate(withTweet: tweet)
            
            navigationController?.pushViewController(
                tweetViewController,
                animated: true
            )
        default:
            break
        }
    }
}

// MARK: TweetTableViewCellInteractionsHandler
extension FeedViewController: PartialTweetTableViewCellInteractionsHandler {
    func didPressLike(_ cell: PartialTweetTableViewCell) {
        print(#function)
    }
    
    func didPressComment(_ cell: PartialTweetTableViewCell) {
        switch state {
        case .success(let paginated):
            let tweet = paginated.page[cell.indexPath.row]
            
            let tweetViewController = TweetViewController()
            
            tweetViewController.populate(
                withTweet: tweet,
                options: TweetViewControllerOptions(
                    autoFocus: true
                )
            )
            
            navigationController?.pushViewController(
                tweetViewController,
                animated: true
            )
        default:
            break
        }
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
