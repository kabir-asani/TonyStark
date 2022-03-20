//
//  TTableViewController.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 16/03/22.
//

import UIKit

class TxTableViewController: UITableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureBaseView()
    }
    
    private func configureBaseView() {
        view.backgroundColor = .systemBackground
    }
}
