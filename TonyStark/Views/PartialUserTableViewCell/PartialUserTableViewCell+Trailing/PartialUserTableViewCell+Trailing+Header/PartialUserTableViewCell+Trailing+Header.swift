//
//  PartialUserTableViewCellTrailingHeader.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 27/04/22.
//

import UIKit

extension PartialUserTableViewCell.Trailing {
    class Header: TXView {
        // Declare
        private let leading: Leading = {
            let leading = Leading()
            
            leading.enableAutolayout()
            
            return leading
        }()
        
        
        private let trailing: Trailing = {
            let trailing = Trailing()
            
            trailing.enableAutolayout()
            
            return trailing
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
                    leading,
                    .spacer,
                    trailing
                ]
            )
            
            combinedStack.enableAutolayout()
            combinedStack.axis = .horizontal
            combinedStack.distribution = .fill
            combinedStack.alignment = .center
            combinedStack.spacing = 8
            
            return combinedStack
        }
        
        // Configure
        func configure(withUser user: User) {
            leading.configure(withUser: user)
            trailing.configure(withUser: user)
        }
        
        // Interact
    }
}
