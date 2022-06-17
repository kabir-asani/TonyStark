//
//  UnknownFailureTableViewCell.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 17/06/22.
//

import UIKit

class UnknownFailureTableViewCell: TXTableViewCell {
    // Declare
    override class var reuseIdentifier: String {
        String(describing: UnknownFailureTableViewCell.self)
    }
    
    private let unknownFailureText: TXLabel = {
        let emptyFeedText = TXLabel()
        
        emptyFeedText.enableAutolayout()
        emptyFeedText.font = .systemFont(
            ofSize: 24,
            weight: .bold
        )
        emptyFeedText.textColor = .label
        emptyFeedText.textAlignment = .center
        
        
        return emptyFeedText
    }()
    
    private let unknownFailureSubtext: TXLabel = {
        let emptyFeedSubtext = TXLabel()
        
        emptyFeedSubtext.enableAutolayout()
        emptyFeedSubtext.font = .systemFont(
            ofSize: 16,
            weight: .regular
        )
        emptyFeedSubtext.textColor = .secondaryLabel
        emptyFeedSubtext.textAlignment = .center
        emptyFeedSubtext.numberOfLines = 0
        
        return emptyFeedSubtext
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
        arrangeEmptyFeedText()
        arrangeEmptySubText()
        
        let combinedStackView = makeCombinedStackView()
        
        addSubview(combinedStackView)
        
        combinedStackView.pin(
            to: self,
            withInsets: .symmetric(
                horizontal: 32,
                vertical: 64
            )
        )
    }
    
    private func makeCombinedStackView() -> TXStackView {
        let combinedStack = TXStackView(
            arrangedSubviews: [
                unknownFailureText,
                unknownFailureSubtext
            ]
        )
        
        combinedStack.enableAutolayout()
        combinedStack.axis = .vertical
        combinedStack.distribution = .equalSpacing
        combinedStack.alignment = .center
        combinedStack.spacing = 16
        
        return combinedStack
    }
    
    private func arrangeEmptyFeedText() {
        unknownFailureText.text = "Something Went Wrong 😕"
    }
    
    private func arrangeEmptySubText() {
        unknownFailureSubtext.text = "Please try again or refresh in sometime"
    }
    // Configure
    
    
    // Interact
}
