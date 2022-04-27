//
//  PartialUserTableViewCellTrailingHeaderFooter.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 27/04/22.
//

import UIKit

class PartialUserTableViewCellTrailingHeaderTrailing: TXView {
    // Declare
    private let optionsButton: TXButton = {
        let optionsButton = TXButton()
        
        optionsButton.enableAutolayout()
        
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
    func configure(withUser user: User) {
        optionsButton.setTitle(
            user.viewables.follower
            ? "Unfollow"
            : "Follow",
            for: .normal
        )
    }
    
    // Interact
}
