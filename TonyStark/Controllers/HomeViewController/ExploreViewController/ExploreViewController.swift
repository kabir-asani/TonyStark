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
        
        navigationController?.delegate = self
        
        addSubviews()
        
        configureNavigationBar()
        configureSearchBar()
        configureTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        startKeyboardAwareness()
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
        
        tableView.pin(
            to: view,
            byBeingSafeAreaAware: true
        )
    }
    
    // Populate
    
    // Interact
}

extension ExploreViewController: TXNavigationControllerDelegate {
    func navigationController(
        _ navigationController: UINavigationController,
        didShow viewController: UIViewController,
        animated: Bool
    ) {
        if viewController === self {
            populateTableView()
        }
    }
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
            Task {
                await SearchDataStore.shared.captureKeyword(keyword)
            }
            
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
            [weak self] in
            guard let strongSelf = self else {
                return
            }

            let result = await SearchDataStore.shared.previousSearchKeywords()

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
                withIdentifier: SearchedKeywordTableViewCell.reuseIdentifier,
                assigning: indexPath
            ) as! SearchedKeywordTableViewCell
            
            cell.configure(withKeyword: keyword)
            
            return cell
        } onFailure: { failure in
            return TXTableViewCell()
        }
    }
}

// MARK: TXTableViewDelegate
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
            
            let searchResultsViewController = SearchViewController()
            
            searchResultsViewController.populate(withKeyword: keyword)
            
            navigationController?.pushViewController(
                searchResultsViewController,
                animated: true
            )
            
            searchBar.resignFirstResponder()
        default:
            break
        }
    }
}
