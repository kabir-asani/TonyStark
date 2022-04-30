//
//  RoundedButtonWithLeadingImage.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 30/04/22.
//

import UIKit

class RoundedButtonWithLeadingImage: TXView {
    // Declare
    private var onPressed: (() -> Void)?
    
    private let leading: TXImageView = {
        let leading = TXImageView()
        
        leading.enableAutolayout()
        leading.contentMode = .scaleAspectFill
        leading.backgroundColor = .clear
        leading.squareOff(withSide: 20)
        
        return leading
    }()
    
    private let trailing: TXLabel = {
        let trailing = TXLabel()
        
        trailing.enableAutolayout()
        trailing.font = .systemFont(
            ofSize: 16,
            weight: .bold
        )
        trailing.textColor = .black
        trailing.numberOfLines = 1
        trailing.lineBreakMode = .byTruncatingTail
        
        return trailing
    }()
    
    // Arrange
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        arrangeBaseView()
        arrangeSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func arrangeBaseView() {
        layer.cornerRadius = 26
        backgroundColor = .white
        layer.borderColor = TXColor.lightGray.cgColor
        layer.borderWidth = 1
        clipsToBounds = true
        
        self.addTapGestureRecognizer(
            target: self,
            action: #selector(onPressed(_:))
        )
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
                leading,
                trailing
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
    func configure(
        withData data: (
            image: UIImage,
            text: String
        ),
        onPressed: @escaping () -> Void
    ) {
        self.onPressed = onPressed
        
        leading.image = data.image
        trailing.text = data.text
    }
    
    // Interact
    @objc private func onPressed(_ sender: UITapGestureRecognizer) {
        onPressed?()
    }
}
