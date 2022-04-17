//
//  FeedViewController.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 16/03/22.
//

import UIKit


class FeedViewController: TXTableViewController {
    private var state: Result<Paginated<Tweet>, TweetsProviderFailure> = .success(Paginated<Tweet>.empty())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar()
        configureTableView()
        
        populateTableViewWithFeed()
    }
    
    private func configureNavigationBar() {
        navigationItem.title = "TwitterX"
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationItem.rightBarButtonItem = TXBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(onComposePressed(_:))
        )
    }
    
    private func configureTableView() {
        tableView.register(
            TweetTableViewCell.self,
            forCellReuseIdentifier: TweetTableViewCell.reuseIdentifier
        )
    }
    
    @objc private func onComposePressed(_ sender: UIBarButtonItem) {
        let composeViewController = TXNavigationController(
            rootViewController: ComposeViewController(style: .insetGrouped)
        )
        
        composeViewController.modalPresentationStyle = .fullScreen
        
        present(composeViewController, animated: true)
    }
}

// MARK: UITableViewDataSource
extension FeedViewController {
    private func showActivityIndicator() {
        DispatchQueue.main.async {
            [weak self] in
            let activityIndicator = UIActivityIndicatorView(
                frame: CGRect(
                    x: 0,
                    y: 0,
                    width: 80,
                    height: 80
                )
            )
            
            activityIndicator.startAnimating()
            
            self?.tableView.tableFooterView = activityIndicator
        }
    }
    
    private func hideActivityIndicator() {
        DispatchQueue.main.async {
            [weak self] in
            self?.tableView.tableFooterView = nil
        }
    }
    
    private func populateTableViewWithFeed() {
        showActivityIndicator()
        
        Task {
            [weak self] in
            let result = await TweetsProvider.shared.tweets()
            
            self?.hideActivityIndicator()
            
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
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        switch state {
        case .success(result: let paginated):
            let cell = tableView.dequeueReusableCell(
                withIdentifier: TweetTableViewCell.reuseIdentifier,
                for: indexPath
            ) as! TweetTableViewCell
            
            cell.populate(with: paginated.page[indexPath.row])
            
            return cell
        default:
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
