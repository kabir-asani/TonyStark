//
//  CurrentUserDetailsTableViewCellHeader.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 18/04/22.
//

import UIKit

class CurrentUserTableViewCellHeader: UIView {
    // Declare
    private var onEditPressed: (() -> Void)!
    
    let profileImage: TXImageView = {
        let profileImage = TXCircularImageView(radius: 40)
        
        profileImage.enableAutolayout()
        profileImage.backgroundColor = .lightGray
        
        return profileImage
    }()
    
    let editButton: TXButton = {
        let editButton = TXButton()
        
        editButton.enableAutolayout()
        editButton.widthConstraint(with: 140)
        editButton.heightConstaint(with: 40)
        editButton.setTitle("Edit", for: .normal)
        
        if #available(iOS 15.0, *) {
            editButton.setTitleColor(.label, for: .normal)
            editButton.setTitleColor(.label, for: .highlighted)
            editButton.configuration = UIButton.Configuration.bordered()
        } else {
            editButton.setTitleColor(.systemBlue, for: .normal)
            editButton.layer.borderWidth = 2
            editButton.layer.borderColor = UIColor.systemBlue.cgColor
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
        let stack = UIStackView(arrangedSubviews: [
            profileImage,
            UIStackView.spacer,
            editButton
        ])
        
        stack.enableAutolayout()
        stack.axis = .horizontal
        stack.distribution = .fill
        stack.alignment = .center
        
        addSubview(stack)
        
        stack.pin(to: self)
    }
    
    // Configure
    func configure(
        with user: User,
        onEditPressed: @escaping () -> Void
    ) {
        configure(profileImageWith: user.image)
        configure(editButtonWith: onEditPressed)
    }
    
    private func configure(profileImageWith imageURL: String) {
        Task {
            let image = await TXImageProvider.shared.image(imageURL)
            
            DispatchQueue.main.async {
                [weak self] in
                guard let safeSelf = self, let image = image else {
                    return
                }
                
                safeSelf.profileImage.image = image
            }
        }
    }
    
    private func configure(editButtonWith onEditPressed: @escaping () -> Void) {
        self.onEditPressed = onEditPressed
        
        editButton.addTarget(
            self,
            action: #selector(onEditPressed(_:)),
            for: .touchUpInside
        )
    }
    
    @objc private func onEditPressed(_ sender: UIButton) {
        onEditPressed()
    }
}
