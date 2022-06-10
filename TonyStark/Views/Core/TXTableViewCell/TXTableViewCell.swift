//
//  TTableViewCell.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 16/03/22.
//

import UIKit

class TXTableViewCell: UITableViewCell {
    class var reuseIdentifier: String {
        String(describing: TXTableViewCell.self)
    }
    
    var defaultSeparatorInsets: UIEdgeInsets {
        get {
            .leading(20)
        }
    }
    
    override init(
        style: UITableViewCell.CellStyle,
        reuseIdentifier: String?
    ) {
        super.init(
            style: style,
            reuseIdentifier: reuseIdentifier
        )
        
        contentView.isUserInteractionEnabled = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func prepareForDelete() {
        self.isUserInteractionEnabled = false
        alpha = 0.4
    }
    
    func revertAllPreparationsMadeForDelete() {
        self.isUserInteractionEnabled = true
        alpha = 1.0
    }
    
    override func prepareForReuse() {
        revertAllPreparationsMadeForDelete()
    }
}
