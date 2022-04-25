//
//  TweetViewController.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 26/04/22.
//

import UIKit

class TweetViewController: TXViewController {
    private var tweet: Tweet!
    
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
        
        tableView.pin(to: view)
    }
    
    // Populate
    func populate(withTweet tweet: Tweet) {
        self.tweet = tweet
    }
    
    // Interact
}

extension TweetViewController: TXTableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return 1
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIndexPath(
            withIdentifier: TweetTableViewCell.reuseIdentifier,
            for: indexPath
        ) as! TweetTableViewCell
        
        cell.configure(withTweet: tweet)
        
        return cell
    }
}

extension TweetViewController: TXTableViewDelegate {
    
}
