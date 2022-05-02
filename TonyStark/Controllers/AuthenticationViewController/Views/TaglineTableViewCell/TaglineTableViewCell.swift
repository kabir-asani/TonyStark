//
//  TaglineTableViewCell.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 02/05/22.
//

import UIKit

class TaglineTableViewCell: TXTableViewCell {
    // Declare
    override class var reuseIdentifier: String {
        String(describing: TaglineTableViewCell.self)
    }
    
    private let taglineText: TXLabel = {
        let taglineText = TXLabel()
        
        taglineText.enableAutolayout()
        taglineText.font = .systemFont(
            ofSize: 40,
            weight: .black
        )
        taglineText.numberOfLines = 0
        taglineText.text = "Cherish the world better than ever!"
        
        return taglineText
    }()
    
    // Arrange
    override init(
        style: UITableViewCell.CellStyle,
        reuseIdentifier: String?
    ) {
        super.init(
            style: style,
            reuseIdentifier: reuseIdentifier
        )
        
        arrangeBaseView()
        arrangeSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func arrangeBaseView() {
        selectionStyle = .none
        separatorInset = .leading(.infinity)
    }
    
    private func arrangeSubviews() {
        addSubview(taglineText)
        
        arrangeTaglineText()
    }
    
    private func arrangeTaglineText() {
        taglineText.pin(
            verticallySymmetricTo: self,
            withInset: 140
        )
        
        taglineText.pin(
            horizontallySymmetricTo: self,
            withInset: 16
        )
    }
    
    // Configure
    
    // Interact
}
