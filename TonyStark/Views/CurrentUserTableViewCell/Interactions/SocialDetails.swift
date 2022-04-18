//
//  SocialDetails.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 18/04/22.
//

import UIKit

class SocialDetails: UIView {
    // Declare
    private var onPressed: (() -> Void)!
    
    let leadingText: UILabel = {
        let leadingText = UILabel()
        
        leadingText.enableAutolayout()
        leadingText.font = .systemFont(ofSize: 16, weight: .bold)
        
        return leadingText
    }()
    
    let trailingText: UILabel = {
        let trailingText = UILabel()
        
        trailingText.enableAutolayout()
        trailingText.font = .systemFont(ofSize: 16, weight: .regular)
        trailingText.textColor = .gray
        
        return trailingText
    }()
    
    let combinedStack: UIStackView = {
        let stack = UIStackView()
        
        stack.enableAutolayout()
        stack.axis = .horizontal
        stack.spacing = 8
        stack.distribution = .equalSpacing
        stack.alignment = .center
        
        return stack
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
        combinedStack.addArrangedSubview(leadingText)
        combinedStack.addArrangedSubview(trailingText)
        
        addSubview(combinedStack)
        
        combinedStack.pin(to: self)
    }
    
    // Configure
    func configure(
        with data: (leadingText: String, trailingText: String),
        onPressed: @escaping () -> Void
    ) {
        self.onPressed = onPressed
        
        leadingText.text = data.leadingText
        trailingText.text = data.trailingText
        
        let gestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(onPressed(_:))
        )
        
        combinedStack.addGestureRecognizer(gestureRecognizer)
    }
    
    @objc private func onPressed(_ sender: UITapGestureRecognizer) {
        onPressed()
    }
}
