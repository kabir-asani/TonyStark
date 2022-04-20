//
//  CommentTableViewCellTrailingFooter.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 20/04/22.
//

import UIKit

class CommentTableViewCellTrailingFooter: TXView {
    // Declare
    let commentText: TXLabel = {
        let commentText = TXLabel()
        
        commentText.enableAutolayout()
        commentText.numberOfLines = 0
        
        return commentText
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
        addSubview(commentText)
        
        commentText.pin(to: self)
    }
    
    // Configure
    func configure(withComment comment: Comment) {
        commentText.text = comment.text
    }
    
    // Interact
}
