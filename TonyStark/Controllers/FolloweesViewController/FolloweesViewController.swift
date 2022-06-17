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
        
        configureEventListener()
        
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
            tableView.beginPaginating()
            
            let followeesResult = await SocialsDataStore.shared.followees(ofUserWithId: user.id)
            
            tableView.endPaginating()
            
            followeesResult.map { paginatedFollowees in
                state = .success(paginatedFollowees)
            } onFailure: { cause in
                state = .failure(cause)
            }
            
            tableView.reloadData()
        }
    }
    
    private func refreshTableView() {
        Task {
            tableView.beginRefreshing()
            
            let followeesResult = await SocialsDataStore.shared.followees(ofUserWithId: user.id)
            
            tableView.endRefreshing()
            
            followeesResult.map { paginatedFollowees in
                state = .success(paginatedFollowees)
            } onFailure: { cause in
                state = .failure(cause)
            }
            
            tableView.reloadData()
        }
    }
    
    private func extendTableView() {
        state.mapOnlyOnSuccess { previousPaginatedFollowees in
            guard let nextToken = previousPaginatedFollowees.nextToken else {
                return
            }
            
            Task {
                tableView.beginPaginating()
                
                let followeesResult = await SocialsDataStore.shared.followees(
                    ofUserWithId: user.id,
                    after: nextToken
                )
                
                tableView.endPaginating()
                
                followeesResult.mapOnlyOnSuccess { latestPaginatedFollowees in
                    let updatedPaginatedFollowees = Paginated<Followee>(
                        page: previousPaginatedFollowees.page + latestPaginatedFollowees.page,
                        nextToken: latestPaginatedFollowees.nextToken
                    )
                    
                    tableView.appendSepartorToLastMostVisibleCell()
                    
                    state = .success(updatedPaginatedFollowees)
                    tableView.reloadData()
                }
            }
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
                for: indexPath
            ) as! PartialUserTableViewCell
            
            cell.interactionsHandler = self
            cell.configure(
                withUser: followee.viewables.followee
            )
            
            return cell
        } orElse: {
            TXTableViewCell()
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
        
        state.mapOnlyOnSuccess { paginatedFollowees in
            let followee = paginatedFollowees.page[indexPath.row]
            
            navigationController?.openUserViewController(
                withUser: followee.viewables.followee
            )
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
        state.mapOnlyOnSuccess { paginatedUsers in
            if paginatedUsers.page.isEmpty {
                return
            }
            
            if indexPath.row == paginatedUsers.page.count - 1 {
                extendTableView()
            }
        }
    }
    
    func tableView(
        _ tableView: UITableView,
        estimatedHeightForRowAt indexPath: IndexPath
    ) -> CGFloat {
        TXTableView.automaticDimension
    }
}

// MARK: TXRefreshControlDelegate
extension FolloweesViewController: TXRefreshControlDelegate {
    func refreshControlDidChange(_ control: TXRefreshControl) {
        if control.isRefreshing {
            refreshTableView()
        }
    }
}

// MARK: PartialUserTableViewCellInteractionsHandler
extension FolloweesViewController: PartialUserTableViewCellInteractionsHandler {
    func partialUserCellDidPressProfileImage(
        _ cell: PartialUserTableViewCell
    ) {
        state.mapOnlyOnSuccess { paginatedFollowees in
            guard let followee = paginatedFollowees.page.first(where: { $0.viewables.followee.id == cell.user.id }) else {
                return
            }
            
            navigationController?.openUserViewController(
                withUser: followee.viewables.followee
            )
        }
    }
    
