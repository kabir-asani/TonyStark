//
//  PartialUserTableViewCellTrailing.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 27/04/22.
//

import UIKit

class PartialUserTableViewCellTrailing: TXView {
    // Declare
    private let header: PartialUserTableViewCellTrailingHeader = {
        let header = PartialUserTableViewCellTrailingHeader()
        
        header.enableAutolayout()
        
        return header
    }()
    
    private let footer: PartialUserTableViewCellTrailingFooter = {
        let footer = PartialUserTableViewCellTrailingFooter()
        
        footer.enableAutolayout()
        
        return footer
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
                header,
                footer
            ]
        )
        
        combinedStack.enableAutolayout()
        combinedStack.axis = .vertical
        combinedStack.distribution = .fillEqually
        combinedStack.alignment = .fill
        combinedStack.spacing = 8
        
        return combinedStack
    }
    
    // Configure
    func configure(withUser user: User) {
        header.configure(withUser: user)
        footer.configure(withUser: user)
    }
    
    // Interact
}
