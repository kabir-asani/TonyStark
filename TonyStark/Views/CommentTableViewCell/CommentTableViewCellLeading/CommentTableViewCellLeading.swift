//
//  CommentTableViewCellLeading.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 20/04/22.
//

import UIKit

protocol CommentTableViewCellLeadingInteractionsHandler: CommentTableViewCell {
    func didPressProfileImage(_ commentTableViewCellLeading: CommentTableViewCellLeading)
}

class CommentTableViewCellLeading: TXView {
    // Declare
    weak var interactionsHandler: CommentTableViewCellLeadingInteractionsHandler?
    
    private let profileImage: TXImageView = {
        let profileImage = TXCircularImageView(
            radius: 20
        )
        
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
    
    func arrangeSubviews() {
        addSubview(profileImage)
        
        profileImage.pin(to: self)
    }
    
    // Configure
    func configure(withComment comment: Comment) {
        configureProfileImage(withImageURL: comment.author.image)
    }
    
    func configureProfileImage(withImageURL imageURL: String) {
        profileImage.addTapGestureRecognizer(
            target: self,
            action: #selector(onProfileImagePressed(_:))
        )
        
        Task {
            let image = await TXImageProvider.shared.image(imageURL)
            
            if let image = image {
                DispatchQueue.main.async {
                    [weak self] in
                    guard let safeSelf = self else {
                        return
                    }
                    
                    safeSelf.profileImage.image = image
                }
            }
        }
    }
    
    // Interact
    @objc private func onProfileImagePressed(_ sender: UITapGestureRecognizer) {
        interactionsHandler?.didPressProfileImage(self)
    }
}
