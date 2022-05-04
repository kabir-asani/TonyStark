//
//  ExploreViewController.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 16/03/22.
//

import UIKit

class ExploreViewController: TXViewController {
    // Declare
    private var state: Result<[String], PreviousSearchKeywordsFailure> = .success([])
    
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
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.titleView = searchBar
    }
    
    private func configureSearchBar() {
        searchBar.delegate = self
        searchBar.placeholder = "Searching for someone?"
    }
    
    private func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.tableHeaderView = .init(frame: .zero)
        
        tableView.register(
            SearchKeywordTableViewCell.self,
            forCellReuseIdentifier: SearchKeywordTableViewCell.reuseIdentifier
        )
        
        tableView.pin(
            to: view,
            byBeingSafeAreaAware: true
        )
    }
    
    // Populate
    
    // Interact
}

extension ExploreViewController: TXSearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let keyword = searchBar.text {
            let searchResultsViewController = SearchResultsViewController()
            
            searchResultsViewController.populate(withKeyword: keyword)
            
            navigationController?.pushViewController(
                searchResultsViewController,
                animated: true
            )
            
            searchBar.text = ""
        }
    }
}

// MARK: TXTableViewDataSource
extension ExploreViewController: TXTableViewDataSource {
    private func populateTableView() {
        Task {
            [weak self] in
            guard let strongSelf = self else {
                return
            }

            let result = await SearchProvider.shared.previousSearchKeywords()

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
            return success.count
        } onFailure: { failure in
            return 0
        }
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        return state.map { success in
            let keyword = success[indexPath.row]
            
            let cell = tableView.dequeueReusableCell(
                withIdentifier: SearchKeywordTableViewCell.reuseIdentifier,
                assigning: indexPath
            ) as! SearchKeywordTableViewCell
            
            cell.configure(withKeyword: keyword)
            
            return cell
        } onFailure: { failure in
            return TXTableViewCell()
        }
    }
}

// MARK:
extension ExploreViewController: TXTableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        willDisplay cell: UITableViewCell,
        forRowAt indexPath: IndexPath
    ) {
        switch state {
        case .success(let keywords):
            if indexPath.row  == keywords.count - 1 {
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
        case .success(let keywords):
            let keyword = keywords[indexPath.row]
            
            let searchResultsViewController = SearchResultsViewController()
            
            searchResultsViewController.populate(withKeyword: keyword)
            
            navigationController?.pushViewController(
                searchResultsViewController,
                animated: true
            )
        default:
            break
        }
    }
}
