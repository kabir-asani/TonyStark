//
//  TNavigationController.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 16/03/22.
//

import UIKit

class TXNavigationController: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureBaseView()
        configureNavigationBar()
    }
    
    private func configureBaseView() {
        view.backgroundColor = .systemBackground
    }
    
    private func configureNavigationBar() {
        navigationBar.tintColor = .label
    }
}
