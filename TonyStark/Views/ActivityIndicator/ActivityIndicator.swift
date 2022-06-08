//
//  ProgressIndicator.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 08/06/22.
//

import UIKit

class ActivityIndicator: TXVisualEffectView {
    // Declare
    private let activityIndicator: TXActivityIndicatorView = {
        let activityIndicator = TXActivityIndicatorView()
        
        activityIndicator.enableAutolayout()
        activityIndicator.fixHeight(to: 60)
        activityIndicator.fixWidth(to: 60)
        
        return activityIndicator
    }()
    
    // Arrange
    init() {
        super.init(effect: UIBlurEffect(style: .systemThickMaterial))
        
        arrangeBaseView()
        arrangeSubviews()
    }
    
    override init(effect: UIVisualEffect?) {
        super.init(effect: effect)
        
        arrangeBaseView()
        arrangeSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func arrangeBaseView() {
        backgroundColor = .systemGray
        
        enableAutolayout()
        fixHeight(to: 120)
        fixWidth(to: 120)
        
        clipsToBounds = true
        layer.cornerRadius = 8
    }
    
    private func arrangeSubviews() {
        contentView.addSubview(activityIndicator)
        
        activityIndicator.align(toCenterOf: contentView)
        activityIndicator.startAnimating()
    }
    
    // Configure
    
    
    // Interact
}
