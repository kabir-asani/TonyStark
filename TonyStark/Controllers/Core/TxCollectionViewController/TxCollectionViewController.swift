//
//  TCollectionViewController.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 16/03/22.
//

import UIKit

class TxCollectionViewController: UICollectionViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureBaseView()
    }
    
    private func configureBaseView() {
        view.backgroundColor = .systemBackground
    }
}