    func partialUserCellDidPressPrimaryAction(
        _ cell: PartialUserTableViewCell
    ) {
        if cell.user.id == CurrentUserDataStore.shared.user?.id {
            navigationController?.openUserViewController(
                withUser: cell.user
            )
        } else {
            if cell.user.viewables.following {
                onSomeoneUnfollowed(
                    withId: cell.user.id
                )
            } else {
                onSomeoneFollowed(
                    withId: cell.user.id
                )
            }
            
            Task {
                if cell.user.viewables.following {
                    let unfollowResult = await SocialsDataStore.shared.unfollow(
                        userWithId: cell.user.id
                    )
                    
                    unfollowResult.mapOnlyOnFailure { failure in
                        showUnknownFailureSnackBar()
                        onSomeoneFollowed(
                            withId: cell.user.id
                        )
                    }
                } else {
                    let followResult = await SocialsDataStore.shared.follow(
                        userWithId: cell.user.id
                    )
                    
                    followResult.mapOnlyOnFailure { failure in
                        showUnknownFailureSnackBar()
                        onSomeoneUnfollowed(
                            withId: cell.user.id
                        )
                    }
                }
            }
        }
    }
}

// MARK: EventListener
extension FolloweesViewController {
    private func configureEventListener() {
        TXEventBroker.shared.listen {
            [weak self] event in
            guard let strongSelf = self else {
                return
            }
            
            if let event = event as? FollowCreatedEvent {
                strongSelf.onSomeoneFollowed(
                    withId: event.userId
                )
            }
            
            if let event = event as? FollowDeletedEvent {
                strongSelf.onSomeoneUnfollowed(
                    withId: event.userId
                )
            }
        }
    }
    
    private func onSomeoneFollowed(
        withId id: String
    ) {
        state.mapOnlyOnSuccess { previousPaginatedFollowees in
            let updatedPaginatedFollowees = previousPaginatedFollowees.copyWith(
                page: previousPaginatedFollowees.page.map { followee in
                    let user = followee.viewables.followee
                    
                    if user.id != id || user.viewables.following {
                        return followee
                    }
                    
                    let viewables = user.viewables
                    
                    let updatedViewables = viewables.copyWith(
                        following: true
                    )
                    
                    let socialDetails = user.socialDetails
                    let updatedSocialDetails = socialDetails.copyWith(
                        followersCount: socialDetails.followersCount + 1
                    )
                    
                    let updatedUser = user.copyWith(
                        socialDetails: updatedSocialDetails,
                        viewables: updatedViewables
                    )
                    
                    return followee.copyWith(
                        viewables: followee.viewables.copyWith(
                            followee: updatedUser
                        )
                    )
                }
            )
            
            state = .success(updatedPaginatedFollowees)
            
            DispatchQueue.main.asyncAfter(
                deadline: .now() + 0.1
            ) {
                [weak self] in
                guard let strongSelf = self, strongSelf.tableView.window != nil else {
                    return
                }
                
                strongSelf.tableView.reloadData()
            }
        }
    }
    
    private func onSomeoneUnfollowed(
        withId id: String
    ) {
        state.mapOnlyOnSuccess { previousPaginatedFollowees in
            let updatedPaginatedFollowees = previousPaginatedFollowees.copyWith(
                page: previousPaginatedFollowees.page.map { followee in
                    let user = followee.viewables.followee
                    
                    if user.id != id || !user.viewables.following {
                        return followee
                    }
                    
                    let viewables = user.viewables
                    
                    let updatedViewables = viewables.copyWith(
                        following: false
                    )
                    
                    let socialDetails = user.socialDetails
                    let updatedSocialDetails = socialDetails.copyWith(
                        followersCount: socialDetails.followersCount - 1
                    )
                    
                    let updatedUser = user.copyWith(
                        socialDetails: updatedSocialDetails,
                        viewables: updatedViewables
                    )
                    
                    return followee.copyWith(
                        viewables: followee.viewables.copyWith(
                            followee: updatedUser
                        )
                    )
                }
            )
            
            state = .success(updatedPaginatedFollowees)
            
            DispatchQueue.main.asyncAfter(
                deadline: .now() + 0.1
            ) {
                [weak self] in
                guard let strongSelf = self, strongSelf.tableView.window != nil else {
                    return
                }
                
                strongSelf.tableView.reloadData()
            }
        }
    }
}
