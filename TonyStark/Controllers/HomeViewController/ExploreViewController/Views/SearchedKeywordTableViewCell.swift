//
//  SearchKeywordTableViewCell.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 04/05/22.
//

import UIKit

class SearchedKeywordTableViewCell: TXTableViewCell {
    // Declare
    override class var reuseIdentifier: String {
        String(describing: SearchedKeywordTableViewCell.self)
    }
    
    private let leadingImage: TXImageView = {
        let leadingImage = TXImageView(
            image: UIImage(systemName: "arrow.up.right")
        )
        
        leadingImage.enableAutolayout()
        leadingImage.contentMode = .scaleAspectFit
        leadingImage.tintColor = .secondaryLabel
        
        return leadingImage
    }()
    
    private let trailingKeywordText: TXLabel = {
        let trailingKeywordText = TXLabel()
        
        trailingKeywordText.enableAutolayout()
        trailingKeywordText.font = .systemFont(
            ofSize: 16,
            weight: .regular
        )
        trailingKeywordText.textColor = .label
        trailingKeywordText.lineBreakMode = .byTruncatingTail
        
        return trailingKeywordText
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
        
        arrangeSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func arrangeSubviews() {
        arrangeLeadingImage()
        arrangeTrailingKeywordText()
        
        let combinedStackView = makeCombinedStackView()
        
        addSubview(combinedStackView)
        
        combinedStackView.pin(
            to: self,
            withInsets: .all(16)
        )
    }
    
    private func arrangeLeadingImage() {
        leadingImage.squareOff(withSide: 20)
    }
    
    private func arrangeTrailingKeywordText() {
        // Do nothing
    }
    
    private func makeCombinedStackView() -> TXStackView {
        let combinedStack = TXStackView(
            arrangedSubviews: [
                leadingImage,
                trailingKeywordText
            ]
        )
        
        combinedStack.enableAutolayout()
        combinedStack.axis = .horizontal
        combinedStack.distribution = .fill
        combinedStack.alignment = .center
        combinedStack.spacing = 16
        
        return combinedStack
    }
    
    // Configure
    func configure(withKeyword keyword: String) {
        trailingKeywordText.text = keyword
    }
    
    // Interact
}
