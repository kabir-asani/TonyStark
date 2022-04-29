//
//  OtherUserViewController.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 23/04/22.
//

import UIKit

class OtherUserViewController: TXViewController {
    enum Section: Int, CaseIterable {
        case profile
        case tweets
    }
    
    // Declare
    private var user: User!
    private var state: Result<Paginated<Tweet>, TweetsProvider.TweetsFailure> = .success(.default())
    
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
        
        populateTableView()
    }
    
    private func addSubviews() {
        view.addSubview(tableView)
    }
    
    private func configureNavigationBar() {
        navigationItem.backButtonTitle = ""
        navigationItem.largeTitleDisplayMode = .never
    }
    
    private func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.tableHeaderView = TXView(frame: .zero)
        
        tableView.register(
            OtherUserTableViewCell.self,
            forCellReuseIdentifier: OtherUserTableViewCell.reuseIdentifier
        )
        
        tableView.register(
            PartialTweetTableViewCell.self,
            forCellReuseIdentifier: PartialTweetTableViewCell.reuseIdentifier
        )
        
        tableView.pin(to: view)
    }
    
    // Populate
    func populate(withUser user: User) {
        self.user = user
    }
    
    // Interact
}

// MARK: TXScrollViewDelegate
extension OtherUserViewController: TXScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentYOffset = scrollView.contentOffset.y
        
        if currentYOffset < 40 {
            navigationItem.title = nil
        }
        
        if currentYOffset > 40 && navigationItem.title == nil {
            navigationItem.title = user.name
        }
    }
}

// MARK: TXTableViewDataSource
extension OtherUserViewController: TXTableViewDataSource {
    func populateTableView() {
        Task {
            [weak self] in
            guard let strongSelf = self else {
                return
            }
            
            let result = await TweetsProvider.shared.tweets(of: user.id)
            
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
        case Section.profile.rawValue:
            return 1
        case Section.tweets.rawValue:
            return state.map { success in
                success.page.count
            } onFailure: { failure in
                0
            }
        default:
            fatalError("Only two sections can exists. Something has gone wrong.")
        }
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        switch indexPath.section {
        case Section.profile.rawValue:
            let cell = tableView.dequeueReusableCellWithIndexPath(
                withIdentifier: OtherUserTableViewCell.reuseIdentifier,
                for: indexPath
            ) as! OtherUserTableViewCell
            
            cell.interactionsHandler = self
            cell.configure(withUser: user)
            
            return cell
            
        case Section.tweets.rawValue:
            return state.map { success in
                let cell = tableView.dequeueReusableCellWithIndexPath(
                    withIdentifier: PartialTweetTableViewCell.reuseIdentifier,
                    for: indexPath
                ) as! PartialTweetTableViewCell
                
                let tweet = success.page[indexPath.row]
                
                cell.configure(withTweet: tweet)
                
                return cell
            } onFailure: { failure in
                return UITableViewCell()
            }
            
        default:
            fatalError("Only two sections can exists. Something has gone wrong.")
        }
    }
}

// MARK: TXTableViewDelegate
extension OtherUserViewController: TXTableViewDelegate {
    
}

extension OtherUserViewController: OtherUserTableViewCellInteractionsHandler {
    func didPressFollow(_ cell: OtherUserTableViewCell) {
        
    }
    
    func didPressFollowers(_ cell: OtherUserTableViewCell) {
        let followersViewController = FollowersViewController()
        
        followersViewController.populate(
            withUser: UserProvider.current.user
        )
        
        navigationController?.pushViewController(
            followersViewController, animated: true
        )
    }
    
    func didPressFollowings(_ cell: OtherUserTableViewCell) {
        let followingsViewController = FollowingsViewController()
        
        followingsViewController.populate(
            withUser: UserProvider.current.user
        )
        
        navigationController?.pushViewController(
            followingsViewController, animated: true
        )
    }
}
