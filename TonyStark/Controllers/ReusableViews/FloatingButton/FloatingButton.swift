//
//  FloatingButton.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 04/05/22.
//

import UIKit

class FloatingButton: TXButton {
    // Declare
    
    // Arrange
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        arrangeBaseView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func arrangeBaseView() {
        squareOff(withSide: 60)
        backgroundColor = .systemBlue
        tintColor = .white
        layer.cornerRadius = 30
        clipsToBounds = true
    }
    
    // Configure
    
    // Interact
}
