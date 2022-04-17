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
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func configureSearchBar() {
        navigationItem.searchController = searchBarController
        
        searchBarController.searchResultsUpdater = self
        searchBarController.didMove(toParent: self)
        
        navigationItem.hidesSearchBarWhenScrolling = true
    }
}

extension ExploreViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        print(#function)
    }
}
