//
//  ProfileImage.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 28/04/22.
//

import UIKit

class AvatarImage: TXView {
    enum Size: Double {
        case large = 40
        case small = 20
    }
    
    // Declare
    private let profileImage: TXImageView
    private var onPressed: (() -> Void)?
    
    // Arrange
    init(size: Size) {
        profileImage = TXCircularImageView(radius: size.rawValue)
        
        super.init(frame: .zero)
        
        arrangeProfileImage()
        
        arrangeSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func arrangeSubviews() {
        addSubview(profileImage)
        
        profileImage.pin(to: self)
    }
    
    private func arrangeProfileImage() {
        profileImage.enableAutolayout()
        profileImage.backgroundColor = .lightGray
        profileImage.isUserInteractionEnabled = true
        
        profileImage.addTapGestureRecognizer(
            target: self,
            action: #selector(onProfileImagePressed(_:))
        )
    }
    
    // Configure
    func configure(
        withImageURL imageURL: String,
        onPressed: (() -> Void)? = nil
    ) {
        self.onPressed = onPressed
        
        Task {
            let image = await TXImageProvider.shared.image(imageURL)
            
            if let image = image {
                DispatchQueue.main.async {
                    [weak self] in
                    guard let strongSelf = self else {
                        return
                    }
                    
                    strongSelf.profileImage.image = image
                }
            }
        }
    }
    
    // Interact
    @objc private func onProfileImagePressed(_ sender: UITapGestureRecognizer) {
        onPressed?()
    }
}
