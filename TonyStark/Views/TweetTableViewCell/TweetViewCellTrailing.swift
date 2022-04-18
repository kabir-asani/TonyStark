//
//  TweetViewCellTrailing.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 18/04/22.
//

import Foundation
import UIKit

class TweetViewCellTrailing: UIView {
    private var tweet: Tweet!
    
    private let header: TweetViewCellTrailingHeader = {
        let header = TweetViewCellTrailingHeader()
        
        header.enableAutolayout()
        
        return header
    }()
    
    private let body: TweetViewCellTrailingBody = {
        let body = TweetViewCellTrailingBody()
        
        body.enableAutolayout()
        
        return body
    }()
    
    private let footer: TweetViewCellTrailingFooter = {
        let footer = TweetViewCellTrailingFooter()
        
        footer.enableAutolayout()
        
        return footer
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        arrangeSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func arrangeSubviews() {
        let stack = UIStackView(arrangedSubviews: [
            header,
            body,
            footer
        ])
        
        stack.enableAutolayout()
        stack.axis = .vertical
        stack.spacing = 8
        stack.distribution = .equalSpacing
        stack.alignment = .fill
        
        addSubview(stack)
        
        stack.pin(to: self)
    }
    
    func configure(with tweet: Tweet) {
        self.tweet = tweet
        
        header.configure(with: tweet)
        body.configure(with: tweet)
        footer.configure(with: tweet)
    }
}

class TweetViewCellTrailingHeader: UIView {
    private var tweet: Tweet!
    
    private let nameText: UILabel = {
        let nameText = UILabel()
        
        nameText.enableAutolayout()
        nameText.adjustsFontSizeToFitWidth = false
        nameText.numberOfLines = 1
        nameText.font = .systemFont(ofSize: 16, weight: .bold)
        
        return nameText
    }()
    
    private let usernameText: UILabel = {
        let usernameText = UILabel()
        
        usernameText.enableAutolayout()
        usernameText.adjustsFontSizeToFitWidth = false
        usernameText.lineBreakMode = .byTruncatingTail
        usernameText.numberOfLines = 1
        usernameText.font = .systemFont(ofSize: 16, weight: .regular)
        usernameText.textColor = .gray
        
        return usernameText
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        arrangeSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func arrangeSubviews() {
        let stack = UIStackView(arrangedSubviews: [
            nameText,
            usernameText,
            UIStackView.spacer
        ])
        
        stack.enableAutolayout()
        stack.axis = .horizontal
        stack.spacing = 8
        stack.distribution = .fill
        stack.alignment = .center
        
        addSubview(stack)
        
        stack.pin(to: self)
    }
    
    func configure(with tweet: Tweet) {
        self.tweet = tweet
        
        configureNameText()
        configureUsernameText()
    }
    
    private func configureNameText() {
        nameText.text = tweet.author.name
    }
    
    private func configureUsernameText() {
        usernameText.text = "@" + tweet.author.username
    }
}

class TweetViewCellTrailingBody: UIView {
    private var tweet: Tweet!
    
    private let tweetText: UILabel = {
        let tweetText = UILabel()
        
        tweetText.enableAutolayout()
        tweetText.adjustsFontSizeToFitWidth = false
        tweetText.numberOfLines = 0
        tweetText.font = .systemFont(ofSize: 16, weight: .regular)
        
        return tweetText
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        arrangeSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with tweet: Tweet) {
        self.tweet = tweet
        
        configureTweetText()
    }
    
    private func arrangeSubviews() {
        addSubview(tweetText)
        
        tweetText.pin(to: self)
    }
    
    private func configureTweetText() {
        tweetText.text = tweet.text
    }
}

class TweetViewCellTrailingFooter: UIView {
    private var tweet: Tweet!
    
    private let likeInteractionDetails: LikeInteractionDetails = {
        let likeInteractionDetails = LikeInteractionDetails()
        
        likeInteractionDetails.enableAutolayout()
        likeInteractionDetails.heightConstaint(with: 20)
        
        return likeInteractionDetails
    }()
    
    private let commentInteractionDetails: CommentInteractionDetails = {
        let commentInteractionDetails = CommentInteractionDetails()
        
        commentInteractionDetails.enableAutolayout()
        commentInteractionDetails.heightConstaint(with: 20)
        
        return commentInteractionDetails
    }()
    
    private let tweetOptions: TweetOptions = {
        let tweetOptions = TweetOptions()
        
        tweetOptions.enableAutolayout()
        tweetOptions.heightConstaint(with: 20)
        
        return tweetOptions
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        arrangeSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func arrangeSubviews() {
        let stack = UIStackView(
            arrangedSubviews: [
                likeInteractionDetails,
                commentInteractionDetails,
                tweetOptions,
            ]
        )
        
        stack.enableAutolayout()
        stack.axis = .horizontal
        stack.spacing = 16
        stack.distribution = .fillEqually
        stack.alignment = .center
        
        addSubview(stack)
        
        stack.pin(to: self)
    }
    
    func configure(with tweet: Tweet) {
        self.tweet = tweet
        
        configureLikeInteractionDetails()
        configureCommentInteractionDetails()
        configureTweetOptions()
    }

    private func configureLikeInteractionDetails() {
        likeInteractionDetails.configure(with: tweet)
    }
    
    private func configureCommentInteractionDetails() {
        commentInteractionDetails.configure(with: tweet)
    }
    
    private func configureTweetOptions() {
        tweetOptions.configure(with: tweet)
    }
    
    @objc private func onOptionsPressed(
        _ sender: UIButton
    ) {
        print(#function)
    }
}
