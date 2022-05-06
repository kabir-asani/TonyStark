//
//  EmptyFeedTableViewCell.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 06/05/22.
//

import UIKit

class EmptyFeedTableViewCell: TXTableViewCell {
    // Declare
    
    
    // Arrange
    override init(
        style: UITableViewCell.CellStyle,
        reuseIdentifier: String?
    ) {
        super.init(
            style: style,
            reuseIdentifier: reuseIdentifier
        )
        
        arrangeSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func arrangeSubviews() {
        
    }
    
    // Configure
    
    
    // Interact
}
