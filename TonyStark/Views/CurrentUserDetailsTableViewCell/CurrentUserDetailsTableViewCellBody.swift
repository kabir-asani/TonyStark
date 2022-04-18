//
//  CurrentUserDetailsTableViewCellBody.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 18/04/22.
//

import UIKit

class CurrentUserDetailsTableViewCellBody: UIView {
    // Declare
    let nameText: UILabel = {
        let nameText = UILabel()
        
        nameText.enableAutolayout()
        nameText.numberOfLines = 0
        nameText.font = .systemFont(ofSize: 16, weight: .bold)
        
        return nameText
    }()
    
    let usernameText: UILabel = {
        let usernameText = UILabel()
        
        usernameText.enableAutolayout()
        usernameText.numberOfLines = 0
        usernameText.font = .systemFont(ofSize: 16, weight: .regular)
        usernameText.textColor = .gray
        
        return usernameText
    }()
    
    let bioText: UILabel = {
        let bioText = UILabel()
        
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
        let stack = UIStackView(arrangedSubviews: [
            nameText,
            usernameText,
            bioText
        ])
        
        stack.enableAutolayout()
        stack.axis = .vertical
        stack.spacing = 8
        stack.distribution = .equalSpacing
        stack.alignment = .leading
        
        addSubview(stack)
        
        stack.pin(to: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Configure
    func configure(with user: User) {
        configure(nameTextWith: user.name)
        configure(usernameTextWith: user.username)
        configure(bioTextWith: user.bio)
    }
    
    private func configure(nameTextWith text: String) {
        nameText.text = text
    }
    
    private func configure(usernameTextWith text: String) {
        usernameText.text = "@\(text)"
    }
    
    private func configure(bioTextWith text: String) {
        bioText.text = text
    }
}
