//
//  CommentTableViewCell.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 20/04/22.
//

import UIKit

class CommentTableViewCell: TXTableViewCell {
    // Declare
    static let reuseIdentifer = String(describing: CommentTableViewCell.self)
    
    let leading: CommentTableViewCellLeading = {
        let leading = CommentTableViewCellLeading()
        
        leading.enableAutolayout()
        
        return leading
    }()
    
    let trailing: CommentTableViewCellTrailing = {
        let trailing = CommentTableViewCellTrailing()
        
        trailing.enableAutolayout()
        
        return trailing
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
        
        arrangeSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func arrangeSubviews() {
        let combinedStackView = makeCombinedStackView()
        
        addSubview(combinedStackView)
        
        combinedStackView.pin(
            to: self,
            padding: UIEdgeInsets(
                top: 16,
                left: 16,
                bottom: -16,
                right: -16
            )
        )
    }
    
    private func makeCombinedStackView() -> TXStackView {
        let combinedStack = TXStackView(
            arrangedSubviews: [
                leading,
                trailing
            ]
        )
        
        combinedStack.enableAutolayout()
        combinedStack.axis = .horizontal
        combinedStack.distribution = .fill
        combinedStack.alignment = .top
        combinedStack.spacing = 16
        
        return combinedStack
    }
    
    // Configure
    func configure(withComment comment: Comment) {
        leading.interactionsHandler = self
        leading.configure(withComment: comment)
        
        trailing.configure(withComment: comment)
    }
    
    // Interact
}

extension CommentTableViewCell: CommentTableViewCellLeadingInteractionsHandler {
    func didPressProfileImage(_ commentTableViewCellLeading: CommentTableViewCellLeading) {
        print(#function)
    }
}
