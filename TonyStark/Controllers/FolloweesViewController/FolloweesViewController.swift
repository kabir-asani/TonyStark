//
//  FollowingsViewController.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 29/04/22.
//

import UIKit

class FolloweesViewController: TXViewController {
    // Declare
    enum FolloweesTableViewSection: Int, CaseIterable {
        case followees
    }
    
    private(set) var user: User = .default
    
    private var state: State<Paginated<Followee>, FollowingsFailure> = .processing
    
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
        configureRefreshControl()
        
        populateTableView()
    }
    
    private func addSubviews() {
        view.addSubview(tableView)
    }
    
    private func configureNavigationBar() {
        navigationItem.title = "Followings"
    }
    
    private func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.appendSpacerOnHeader()
        
        tableView.register(
            PartialUserTableViewCell.self,
            forCellReuseIdentifier: PartialUserTableViewCell.reuseIdentifier
        )
        
        tableView.pin(
            to: view,
            byBeingSafeAreaAware: true
        )
    }
    
    private func configureRefreshControl() {
        let refreshControl = TXRefreshControl()
        refreshControl.delegate = self
        
        tableView.refreshControl = refreshControl
    }
    
    // Populate
    func populate(withUser user: User) {
        self.user = user
    }
    
    // Interact
}

// MARK: TXTableViewDataSource
extension FolloweesViewController: TXTableViewDataSource {
    private func populateTableView() {
        Task {
            [weak self] in
            guard let strongSelf = self else {
                return
            }
            
            strongSelf.tableView.beginPaginating()
            
            let followeesResult = await SocialsDataStore.shared.followees(ofUserWithId: user.id)
            
            strongSelf.tableView.endPaginating()
            
            followeesResult.map { paginatedFollowees in
                strongSelf.state = .success(data: paginatedFollowees)
            } onFailure: { cause in
                strongSelf.state = .failure(cause: cause)
            }
            
            strongSelf.tableView.reloadData()
        }
    }
    
    private func refreshTableView() {
        Task {
            [weak self] in
            guard let strongSelf = self else {
                return
            }
            
            strongSelf.tableView.beginRefreshing()
            
            let followeesResult = await SocialsDataStore.shared.followees(ofUserWithId: user.id)
            
            strongSelf.tableView.endRefreshing()
            
            followeesResult.map { paginatedFollowees in
                strongSelf.state = .success(data: paginatedFollowees)
            } onFailure: { cause in
                strongSelf.state = .failure(cause: cause)
            }
            
            strongSelf.tableView.reloadData()
        }
    }
    
    private func extendTableView() {
        state.mapOnSuccess { previousPaginatedFollowees in
            guard let nextToken = previousPaginatedFollowees.nextToken else {
                return
            }
            
            Task {
                [weak self] in
                guard let strongSelf = self else {
                    return
                }
                
                strongSelf.tableView.beginPaginating()
                
                let followeesResult = await SocialsDataStore.shared.followees(
                    ofUserWithId: user.id,
                    after: nextToken
                )
                
                strongSelf.tableView.endPaginating()
                
                followeesResult.map { latestPaginatedFollowees in
                    let updatedPaginatedFollowees = Paginated<Followee>(
                        page: previousPaginatedFollowees.page + latestPaginatedFollowees.page,
                        nextToken: latestPaginatedFollowees.nextToken
                    )
                    
                    strongSelf.tableView.appendSepartorToLastMostVisibleCell()
                    
                    strongSelf.state = .success(data: updatedPaginatedFollowees)
                    strongSelf.tableView.reloadData()
                } onFailure: { cause in
                    // TODO: Communicate via SnackBar
                }
            }
        } orElse: {
            // Do nothing
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        FolloweesTableViewSection.allCases.count
    }
    
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        state.mapOnSuccess { paginatedFollowees in
            paginatedFollowees.page.count
        } orElse: {
            0
        }
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        state.mapOnSuccess { paginatedFollowees in
            let followee = paginatedFollowees.page[indexPath.row]
            
            let cell = tableView.dequeueReusableCell(
                withIdentifier: PartialUserTableViewCell.reuseIdentifier,
                assigning: indexPath
            ) as! PartialUserTableViewCell
            
            cell.interactionsHandler = self
            cell.configure(withUser: followee.user)
            
            return cell
        } orElse: {
            UITableViewCell()
        }
    }
    
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        tableView.deselectRow(
            at: indexPath,
            animated: true
        )
        
        state.mapOnSuccess { paginatedFollowees in
            let followee = paginatedFollowees.page[indexPath.row]
            
            navigationController?.openUserViewController(withUser: followee.user)
        } orElse: {
            // Do nothing
        }
    }
}

// MARK: TXTableViewDelegate
extension FolloweesViewController: TXTableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        willDisplay cell: UITableViewCell,
        forRowAt indexPath: IndexPath
    ) {
        if indexPath.row == tableView.numberOfRows(inSection: 0) - 1 {
            tableView.removeSeparatorOnCell(cell)
            
            extendTableView()
        } else {
            tableView.appendSeparatorOnCell(cell)
        }
    }
    
    func tableView(
        _ tableView: UITableView,
        estimatedHeightForRowAt indexPath: IndexPath
    ) -> CGFloat {
        TXTableView.automaticDimension
    }
}

extension FolloweesViewController: TXRefreshControlDelegate {
    func refreshControlDidChange(_ control: TXRefreshControl) {
        if control.isRefreshing {
            refreshTableView()
        }
    }
}

// MARK: PartialUserTableViewCellInteractionsHandler
extension FolloweesViewController: PartialUserTableViewCellInteractionsHandler {
    func partialUserCellDidPressProfileImage(_ cell: PartialUserTableViewCell) {
        state.mapOnSuccess { paginatedFollowees in
            let followee = paginatedFollowees.page[cell.indexPath.row]
            
            navigationController?.openUserViewController(withUser: followee.user)
        } orElse: {
            // Do nothing
        }
    }
}
