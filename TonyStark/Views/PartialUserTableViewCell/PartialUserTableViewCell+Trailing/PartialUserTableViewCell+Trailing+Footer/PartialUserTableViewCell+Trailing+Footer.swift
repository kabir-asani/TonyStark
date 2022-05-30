//
//  PartialUserTableViewCellTrailingFooter.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 27/04/22.
//

import UIKit

extension PartialUserTableViewCell.Trailing {
    class Footer: TXView {
        // Declare
        private let bioText: TXLabel = {
            let bioText = TXLabel()
            
            bioText.enableAutolayout()
            bioText.adjustsFontSizeToFitWidth = false
            bioText.numberOfLines = 0
            bioText.font = .systemFont(ofSize: 16, weight: .regular)
            
            return bioText
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
            addSubview(bioText)
            
            bioText.pin(to: self)
        }
        
        // Configure
        func configure(withUser user: User) {
            bioText.text = user.description
        }
        
        // Interact
    }
}
