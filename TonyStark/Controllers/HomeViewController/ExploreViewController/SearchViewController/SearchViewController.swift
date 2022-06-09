//
//  SearchResultsViewController.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 04/05/22.
//

import UIKit

class SearchViewController: TXViewController {
    // Declare
    enum SearchTableViewSection: Int, CaseIterable {
        case search
    }
    
    private var keyword: String!
    
    private var state: State<Paginated<User>, SearchFailure> = .processing
    
    private let tableView: TXTableView = {
        let tableView = TXTableView()
        
        tableView.enableAutolayout()
        
        return tableView
    }()
    
    private let searchBar: TXSearchBar = {
        let searchBar = TXSearchBar()
        
        return searchBar
    }()
    
    // Configure
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSubviews()
        
        configureNavigationBar()
        configureSearchBar()
        configureTableView()
        
        populateTableView()
    }
    
    private func addSubviews() {
        view.addSubview(tableView)
    }
    
    private func configureNavigationBar() {
        navigationItem.backButtonTitle = ""
        navigationItem.titleView = searchBar
    }
    
    private func configureSearchBar() {
        searchBar.delegate = self
        searchBar.placeholder = "Search for someone"
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
    
    // Populate
    func populate(withKeyword keyword: String) {
        self.keyword = keyword
        searchBar.text = keyword
    }
    
    // Interact
}

// MARK: TXSearchBarDelegate
extension SearchViewController: TXSearchBarDelegate {
    func searchBar(
        _ searchBar: UISearchBar,
        textDidChange searchText: String
    ) {
        self.keyword = searchText
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        
        populateTableView()
    }
}

// MARK: TXTableViewDataSource
extension SearchViewController: TXTableViewDataSource {
    private func populateTableView() {
        Task {
            [weak self] in
            guard let strongSelf = self else {
                return
            }
            
            strongSelf.tableView.beginPaginating()
            
            let searchResult = await SearchDataStore.shared.search(withKeyword: keyword)
            
            strongSelf.tableView.endPaginating()
            
            searchResult.map { paginatedSearch in
                strongSelf.state = .success(paginatedSearch)
            } onFailure: { cause in
                strongSelf.state = .failure(cause)
            }
            
            strongSelf.tableView.reloadData()
        }
    }
    
    private func extendTableView() {
        state.mapOnlyOnSuccess { previousPaginatedSearch in
            guard let nextToken = previousPaginatedSearch.nextToken else {
                return
            }
            
            Task {
                tableView.beginPaginating()
                
                let searchResult = await SearchDataStore.shared.search(
                    withKeyword: keyword,
                    after: nextToken
                )
                
                tableView.endPaginating()
                
                searchResult.mapOnlyOnSuccess { latestPaginatedSearch in
                    let updatedPaginatedSearch = Paginated<User>(
                        page: previousPaginatedSearch.page + latestPaginatedSearch.page,
                        nextToken: latestPaginatedSearch.nextToken
                    )
                    
                    tableView.appendSepartorToLastMostVisibleCell()
                    
                    state = .success(updatedPaginatedSearch)
                    tableView.reloadData()
                }
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        SearchTableViewSection.allCases.count
    }
    
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        state.mapOnSuccess { paginatedSearch in
            paginatedSearch.page.count
        } orElse: {
            0
        }
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        state.mapOnSuccess { paginatedSearch in
            let user = paginatedSearch.page[indexPath.row]
            
            let cell = tableView.dequeueReusableCell(
                withIdentifier: PartialUserTableViewCell.reuseIdentifier,
                assigning: indexPath
            ) as! PartialUserTableViewCell
            
            cell.interactionsHandler = self
            cell.configure(withUser: user)
            
            return cell
        } orElse: {
            TXTableViewCell()
        }
    }
}

// MARK: TXTableViewDelegate
extension SearchViewController: TXTableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        willDisplay cell: UITableViewCell,
        forRowAt indexPath: IndexPath
    ) {
        if indexPath.row == tableView.numberOfRows(inSection: SearchTableViewSection.search.rawValue) - 1 {
            tableView.removeSeparatorOnCell(cell)
            
            extendTableView()
        } else {
            tableView.appendSeparatorOnCell(cell)
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
        
        state.mapOnlyOnSuccess { paginatedSearch in
            let user = paginatedSearch.page[indexPath.row]
            
            navigationController?.openUserViewController(withUser: user)
        }
    }
}

// MARK: PartialUserTableViewCellInteractionsHandler
extension SearchViewController: PartialUserTableViewCellInteractionsHandler {
    func partialUserCellDidPressProfileImage(_ cell: PartialUserTableViewCell) {
        tableView.deselectRow(
            at: cell.indexPath,
            animated: true
        )
        
        state.mapOnlyOnSuccess { paginatedSearch in
            let user = paginatedSearch.page[cell.indexPath.row]
            
            navigationController?.openUserViewController(withUser: user)
        }
    }
}
