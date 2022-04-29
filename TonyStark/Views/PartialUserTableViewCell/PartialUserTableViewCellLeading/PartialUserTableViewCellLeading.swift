//
//  PartialUserTableViewCellLeading.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 27/04/22.
//

import UIKit

class PartialUserTableViewCellLeading: TXView {
    // Declare
    private var profileImage: AvatarImage = {
        let profileImage = AvatarImage(size: .small)
        
        profileImage.enableAutolayout()
        
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
        withUser user: User,
        onPressed: @escaping () -> Void
    ) {
        profileImage.configure(
            withImageURL: user.image,
            onPressed: onPressed
        )
    }
}
