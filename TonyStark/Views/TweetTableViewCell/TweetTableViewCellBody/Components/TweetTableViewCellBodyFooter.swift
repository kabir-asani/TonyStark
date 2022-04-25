//
//  PartialUserTableViewCellBodyFooter.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 25/04/22.
//

import UIKit

class TweetTableViewCellBodyFooter: TXView {
    // Declare
    private let timeText: TXLabel = {
        let timeText = TXLabel()
        
        timeText.enableAutolayout()
        timeText.adjustsFontSizeToFitWidth = false
        timeText.numberOfLines = 1
        timeText.textColor = .systemGray
        timeText.font = .systemFont(ofSize: 16, weight: .regular)
        
        return timeText
    }()
    
    private let dateText: TXLabel = {
        let dateText = TXLabel()
        
        dateText.enableAutolayout()
        dateText.adjustsFontSizeToFitWidth = false
        dateText.numberOfLines = 1
        dateText.textColor = .systemGray
        dateText.font = .systemFont(ofSize: 16, weight: .regular)
        
        return dateText
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
        let combinedStackView = makeCombinedStackView()
        
        addSubview(combinedStackView)
        
        combinedStackView.pin(to: self)
    }
    
    private func makeCombinedStackView() -> TXStackView {
        let combinedStack = TXStackView(
            arrangedSubviews: [
                timeText,
                dateText,
                TXStackView.spacer
            ]
        )
        
        combinedStack.enableAutolayout()
        combinedStack.axis = .horizontal
        combinedStack.distribution = .fill
        combinedStack.alignment = .center
        combinedStack.spacing = 8
        
        return combinedStack
    }
    
    // Configure
    func configure(withTweet tweet: Tweet) {
//        timeText.text = tweet.creationDate.timeIntervalSince1970.description
//        dateText.text = tweet.creationDate.timeIntervalSince1970.description
        timeText.text = "26 Jan"
        dateText.text = "20/10/2022"
    }
    
    // Interact
}
