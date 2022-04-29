//
//  ComposeBottomBar.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 29/04/22.
//

import UIKit

class ComposeBottomBar: TXView {
    // Declare
    private let countText: TXLabel = {
        let countText = TXLabel()
        
        countText.font = .systemFont(
            ofSize: 16,
            weight: .semibold
        )
        countText.textAlignment = .justified
        
        return countText
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
        
        combinedStackView.pin(
            to: self,
            withInsets: .all(16)
        )
    }
    
    private func makeCombinedStackView() -> TXStackView {
        let combinedStack = TXStackView(
            arrangedSubviews: [
                .spacer,
                countText
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
    func configure(
        withCurrentCount current: Int
    ) {
        countText.text = "\(current) / 280"
        countText.textColor = current <= 250 ? .secondaryLabel : .systemRed
    }
    
    // Interact
}
