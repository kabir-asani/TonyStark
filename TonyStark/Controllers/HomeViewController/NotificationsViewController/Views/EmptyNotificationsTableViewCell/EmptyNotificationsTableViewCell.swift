//
//  EmptyNotificationsTableViewCell.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 14/06/22.
//

import UIKit

class EmptyNotificationsTableViewCell: TXTableViewCell {
    // Declare
    override class var reuseIdentifier: String {
        String(describing: EmptyNotificationsTableViewCell.self)
    }
    
    private let emptyNotificationsText: TXLabel = {
        let emptyTweetsText = TXLabel()
        
        emptyTweetsText.enableAutolayout()
        emptyTweetsText.font = .systemFont(
            ofSize: 24,
            weight: .bold
        )
        emptyTweetsText.textColor = .label
        emptyTweetsText.textAlignment = .center
        
        
        return emptyTweetsText
    }()
    
    private let emptyNotificationsSubtext: TXLabel = {
        let emptyTweetsSubtext = TXLabel()
        
        emptyTweetsSubtext.enableAutolayout()
        emptyTweetsSubtext.font = .systemFont(
            ofSize: 16,
            weight: .regular
        )
        emptyTweetsSubtext.textColor = .secondaryLabel
        emptyTweetsSubtext.textAlignment = .center
        emptyTweetsSubtext.numberOfLines = 0
        
        return emptyTweetsSubtext
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
        arrangeEmptyFeedText()
        arrangeEmptySubText()
        
        let combinedStackView = makeCombinedStackView()
        
        addSubview(combinedStackView)
        
        combinedStackView.pin(
            to: self,
            withInsets: .symmetric(
                horizontal: 16,
                vertical: 64
            )
        )
    }
    
    private func makeCombinedStackView() -> TXStackView {
        let combinedStack = TXStackView(
            arrangedSubviews: [
                emptyNotificationsText,
                emptyNotificationsSubtext
            ]
        )
        
        combinedStack.enableAutolayout()
        combinedStack.axis = .vertical
        combinedStack.distribution = .equalSpacing
        combinedStack.alignment = .center
        combinedStack.spacing = 16
        
        return combinedStack
    }
    
    private func arrangeEmptyFeedText() {
        emptyNotificationsText.text = "Empty Tray"
    }
    
    private func arrangeEmptySubText() {
        emptyNotificationsSubtext.text = """
        Notifications about likes, comments and follows from others on you show up here
        """
    }
    
    // Configure
    
    
    // Interact
}
