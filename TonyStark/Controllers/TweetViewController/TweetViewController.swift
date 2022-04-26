//
//  TweetViewController.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 26/04/22.
//

import UIKit

class TweetViewController: TXViewController {
    enum Section: Int, CaseIterable {
        case tweet
        case comments
    }
    
    private var tweet: Tweet!
    private var state: Result<Paginated<Comment>, CommentsFailure> = .success(.default())
    
    // Declare
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
        
        populateTableViewWithComments()
    }
    
    private func addSubviews() {
        view.addSubview(tableView)
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
        
        tableView.pin(to: view)
    }
    
    // Populate
    func populate(withTweet tweet: Tweet) {
        self.tweet = tweet
    }
    
    // Interact
}

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
                }
            default:
                break
            }
        }
    }
}
