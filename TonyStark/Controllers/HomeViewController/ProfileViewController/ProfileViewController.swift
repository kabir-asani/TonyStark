//
//  ProfileViewController.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 16/03/22.
//

import UIKit

class ProfileViewController: TXTableViewController {
    let segmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: [
            "Tweets",
            "Bookmarks"
        ])
        
        segmentedControl.selectedSegmentIndex = 0
        
        return segmentedControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar()
    }
    
    private func configureNavigationBar() {
        navigationItem.title = "Self"
        navigationItem.titleView = segmentedControl
        
        navigationItem.rightBarButtonItem = TXBarButtonItem(
            image: UIImage(systemName: "gear"),
            style: .plain,
            target: self,
            action: #selector(onActionPressed(_:))
        )
        
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    @objc private func onActionPressed(_ sender: UIBarButtonItem) {
        print(#function)
    }
}
