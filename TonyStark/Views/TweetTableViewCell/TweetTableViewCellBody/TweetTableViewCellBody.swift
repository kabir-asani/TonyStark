//
//  PartialUserTableViewCellBody.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 25/04/22.
//

import UIKit

class TweetTableViewCellBody: TXView {
    // Declare
    private var header: TweetTableViewCellBodyHeader = {
        let header = TweetTableViewCellBodyHeader()
        
        header.enableAutolayout()
        
        return header
    }()
    
    private var footer: TweetTableViewCellBodyFooter = {
        let footer = TweetTableViewCellBodyFooter()
        
        footer.enableAutolayout()
        
        return footer
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
                header,
                footer
            ]
        )
        
        combinedStack.enableAutolayout()
        combinedStack.axis = .vertical
        combinedStack.distribution = .equalSpacing
        combinedStack.alignment = .fill
        combinedStack.spacing = 8
        
        return combinedStack
    }
    
    // Configure
    func configure(withTweet tweet: Tweet) {
        header.configure(withTweet: tweet)
        
        footer.configure(withTweet: tweet)
    }
    
    // Interact
}
