//
//  CommentTableViewCellTrailingHeader.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 20/04/22.
//

import UIKit

class CommentTableViewCellTrailingHeader: TXView {
    // Declare
    let nameText: TXLabel = {
        let nameText = TXLabel()
        
        nameText.enableAutolayout()
        nameText.numberOfLines = 0
        nameText.font = .systemFont(ofSize: 16, weight: .bold)
        
        return nameText
    }()
    
    let usernameText: TXLabel = {
        let usernameText = TXLabel()
        
        usernameText.enableAutolayout()
        usernameText.lineBreakMode = .byTruncatingTail
        usernameText.textColor = .gray
        usernameText.font = .systemFont(ofSize: 16, weight: .regular)
        
        return usernameText
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
                nameText,
                usernameText,
                TXStackView.spacer
            ]
        )
        
        combinedStack.enableAutolayout()
        combinedStack.axis = .horizontal
        combinedStack.spacing = 8
        combinedStack.distribution = .fill
        combinedStack.alignment = .center
        
        return combinedStack
    }
    
    // Configure
    func configure(withComment comment: Comment) {
        configureAuthorNameText(withText: comment.author.name)
        configureTimeText(withText: comment.author.username)
    }
    
    private func configureAuthorNameText(withText text: String) {
        nameText.text = text
    }
    
    private func configureTimeText(withText text: String) {
        usernameText.text = text
    }
    
    // Interact
}
