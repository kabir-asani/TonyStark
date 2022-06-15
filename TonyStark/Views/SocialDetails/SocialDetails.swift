//
//  SocialDetails.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 18/04/22.
//

import UIKit

class SocialDetails: TXView {
    // Declare
    var identifier: String?
    
    private var onPressed: (() -> Void)?
    
    private let leadingText: TXLabel = {
        let leadingText = TXLabel()
        
        leadingText.enableAutolayout()
        leadingText.font = .systemFont(
            ofSize: 16,
            weight: .bold
        )
        
        return leadingText
    }()
    
    private let trailingText: TXLabel = {
        let trailingText = TXLabel()
        
        trailingText.enableAutolayout()
        trailingText.font = .systemFont(
            ofSize: 16,
            weight: .regular
        )
        trailingText.textColor = .gray
        
        return trailingText
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
        
        combinedStackView.addTapGestureRecognizer(
            target: self,
            action: #selector(onPress(_:))
        )
        
        addSubview(combinedStackView)
        
        combinedStackView.pin(to: self)
    }
    
    private func makeCombinedStackView() -> TXStackView {
        let combinedStack = TXStackView(
            arrangedSubviews: [
                leadingText,
                trailingText
            ]
        )
        
        combinedStack.enableAutolayout()
        combinedStack.axis = .horizontal
        combinedStack.spacing = 8
        combinedStack.distribution = .equalSpacing
        combinedStack.alignment = .center
        
        return combinedStack
    }
    
    // Configure
    func configure(
        withData data: (
            leadingText: String,
            trailingText: String
        ),
        onPressed: @escaping () -> Void
    ) {
        self.onPressed = onPressed
        
        configureLeadingText(
            withText: data.leadingText
        )
        configureTrailingText(
            withText: data.trailingText
        )
    }
    
    private func configureLeadingText(
        withText text: String
    ) {
        leadingText.text = text
    }
    
    private func configureTrailingText(
        withText text: String
    ) {
        trailingText.text = text
    }
    
    
    // Interact
    @objc private func onPress(
        _ sender: UITapGestureRecognizer
    ) {
        onPressed?()
    }
}
