//
//  SearchResultsViewController.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 04/05/22.
//

import UIKit

class SearchViewController: TXViewController {
    // Declare
    private var keyword: String!
    private var state: Result<Paginated<User>, SearchFailure> = .success(.default())
    
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
        state = .success(.default())
        tableView.reloadData()
        tableView.beginPaginating()
        
        Task {
            [weak self] in
            guard let strongSelf = self else {
                return
            }
            
            let result = await SearchProvider.shared.search(withKeyword: keyword)
            
            strongSelf.tableView.endPaginating()
            
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
            
            let cell = tableView.dequeueReusableCell(
                withIdentifier: PartialUserTableViewCell.reuseIdentifier,
                assigning: indexPath
            ) as! PartialUserTableViewCell
            
            cell.interactionsHandler = self
            cell.configure(withUser: user)
            
            return cell
        } onFailure: { failure in
            return TXTableViewCell()
        }
    }
}

// MARK: TXTableViewDelegate
extension SearchViewController: TXTableViewDelegate {
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
            
            navigationController?.openUserViewController(withUser: user)
        case .failure(_):
            // TODO: Handle failure cases
            break
        }
    }
}

// MARK: PartialUserTableViewCellInteractionsHandler
extension SearchViewController: PartialUserTableViewCellInteractionsHandler {
    func partialUserCellDidPressProfileImage(_ cell: PartialUserTableViewCell) {
        
        switch state {
        case .success(let paginated):
            let user = paginated.page[cell.indexPath.row]
            
            navigationController?.openUserViewController(withUser: user)
        case .failure(_):
            // TODO: Handle failure cases
            break
        }
    }
}
