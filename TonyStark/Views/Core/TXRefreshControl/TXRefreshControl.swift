//
//  TXRefreshControl.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 05/05/22.
//

import UIKit

protocol TXRefreshControlDelegate: AnyObject {
    func refreshControlDidChange(_ control: TXRefreshControl)
}

class TXRefreshControl: UIRefreshControl {
    weak var delegate: TXRefreshControlDelegate?
    
    override init() {
        super.init()
        
        addTarget(
            self,
            action: #selector(onRefreshControllerChanged(_:)),
            for: .valueChanged
        )
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addTarget(
            self,
            action: #selector(onRefreshControllerChanged(_:)),
            for: .valueChanged
        )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func onRefreshControllerChanged(_ refreshControl: TXRefreshControl) {
        delegate?.refreshControlDidChange(self)
    }
}
