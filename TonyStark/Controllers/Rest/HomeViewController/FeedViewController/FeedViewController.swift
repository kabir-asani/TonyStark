//
//  FeedViewController.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 16/03/22.
//

import UIKit

class FeedViewController: TxTableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureBaseView()
        configureNavigationBar()
    }
    
    private func configureBaseView() {
        view.backgroundColor = .systemPurple
    }
    
    private func configureNavigationBar() {
        navigationItem.title = "Twitter"
    }
    
    @objc func onComposePressed(_ sender: UIBarButtonItem) {
    }
}
