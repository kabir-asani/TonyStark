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
    
    var indexPath: IndexPath!
    
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
}
