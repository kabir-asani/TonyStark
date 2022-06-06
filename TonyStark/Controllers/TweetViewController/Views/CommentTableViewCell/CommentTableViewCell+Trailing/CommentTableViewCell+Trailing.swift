//
//  CommentTableViewCellTrailing.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 20/04/22.
//

import UIKit

extension CommentTableViewCell {
    class Trailing: TXView {
        // Declare
        private let header: Header = {
            let header = Header()
            
            header.enableAutolayout()
            
            return header
        }()
        
        private let middle: Middle = {
            let middle = Middle()
            
            middle.enableAutolayout()
            
            return middle
        }()
        
        private let footer: Footer = {
            let footer = Footer()
            
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
                    middle,
                    footer
                ]
            )
            
            combinedStack.enableAutolayout()
            combinedStack.axis = .vertical
            combinedStack.spacing = 8
            combinedStack.distribution = .equalSpacing
            combinedStack.alignment = .leading
            
            return combinedStack
        }
        
        // Configure
        func configure(withComment comment: Comment) {
            header.configure(withComment: comment)
            middle.configure(withComment: comment)
            footer.configure(withComment: comment)
        }
        
        // Interact
    }
}
