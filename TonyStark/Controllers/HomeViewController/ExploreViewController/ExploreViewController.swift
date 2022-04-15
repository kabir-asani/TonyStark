//
//  ExploreViewController.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 16/03/22.
//

import UIKit

class ExploreViewController: TXTableViewController {
    let searchBarController: UISearchController = {
        let searchBarController = UISearchController()
        
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
        searchBarController.delegate = self
        navigationItem.searchController = searchBarController
    }
}

extension ExploreViewController: UISearchControllerDelegate {
    
}
