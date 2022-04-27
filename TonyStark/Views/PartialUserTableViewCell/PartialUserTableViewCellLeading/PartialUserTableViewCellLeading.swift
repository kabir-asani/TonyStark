//
//  PartialUserTableViewCellLeading.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 27/04/22.
//

import UIKit

class PartialUserTableViewCellLeading: TXView {
    // Declare
    private var onProfileImagePressed: (() -> Void)?
    
    private var profileImage: TXImageView = {
        let profileImage = TXCircularImageView(radius: 22)
        
        profileImage.enableAutolayout()
        profileImage.isUserInteractionEnabled = true
        
        return profileImage
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
        addSubview(profileImage)
            
        profileImage.pin(to: self)
    }
    
    // Configure
    func configure(
        withUser user: User
    ) {
        Task {
            let image = await TXImageProvider.shared.image(user.image)
            
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
}
