//
//  OtherUserTableViewCellHeader.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 23/04/22.
//

import UIKit

extension OtherUserTableViewCell {
    class Header: TXView {
        // Declare
        private var onFollowPressed: (() -> Void)?
        
        private let profileImage: AvatarImage = {
            let profileImage = AvatarImage(size: .large)
            
            profileImage.enableAutolayout()
            
            return profileImage
        }()
        
        private let followButton: TXButton = {
            let followButton = TXButton()
            
            followButton.enableAutolayout()
            followButton.fixWidth(to: 140)
            followButton.fixHeight(to: 40)
            
            followButton.layer.cornerRadius = 22
            followButton.clipsToBounds = true
            
            return followButton
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
                    .spacer,
                    followButton
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
            onFollowPressed: @escaping () -> Void
        ) {
            self.onFollowPressed = onFollowPressed
            
            profileImage.configure(withImageURL: user.image)
            configureFollowButton(withViewables: user.viewables)
        }
        
        private func configureFollowButton(withViewables viewables: UserViewables) {
            followButton.setTitle(
                viewables.following
                ? "Unfollow"
                : "Follow",
                for: .normal
            )
            
            if #available(iOS 15.0, *) {
                followButton.setTitleColor(
                    viewables.following
                    ? .label
                    : .systemBlue,
                    for: .normal
                )
                followButton.setTitleColor(
                    viewables.following
                    ? .systemGray
                    : .systemBlue,
                    for: .highlighted
                )
                followButton.configuration = TXButton.Configuration.bordered()
            } else {
                followButton.setTitleColor(
                    viewables.following
                    ? .label
                    : .systemBlue,
                    for: .normal
                )
                followButton.layer.borderWidth = 2
                followButton.layer.borderColor = viewables.following
                ? TXColor.systemGray.cgColor
                : TXColor.systemBlue.cgColor
                followButton.showsTouchWhenHighlighted = true
            }
            
            followButton.addTarget(
                self,
                action: #selector(onFollowPressed(_:)),
                for: .touchUpInside
            )
        }
        
        // Interact
        @objc private func onFollowPressed(_ sender: TXButton) {
            onFollowPressed?()
        }
    }
}
