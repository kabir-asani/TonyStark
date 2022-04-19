//
//  CurrentUserDetailsTableViewCellBody.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 18/04/22.
//

import UIKit

class CurrentUserTableViewCellBody: TXView {
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
        usernameText.numberOfLines = 0
        usernameText.font = .systemFont(ofSize: 16, weight: .regular)
        usernameText.textColor = .gray
        
        return usernameText
    }()
    
    let bioText: TXLabel = {
        let bioText = TXLabel()
        
        bioText.enableAutolayout()
        bioText.numberOfLines = 0
        bioText.font = .systemFont(ofSize: 16, weight: .regular)
        
        return bioText
    }()
    
    // Arrange
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        arrangeSubviews()
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
                bioText
            ]
        )
        
        combinedStack.enableAutolayout()
        combinedStack.axis = .vertical
        combinedStack.spacing = 8
        combinedStack.distribution = .equalSpacing
        combinedStack.alignment = .leading
        
        return combinedStack
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Configure
    func configure(withUser user: User) {
        configureNameText(withText: user.name)
        configureUsernameText(withText: user.username)
        configureBioText(withText: user.bio)
    }
    
    private func configureNameText(withText text: String) {
        nameText.text = text
    }
    
    private func configureUsernameText(withText text: String) {
        usernameText.text = "@\(text)"
    }
    
    private func configureBioText(withText text: String) {
        bioText.text = text
    }
}
