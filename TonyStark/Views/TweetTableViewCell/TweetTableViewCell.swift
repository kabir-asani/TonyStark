//
//  TweetTableViewCell.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 14/04/22.
//

import UIKit

class TweetTableViewCell: TXTableViewCell {
    static let reuseIdentifier = String(describing: TweetTableViewCell.self)
    
    private var tweet: Tweet!
    
    private let leading: TweetViewCellLeading = {
        let leading = TweetViewCellLeading()
        
        leading.enableAutolayout()
        
        return leading
    }()
    
    private let trailing: TweetViewCellTrailing = {
        let trailing = TweetViewCellTrailing()
        
        trailing.enableAutolayout()
        
        return trailing
    }()
    
    override init(
        style: UITableViewCell.CellStyle,
        reuseIdentifier: String?
    ) {
        super.init(
            style: style,
            reuseIdentifier: reuseIdentifier
        )
        
        self.selectionStyle = .none
        contentView.isUserInteractionEnabled = false
        
        configureSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func populate(with tweet: Tweet) {
        self.tweet = tweet
        
        leading.configure(with: tweet)
        trailing.configure(with: tweet)
    }
    
    private func configureSubviews() {
        let stack = UIStackView(
            arrangedSubviews: [
                leading,
                trailing
            ]
        )
        
        stack.enableAutolayout()
        stack.axis = .horizontal
        stack.distribution = .fill
        stack.alignment = .top
        stack.spacing = 16
        
        addSubview(stack)
        
        stack.pin(
            to: self,
            padding: UIEdgeInsets(
                top: 16,
                left: 16,
                bottom: -16,
                right: -16
            )
        )
    }
}

