//
//  FollowersViewController.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 29/04/22.
//

import UIKit

class FollowersViewController: TXViewController {
    // Declare
    private var user: User!
    private var state: Result<Paginated<User>, FollowersFailure> = .success(.default())
    
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
        navigationItem.title = "Followers"
    }
    
    private func configureTableView() {
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
    func populate(withUser user: User) {
        self.user = user
    }
    
    // Interact
}

// MARK: TXTableViewDataSource
extension FollowersViewController: TXTableViewDataSource {
    private func populateTableView() {
        Task {
            [weak self] in
            guard let strongSelf = self else {
                return
            }
            
            let result = await SocialsProvider.shared.followers()
            
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
        return state.map { success in
            return success.page.count
        } onFailure: { failure in
            return 0
        }
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        return state.map { success in
            let user = success.page[indexPath.row]
            
            let cell = tableView.dequeueReusableCellWithIndexPath(
                withIdentifier: PartialUserTableViewCell.reuseIdentifier,
                for: indexPath
            ) as! PartialUserTableViewCell
            
            cell.interactionsHandler = self
            cell.configure(withUser: user)
            
            return cell
        } onFailure: { failure in
            return UITableViewCell()
        }
    }
}

// MARK: TXTableViewDelegate
extension FollowersViewController: TXTableViewDelegate {
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

// MARK: PartialUserTableViewCellInteractionsHandler
extension FollowersViewController: PartialUserTableViewCellInteractionsHandler {
    func didPressProfileImage(_ cell: PartialUserTableViewCell) {
        switch state {
        case .success(let paginated):
            let user = paginated.page[cell.indexPath.row]
            
            if user.id == UserProvider.current.user!.id {
                navigationController?.popViewController(animated: true)
                
                let event =  HomeTabSwitchEvent(tab: HomeViewController.TabItem.user)
                
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
