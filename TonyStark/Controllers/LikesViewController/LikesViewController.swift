//
//  LikesViewController.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 27/04/22.
//

import UIKit

class LikesViewController: TXViewController {
    private var tweet: Tweet!
    
    // Declare
    private var state: Result<Paginated<User>, LikesProvider.LikesFailure> = .success(.default())
    
    let tableView: TXTableView = {
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
    
    func addSubviews() {
        view.addSubview(tableView)
    }
    
    func configureNavigationBar() {
        navigationItem.title = "Likes"
        navigationItem.largeTitleDisplayMode = .never
    }
    
    func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.addBufferOnHeader(withHeight: 0)
        
        tableView.register(
            PartialUserTableViewCell.self,
            forCellReuseIdentifier: PartialUserTableViewCell.reuseIdentifier
        )
        
        tableView.pin(
            to: view,
            byBeingSafeAreaAware: true
        )
    }
    
    // Populate
    func populate(withTweet tweet: Tweet) {
        self.tweet = tweet
    }
    
    // Interact
}

// MARK: TXTableViewDataSource
extension LikesViewController: TXTableViewDataSource {
    private func populateTableView() {
        Task {
            [weak self] in
            guard let strongSelf = self else {
                return
            }
            
            let result = await LikesProvider.shared.likes()
            
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
            let cell = tableView.dequeueReusableCellWithIndexPath(
                withIdentifier: PartialUserTableViewCell.reuseIdentifier,
                for: indexPath
            ) as! PartialUserTableViewCell
            
            cell.interactionsHandler = self
            cell.configure(withUser: paginated.page[indexPath.row])
            
            return cell
        default:
            return UITableViewCell()
        }
    }
}

// MARK: TXTableViewDelegate
extension LikesViewController: TXTableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        willDisplay cell: UITableViewCell,
        forRowAt indexPath: IndexPath
    ) {
        switch state {
        case .success(let paginated):
            if indexPath.row  == paginated.page.count - 1 {
                cell.separatorInset = .leading(.infinity)
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
        return TXTableView.automaticDimension
    }
}

extension LikesViewController: PartialUserTableViewCellInteractionsHandler {
    func didPressProfileImage(_ cell: PartialUserTableViewCell) {
        switch state {
        case .success(let paginated):
            let user = paginated.page[cell.indexPath.row]
            
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
