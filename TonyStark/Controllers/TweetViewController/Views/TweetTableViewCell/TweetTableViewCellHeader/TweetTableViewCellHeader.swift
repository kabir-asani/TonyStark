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
                .spacer,
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
    @available(iOS 14, *)
    func configure(
        withTweet tweet: Tweet,
        onProfileImagePressed: @escaping () -> Void,
        onDetailsPressed: @escaping () -> Void,
        onBookmarksPressed: @escaping () -> Void,
        onFollowPressed: @escaping () -> Void
    ) {
        leading.configure(
            withTweet: tweet,
            onProfileImagePressed: onProfileImagePressed
        )
        
        middle.configure(
            withTweet: tweet,
            onPressed: onDetailsPressed
        )
        
        trailing.configure(
            withTweet: tweet,
            onBookmarkPressed: onBookmarksPressed,
            onFollowPressed: onFollowPressed
        )
    }
    
    @available(iOS, deprecated: 14)
    func configure(
        withTweet tweet: Tweet,
        onProfileImagePressed: @escaping () -> Void,
        onDetailsPressed: @escaping () -> Void,
        onOptionsPressed: @escaping () -> Void
    ) {
        leading.configure(
            withTweet: tweet,
            onProfileImagePressed: onProfileImagePressed
        )
        
        middle.configure(
            withTweet: tweet,
            onPressed: onDetailsPressed
        )
        
        trailing.configure(onOptionsPressed: onOptionsPressed)
    }
    
    // Interact
}
