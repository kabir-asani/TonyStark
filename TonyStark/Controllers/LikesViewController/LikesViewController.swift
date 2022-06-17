//
//  LikesViewController.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 27/04/22.
//

import UIKit

class LikesViewController: TXViewController {
    // Declare
    enum LikesTableViewSection: Int, CaseIterable {
        case likes
    }
    
    private(set) var tweet: Tweet = .default
    
    private var state: State<Paginated<Like>, LikesFailure> = .processing
    
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(
            animated
        )
        
        tableView.reloadData()
    }
    
    private func addSubviews() {
        view.addSubview(tableView)
    }
    
    private func configureNavigationBar() {
        navigationItem.title = "Likes"
        navigationItem.largeTitleDisplayMode = .never
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
    func populate(withTweet tweet: Tweet) {
        self.tweet = tweet
    }
    
    // Interact
}

// MARK: Event Listener
extension LikesViewController {
    private func configureEventListener() {
        TXEventBroker.shared.listen {
            [weak self] event in
            guard let strongSelf = self else {
                return
            }
            
            if event is RefreshedCurrentUserEvent {
                strongSelf.onCurrentUserRefreshed()
            }
        }
    }
    
    private func onCurrentUserRefreshed() {
        if let currentUser = CurrentUserDataStore.shared.user {
            state.mapOnlyOnSuccess { previousPaginatedLikes in
                let updatedPaginatedLikes = Paginated<Like>(
                    page: previousPaginatedLikes.page.map { like in
                        if like.viewables.author.id == currentUser.id {
                            let viewables = like.viewables
                            let updatedViewables = viewables.copyWith(
                                author: currentUser
                            )
                            
                            return like.copyWith(
                                viewables: updatedViewables
                            )
                        } else {
                            return like
                        }
                    },
                    nextToken: previousPaginatedLikes.nextToken
                )
                
                state = .success(updatedPaginatedLikes)
                
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
}

// MARK: TXTableViewDataSource
extension LikesViewController: TXTableViewDataSource {
    private func populateTableView() {
        Task {
            tableView.beginPaginating()
            
            let likesResult = await LikesDataStore.shared.likes(
                onTweetWithId: tweet.id
            )
            
            tableView.endPaginating()
            
            likesResult.map { paginatedLikes in
                state = .success(paginatedLikes)
            } onFailure: { cause in
                state = .failure(cause)
            }
            
            tableView.reloadData()
        }
    }
    
    private func refreshTableView() {
        Task {
            tableView.beginRefreshing()
            
            let likesResult = await LikesDataStore.shared.likes(
                onTweetWithId: tweet.id
            )
            
            tableView.endRefreshing()
            
            likesResult.map { paginatedLikes in
                state = .success(paginatedLikes)
            } onFailure: { cause in
                state = .failure(cause)
            }
            
            tableView.reloadData()
        }
    }
    
    private func extendTableView() {
        state.mapOnlyOnSuccess { previousPaginatedLikes in
            guard let nextToken = previousPaginatedLikes.nextToken else {
                return
            }
            
            Task {
                tableView.beginPaginating()
                
                let likesResult = await LikesDataStore.shared.likes(
                    onTweetWithId: tweet.id,
                    after: nextToken
                )
                
                tableView.endPaginating()
                
                likesResult.mapOnlyOnSuccess { latestPaginatedLikes in
                    let updatedPaginatedLikes = Paginated<Like>(
                        page: previousPaginatedLikes.page + latestPaginatedLikes.page,
                        nextToken: latestPaginatedLikes.nextToken
                    )
                    
                    tableView.appendSepartorToLastMostVisibleCell()
                    
                    state = .success(updatedPaginatedLikes)
                    tableView.reloadData()
                }
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        LikesTableViewSection.allCases.count
    }
    
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        state.mapOnSuccess { paginatedLikes in
            paginatedLikes.page.count
        } orElse: {
            0
        }
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        state.mapOnSuccess { paginatedLikes in
            let cell = tableView.dequeueReusableCell(
                withIdentifier: PartialUserTableViewCell.reuseIdentifier,
                for: indexPath
            ) as! PartialUserTableViewCell
            
            let like = paginatedLikes.page[indexPath.row]
            
            cell.interactionsHandler = self
            cell.configure(
                withUser: like.viewables.author
            )
            
            return cell
        } orElse: {
            TXTableViewCell()
        }
    }
}

// MARK: TXTableViewDelegate
extension LikesViewController: TXTableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        tableView.deselectRow(
            at: indexPath,
            animated: true
        )
        
        state.mapOnlyOnSuccess { paginatedLikes in
            let like = paginatedLikes.page[indexPath.row]
            
            navigationController?.openUserViewController(
                withUser: like.viewables.author
            )
        }
    }
    
    func tableView(
        _ tableView: UITableView,
        willDisplay cell: UITableViewCell,
        forRowAt indexPath: IndexPath
    ) {
        state.mapOnlyOnSuccess { paginatedLikes in
            if paginatedLikes.page.isEmpty {
                return
            }
            
            if indexPath.row == paginatedLikes.page.count - 1 {
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
extension LikesViewController: TXRefreshControlDelegate {
    func refreshControlDidChange(_ control: TXRefreshControl) {
        if control.isRefreshing {
            refreshTableView()
        }
    }
}

// MARK: PartialUserTableViewCellInteractionsHandler
extension LikesViewController: PartialUserTableViewCellInteractionsHandler {
    func partialUserCellDidPressProfileImage(
        _ cell: PartialUserTableViewCell
    ) {
        state.mapOnlyOnSuccess { paginatedLikes in
            guard let like = paginatedLikes.page.first(where: { $0.viewables.author.id == cell.user.id } ) else {
                return
            }
            
            navigationController?.openUserViewController(
                withUser: like.viewables.author
            )
        }
    }
    
    func partialUserCellDidPressPrimaryAction(
        _ cell: PartialUserTableViewCell
    ) {
        print(#function)
    }
}
