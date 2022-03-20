//
//  TxPageViewController.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 16/03/22.
//

import UIKit

class TxPageViewController: UIPageViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureBaseView()
    }
    
    private func configureBaseView() {
        view.backgroundColor = .systemBackground
    }
}
