//
//  EditProfileImageTableViewCell.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 30/04/22.
//

import UIKit

class EditProfileImageTableViewCell: TXTableViewCell {
    // Declare
    override class var reuseIdentifier: String {
        String(describing: EditProfileImageTableViewCell.self)
    }
    
    private let profileImage: AvatarImage = {
        let profileImage = AvatarImage(size: .large)
        
        profileImage.enableAutolayout()
        
        return profileImage
    }()
    
    private let editButton: TXButton = {
        let editButton = TXButton()
        
        editButton.enableAutolayout()
        editButton.setTitle(
            "Change profile picture",
            for: .normal
        )
        editButton.setTitleColor(
            .systemBlue,
            for: .normal
        )
        editButton.setTitleColor(
            .systemBlue.withAlphaComponent(0.8),
            for: .highlighted
        )
        
        return editButton
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
                profileImage,
                editButton
            ]
        )
        
        combinedStack.enableAutolayout()
        combinedStack.axis = .vertical
        combinedStack.distribution = .equalSpacing
        combinedStack.alignment = .center
        combinedStack.spacing = 16
        
        return combinedStack
    }
    
    // Configure
    func configure(withImageURL imageURL: String) {
        profileImage.configure(withImageURL: imageURL)
    }
    
    // Interact
}
