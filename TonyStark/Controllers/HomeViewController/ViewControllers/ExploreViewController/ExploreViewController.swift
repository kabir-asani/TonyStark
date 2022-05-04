//
//  ExploreViewController.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 16/03/22.
//

import UIKit

class ExploreViewController: TXTableViewController {
    // Declare
    private var state: Result<[String], PreviousSearchKeywordsFailure> = .success([])
    
    private let searchBarController: TXSearchController = {
        let searchBarController = TXSearchController()
        
        searchBarController.showsSearchResultsController = false
        
        return searchBarController
    }()
    
    // Configure
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar()
        configureSearchBar()
        configureTableView()
        
        populateTableView()
    }
    
    private func configureNavigationBar() {
        navigationItem.title = "Explore"
        navigationItem.backButtonTitle = ""
        navigationItem.largeTitleDisplayMode = .never
    }
    
    private func configureSearchBar() {
        navigationItem.searchController = searchBarController
        
        searchBarController.searchBar.delegate = self
        searchBarController.didMove(toParent: self)
    }
    
    private func configureTableView() {
        tableView.tableHeaderView = .init(frame: .zero)
        
        tableView.register(
            SearchKeywordTableViewCell.self,
            forCellReuseIdentifier: SearchKeywordTableViewCell.reuseIdentifier
        )
    }
    
    // Populate
    
    // Interact
}

extension ExploreViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print(#function)
    }
}

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
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return state.map { success in
            return success.count
        } onFailure: { failure in
            return 0
        }
    }
    
    override func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        return state.map { success in
            let keyword = success[indexPath.row]
            
            let cell = tableView.dequeueReusableCellWithIndexPath(
                withIdentifier: SearchKeywordTableViewCell.reuseIdentifier,
                for: indexPath
            ) as! SearchKeywordTableViewCell
            
            cell.configure(withKeyword: keyword)
            
            return cell
        } onFailure: { failure in
            return UITableViewCell()
        }
    }
}

extension ExploreViewController: TXTableViewDelegate {
    override func tableView(
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
    
    override func tableView(
        _ tableView: UITableView,
        estimatedHeightForRowAt indexPath: IndexPath
    ) -> CGFloat {
        return TXTableView.automaticDimension
    }
    
    override func tableView(
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
