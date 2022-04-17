//
//  TXImageView.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 17/04/22.
//

import UIKit

class TXImageView: UIImageView {
    
}

class TXCircularImageView: TXImageView {
    init(radius: Double) {
        super.init(frame: .zero)
        
        enableAutolayout()
        squareOffConstraint(with: 2 * radius)
        layer.cornerRadius = radius
        clipsToBounds = true
        contentMode = .scaleAspectFill
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
