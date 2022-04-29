//
//  CurrentUserDetailsTableViewCellHeader.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 18/04/22.
//

import UIKit

class CurrentUserTableViewCellHeader: TXView {
    // Declare
    private var onEditPressed: (() -> Void)?
    
    let profileImage: AvatarImage = {
        let profileImage = AvatarImage(size: .large)
        
        profileImage.enableAutolayout()
        
        return profileImage
    }()
    
    let editButton: TXButton = {
        let editButton = TXButton()
        
        editButton.enableAutolayout()
        editButton.fixWidth(to: 140)
        editButton.fixHeight(to: 40)
        editButton.setTitle("Edit", for: .normal)
        
        if #available(iOS 15.0, *) {
            editButton.setTitleColor(.label, for: .normal)
            editButton.setTitleColor(.label, for: .highlighted)
            editButton.configuration = TXButton.Configuration.bordered()
        } else {
            editButton.setTitleColor(.systemBlue, for: .normal)
            editButton.layer.borderWidth = 2
            editButton.layer.borderColor = TXColor.systemBlue.cgColor
            editButton.showsTouchWhenHighlighted = true
        }
        
        editButton.layer.cornerRadius = 22
        editButton.clipsToBounds = true
        
        return editButton
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
                profileImage,
                TXStackView.spacer,
                editButton
            ]
        )
        
        combinedStack.enableAutolayout()
        combinedStack.axis = .horizontal
        combinedStack.distribution = .fill
        combinedStack.alignment = .center
        
        return combinedStack
    }
    
    // Configure
    func configure(
        withUser user: User,
        onEditPressed: @escaping () -> Void
    ) {
        self.onEditPressed = onEditPressed
        
        profileImage.configure(withImageURL: user.image)
        configureEditButton()
    }
    
    private func configureEditButton() {
        editButton.addTarget(
            self,
            action: #selector(onEditPressed(_:)),
            for: .touchUpInside
        )
    }
    
    // Interact
    @objc private func onEditPressed(_ sender: TXButton) {
        onEditPressed?()
    }
}
