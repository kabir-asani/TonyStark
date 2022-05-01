//
//  ExploreViewController.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 16/03/22.
//

import UIKit

class ExploreViewController: TXViewController {
    // Decalre
    private var state: Result<Paginated<User>, SearchProvider.SearchFailure> = .success(.default())
    
    private let searchBarController: TXSearchController = {
        let searchBarController = TXSearchController()
        
        searchBarController.extendedLayoutIncludesOpaqueBars = true
        
        return searchBarController
    }()
    
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
        configureSearchBar()
        configureTableView()
    }
    
    private func addSubviews() {
        view.addSubview(tableView)
    }
    
    private func configureNavigationBar() {
        navigationItem.title = "Explore"
        navigationItem.largeTitleDisplayMode = .never
    }
    
    private func configureSearchBar() {
        navigationItem.searchController = searchBarController
        
        searchBarController.searchResultsUpdater = self
        searchBarController.didMove(toParent: self)
    }
    
    private func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableHeaderView = .init(frame: .zero)
        
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
    
    // Interact
}

extension ExploreViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let keyword = searchController.searchBar.text else {
            return
        }
        
        if keyword.isEmpty {
            state = .success(.default())
            tableView.reloadData()
        } else {
            Task {
                [weak self] in
                guard let strongSelf = self else {
                    return
                }
        
                let result = await SearchProvider.shared.search(withKeyword: keyword)
                
                strongSelf.state = result
                strongSelf.tableView.reloadData()
            }
        }
    }
}

extension ExploreViewController: TXTableViewDataSource {
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

extension ExploreViewController: TXTableViewDelegate {
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
    
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        tableView.deselectRow(
            at: indexPath,
            animated: true
        )
        
        switch state {
        case .success(let paginated):
            let user = paginated.page[indexPath.row]
            
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

extension ExploreViewController: PartialUserTableViewCellInteractionsHandler {
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
