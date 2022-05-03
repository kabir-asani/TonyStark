//
//  TwitterXLogoTableViewCell.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 02/05/22.
//

import UIKit

class TwitterXLogoTableViewCell: TXTableViewCell {
    // Declare
    override class var reuseIdentifier: String {
        String(describing: TwitterXLogoTableViewCell.self)
    }
    
    private let twitterXLogo: TXImageView = {
        let twitterXLogo = TXImageView(image: TXBundledImage.twitterX)
        
        twitterXLogo.enableAutolayout()
        twitterXLogo.contentMode = .scaleAspectFill
        twitterXLogo.squareOff(withSide: 80)
        
        return twitterXLogo
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
        separatorInset = .leading(.infinity)
    }
    
    private func arrangeSubviews() {
        let combinedStackView = makeCombinedStackView()
        
        addSubview(combinedStackView)
        
        combinedStackView.pin(
            to: self,
            withInsets: .symmetric(horizontal: 16)
        )
    }
    
    private func makeCombinedStackView() -> TXStackView {
        let combinedStack = TXStackView(
            arrangedSubviews: [
                twitterXLogo,
                .spacer
            ]
        )
        
        combinedStack.enableAutolayout()
        combinedStack.axis = .horizontal
        combinedStack.distribution = .fill
        combinedStack.alignment = .leading
        combinedStack.spacing = 16
        
        return combinedStack
    }
    
    // Configure
    
    // Interact
}
