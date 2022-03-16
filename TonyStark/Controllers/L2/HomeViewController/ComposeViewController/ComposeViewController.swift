//
//  ComposeViewController.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 16/03/22.
//

import UIKit

class ComposeViewController: TxViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureBaseView()
        configureNavigationBar()
    }
    
    private func configureBaseView() {
        view.backgroundColor = .systemGreen
    }
    
    
    private func configureNavigationBar() {
        navigationItem.title = "Compose"
    }
}
