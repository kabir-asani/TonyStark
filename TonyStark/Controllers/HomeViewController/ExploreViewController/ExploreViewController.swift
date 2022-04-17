//
//  ExploreViewController.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 16/03/22.
//

import UIKit

class ExploreViewController: TXViewController {
    let searchBarController: TXSearchController = {
        let searchBarController = TXSearchController(
            searchResultsController: ExploreResultsViewController()
        )
        
        searchBarController.extendedLayoutIncludesOpaqueBars = true
        
        return searchBarController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar()
        configureSearchBar()
    }
    
    private func configureNavigationBar() {
        navigationItem.title = "Explore"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func configureSearchBar() {
        searchBarController.searchResultsUpdater = self
        
        navigationItem.searchController = searchBarController
    }
}

extension ExploreViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let keyword = searchController.searchBar.text else {
            return
        }
    }
}

class ExploreResultsViewController: TXTableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureBaseView()
    }
    
    func configureBaseView() {
        view.backgroundColor = .systemBlue
    }
}
