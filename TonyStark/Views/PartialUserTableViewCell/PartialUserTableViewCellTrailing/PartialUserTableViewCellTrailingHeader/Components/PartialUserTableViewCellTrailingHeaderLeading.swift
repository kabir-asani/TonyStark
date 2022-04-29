//
//  PartialUserTableViewCellTrailingHeaderHeader.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 27/04/22.
//

import UIKit

class PartialUserTableViewCellTrailingHeaderLeading: TXView {
    // Declare
    private let nameText: TXLabel = {
        let nameText: TXLabel = .name()
        
        nameText.enableAutolayout()
        
        return nameText
    }()
    
    private let usernameText: TXLabel = {
        let usernameText: TXLabel = .username()
        
        usernameText.enableAutolayout()
        
        return usernameText
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
        let combinedStackView = makeCombinedStackView()
        
        addSubview(combinedStackView)
        
        combinedStackView.pin(to: self)
    }
    
    private func makeCombinedStackView() -> TXStackView {
        let combinedStack = TXStackView(
            arrangedSubviews: [
                nameText,
                usernameText
            ]
        )
        
        combinedStack.enableAutolayout()
        combinedStack.axis = .vertical
        combinedStack.distribution = .equalSpacing
        combinedStack.alignment = .leading
        combinedStack.spacing = 4
        
        return combinedStack
    }
    
    // Configure
    func configure(withUser user: User) {
        nameText.text = user.name
        usernameText.text = "@" + user.username
    }
    
    // Interact
}
