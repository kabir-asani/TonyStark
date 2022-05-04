//
//  SearchResultsViewController.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 04/05/22.
//

import UIKit

class SearchResultsViewController: TXTableViewController {
    // Declare
    private var keyword: String!
    
    private let searchBar: TXSearchBar = {
        let searchBar = TXSearchBar()
        
        return searchBar
    }()
    
    // Configure
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar()
        configureSearchBar()
    }
    
    private func configureNavigationBar() {
        navigationItem.titleView = searchBar
    }
    
    private func configureSearchBar() {
        searchBar.delegate = self
    }
    
    // Populate
    func populate(withKeyword keyword: String) {
        self.keyword = keyword
        searchBar.text = keyword
    }
    
    // Interact
}

extension SearchResultsViewController: TXSearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print(#function)
    }
}
