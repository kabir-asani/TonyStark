//
//  ExploreViewController.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 16/03/22.
//

import UIKit

class ExploreViewController: TXTableViewController {
    let searchBarController: TXSearchController = {
        let searchBarController = TXSearchController()
        
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
        navigationItem.largeTitleDisplayMode = .never
    }
    
    private func configureSearchBar() {
        navigationItem.searchController = searchBarController
        
        searchBarController.searchResultsUpdater = self
        searchBarController.didMove(toParent: self)
    }
}

extension ExploreViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        print(#function)
    }
}
