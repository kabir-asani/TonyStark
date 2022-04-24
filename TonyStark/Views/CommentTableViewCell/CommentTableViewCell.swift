//
//  CommentTableViewCell.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 20/04/22.
//

import UIKit

protocol CommentTableViewCellInteractionsHandler: AnyObject {
    func didPressProfileImage(_ commentTableViewCell: CommentTableViewCell)
}

class CommentTableViewCell: TXTableViewCell {
    // Declare
    static let reuseIdentifer = String(describing: CommentTableViewCell.self)
    
    weak var interactionsHandler: CommentTableViewCellInteractionsHandler?
    
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
        
        arrangeBaseView()
        arrangeSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func arrangeBaseView() {
        selectionStyle = .none
    }
    
    private func arrangeSubviews() {
        let combinedStackView = makeCombinedStackView()
        
        addSubview(combinedStackView)
        
        combinedStackView.pin(
            to: self,
            withInsets: TXEdgeInsets(
                top: 16,
                right: 16,
                bottom: 16,
                left: 16
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
        leading.configure(
            withComment: comment
        ) {
            [weak self] in
            
            guard let strongSelf = self else {
                return
            }
            
            strongSelf.interactionsHandler?.didPressProfileImage(strongSelf)
        }
        
        trailing.configure(withComment: comment)
    }
    
    // Interact
}
