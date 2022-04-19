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
        
        navigationItem.largeTitleDisplayMode = .never
    
        navigationItem.leftBarButtonItem = TXBarButtonItem(
            image: UIImage(systemName: "multiply"),
            style: .plain,
            target: self,
            action: #selector(onClosePressed(_:))
        )
    }
    
    @objc private func onClosePressed(_ sender: TXBarButtonItem) {
        dismiss(animated: true)
    }
}
