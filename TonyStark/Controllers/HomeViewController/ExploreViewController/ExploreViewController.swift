//
//  ExploreViewController.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 16/03/22.
//

import UIKit

class ExploreViewController: TXViewController {
    // Declare
    enum ExploreTableViewSection: Int, CaseIterable {
        case previousSearches
    }
    
    private var previouslySearchedKeywords: [String] = []
    
    private let tableView: TXTableView = {
        let tableView = TXTableView(
            frame: .zero,
            style: .insetGrouped
        )
        
        tableView.enableAutolayout()
        
        return tableView
    }()
    
    private let searchBar: TXSearchBar = {
        let searchBar = TXSearchBar()
        
        searchBar.enableAutolayout()
        
        return searchBar
    }()
    
    // Configure
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSubviews()
        
        configureNavigationBar()
        configureSearchBar()
        configureTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        startKeyboardAwareness()
        populateTableView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        stopKeyboardAwareness()
    }
    
    private func addSubviews() {
        view.addSubview(tableView)
    }
    
    private func configureNavigationBar() {
        navigationItem.backButtonTitle = ""
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.titleView = searchBar
        navigationItem.hidesSearchBarWhenScrolling = true
    }
    
    private func configureSearchBar() {
        searchBar.delegate = self
        searchBar.placeholder = "Search for someone"
    }
    
    private func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.tableHeaderView = .init(frame: .zero)
        tableView.keyboardDismissMode = .onDrag
        
        tableView.register(
            SearchedKeywordTableViewCell.self,
            forCellReuseIdentifier: SearchedKeywordTableViewCell.reuseIdentifier
        )
        tableView.register(
            EmptyExploreTableViewCell.self,
            forCellReuseIdentifier: EmptyExploreTableViewCell.reuseIdentifier
        )
        
        tableView.pin(
            to: view,
            byBeingSafeAreaAware: true
        )
    }
    
    // Populate
    
    // Interact
}

// MARK: TXSearchBarDelegate
extension ExploreViewController: TXSearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(
            true,
            animated: true
        )
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(
            false,
            animated: true
        )
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let keyword = searchBar.text {
            let searchResultsViewController = SearchViewController()
            
            searchResultsViewController.populate(withKeyword: keyword)
            
            navigationController?.pushViewController(
                searchResultsViewController,
                animated: true
            )
            
            searchBar.text = ""
            searchBar.resignFirstResponder()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }
}

// MARK: TXTableViewDataSource
extension ExploreViewController: TXTableViewDataSource {
    private func populateTableView() {
        Task {
            let previousSearchesResult = await SearchDataStore.shared.previouslySearchKeywords()
            
            previousSearchesResult.map { previousSearches in
                previouslySearchedKeywords = previousSearches
            } onFailure: { cause in
                previouslySearchedKeywords = []
            }
            
            tableView.reloadData()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        ExploreTableViewSection.allCases.count
    }
    
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        if previouslySearchedKeywords.isEmpty {
            return 1
        } else {
            return previouslySearchedKeywords.count
        }
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        if previouslySearchedKeywords.isEmpty {
            let cell = tableView.dequeueReusableCell(
                withIdentifier: EmptyExploreTableViewCell.reuseIdentifier,
                for: indexPath
            ) as! EmptyExploreTableViewCell
            
            return cell
        } else {
            let keyword = previouslySearchedKeywords[indexPath.row]
            
            let cell = tableView.dequeueReusableCell(
                withIdentifier: SearchedKeywordTableViewCell.reuseIdentifier,
                for: indexPath
            ) as! SearchedKeywordTableViewCell
            
            cell.configure(withKeyword: keyword)
            
            return cell
        }
    }
}

// MARK: TXTableViewDelegate
extension ExploreViewController: TXTableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        estimatedHeightForRowAt indexPath: IndexPath
    ) -> CGFloat {
        TXTableView.automaticDimension
    }
    
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        tableView.deselectRow(
            at: indexPath,
            animated: true
        )
        
        let keyword = previouslySearchedKeywords[indexPath.row]
        
        let searchResultsViewController = SearchViewController()
        
        searchResultsViewController.populate(withKeyword: keyword)
        
        navigationController?.pushViewController(
            searchResultsViewController,
            animated: true
        )
        
        searchBar.resignFirstResponder()
    }
}
