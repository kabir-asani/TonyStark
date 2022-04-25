//
//  PartialUserTableViewCellHeaderTrailing.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 25/04/22.
//

import UIKit

class TweetTableViewCellHeaderTrailing: TXView {
    // Declare
    private let optionsButton: TXButton = {
        let optionsButton = TXButton()
        
        optionsButton.enableAutolayout()
        optionsButton.setImage(
            UIImage(systemName: "ellipsis"),
            for: .normal
        )
        optionsButton.imageView?.tintColor = .systemGray
        
        return optionsButton
    }()
    
    // Arrange
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        arrangeSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func arrangeSubviews() {
        addSubview(optionsButton)
        
        optionsButton.pin(to: self)
    }
    
    // Configure
    func configure(withTweet tweet: Tweet) {
        
    }
    
    // Interact
}
