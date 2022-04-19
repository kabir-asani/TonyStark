//
//  CommentsViewController.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 20/04/22.
//

import UIKit

class CommentsViewController: TXTableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar()
    }
    
    private func configureNavigationBar() {
        navigationItem.title = "Comments"
    }
}
