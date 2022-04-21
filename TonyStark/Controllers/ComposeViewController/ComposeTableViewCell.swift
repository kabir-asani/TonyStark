//
//  ComposeTableViewCell.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 15/04/22.
//

import Foundation
import UIKit

class ComposeTableViewCell: TXTableViewCell {
    static let reuseIdentifer = String(describing: ComposeTableViewCell.self)
    
    let composableTextView: UITextView = {
        let composableTextView = UITextView()
        
        composableTextView.enableAutolayout()
        composableTextView.font = .systemFont(ofSize: 16, weight: .regular)
        composableTextView.backgroundColor = .clear
        
        return composableTextView
    }()
    
    override init(
        style: UITableViewCell.CellStyle,
        reuseIdentifier: String?
    ) {
        super.init(
            style: style,
            reuseIdentifier: reuseIdentifier
        )
        
        contentView.isUserInteractionEnabled = false
        
        addSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {
        addSubview(composableTextView)
        
        composableTextView.fixHeight(
            to: 120
        )
        composableTextView.pin(
            to: self,
            withPadding: TXEdgeInsets(
                top: 16,
                right: 16,
                bottom: 16,
                left: 16
            )
        )
    }
}
