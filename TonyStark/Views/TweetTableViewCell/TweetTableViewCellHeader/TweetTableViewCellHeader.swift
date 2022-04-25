//
//  PartialUserTableViewCellHeader.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 25/04/22.
//

import UIKit

class TweetTableViewCellHeader: TXView {
    // Declare
    private let leading: TweetTableViewCellHeaderLeading = {
        let leading = TweetTableViewCellHeaderLeading()
        
        leading.enableAutolayout()
        
        return leading
    }()
    
    private let middle: TweetTableViewCellHeaderMiddle = {
        let middle = TweetTableViewCellHeaderMiddle()
        
        middle.enableAutolayout()
        
        return middle
    }()
    
    private let trailing: TweetTableViewCellHeaderTrailing = {
        let trailing = TweetTableViewCellHeaderTrailing()
        
        trailing.enableAutolayout()
        
        return trailing
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
                leading,
                middle,
                TXStackView.spacer,
                trailing
            ]
        )
        
        combinedStack.enableAutolayout()
        combinedStack.axis = .horizontal
        combinedStack.distribution = .fill
        combinedStack.alignment = .center
        combinedStack.spacing = 16
        
        return combinedStack
    }
    
    // Configure
    func configure(withTweet tweet: Tweet) {
        leading.configure(withTweet: tweet)
        
        middle.configure(withTweet: tweet)
        
        trailing.configure(withTweet: tweet)
    }
    
    // Interact
}
