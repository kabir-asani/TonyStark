//
//  TweetTableViewCell.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 14/04/22.
//

import UIKit

class TweetTableViewCell: TXTableViewCell {
    static let reuseIdentifier = String(describing: TweetTableViewCell.self)
    
    private var tweet: Tweet?
    
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
        
        addSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with tweet: Tweet) {
        self.tweet = tweet
        
        leading.configure(with: tweet)
        trailing.configure(with: tweet)
    }
    
    private func addSubviews() {
        let stack = UIStackView(arrangedSubviews: [
            leading,
            trailing
        ])
        
        stack.enableAutolayout()
        stack.axis = .horizontal
        stack.distribution = .fillProportionally
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

class TweetViewCellLeading: UIView {
    private var tweet: Tweet?
    
    private let image: UIImageView = {
        let image = UIImageView()
        
        image.enableAutolayout()
        image.backgroundColor = .lightGray
        
        return image
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with tweet: Tweet) {
        self.tweet = tweet
        
        configure(imageWith: tweet.author.image)
    }
    
    private func addSubviews() {
        addSubview(image)
        
        image.squareOffConstraint(with: 44)
        
        image.layer.cornerRadius = 22
        image.clipsToBounds = true
        
        image.pin(to: self)
    }
    
    private func configure(imageWith imageURL: String) {
        Task {
            let image = await TXImageProvider.shared.image(imageURL)
            
            DispatchQueue.main.async {
                [weak self] in
                guard let image = image else { return }
                self?.image.image = image
            }
        }
    }
}

class TweetViewCellTrailing: UIView {
    private var tweet: Tweet?
    
    let header: TweetViewCellTrailingHeader = {
        let header = TweetViewCellTrailingHeader()
        
        header.enableAutolayout()
        
        return header
    }()
    
    let body: TweetViewCellTrailingBody = {
        let body = TweetViewCellTrailingBody()
        
        body.enableAutolayout()
        
        return body
    }()
    
    let footer: TweetViewCellTrailingFooter = {
        let footer = TweetViewCellTrailingFooter()
        
        footer.enableAutolayout()
        
        return footer
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with tweet: Tweet) {
        self.tweet = tweet
        
        header.configure(with: tweet)
        body.configure(with: tweet)
        footer.configure(with: tweet)
    }
    
    private func addSubviews() {
        let stack = UIStackView(arrangedSubviews: [
            header,
            body,
            footer
        ])
        
        stack.enableAutolayout()
        stack.axis = .vertical
        stack.spacing = 8
        stack.distribution = .fill
        stack.alignment = .fill
        
        addSubview(stack)
        
        stack.pin(to: self)
    }
}

class TweetViewCellTrailingHeader: UIView {
    private var tweet: Tweet?
    
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
        
        addSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with tweet: Tweet) {
        self.tweet = tweet
        
        configure(nameWith: tweet.author.name)
        configure(usernameWith: tweet.author.username)
    }
    
    private func addSubviews() {
        let stack = UIStackView(arrangedSubviews: [
            nameText,
            usernameText,
            UIStackView.spacer()
        ])
        
        stack.enableAutolayout()
        stack.axis = .horizontal
        stack.spacing = 8
        stack.distribution = .fill
        stack.alignment = .center
        
        addSubview(stack)
        
        stack.pin(to: self)
    }
    
    private func configure(nameWith name: String) {
        nameText.text = name
    }
    
    private func configure(usernameWith username: String) {
        usernameText.text = "@" + username
    }
}

class TweetViewCellTrailingBody: UIView {
    private var tweet: Tweet?
    
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
        
        addSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with tweet: Tweet) {
        self.tweet = tweet
        
        configure(tweetText: tweet.text)
    }
    
    private func addSubviews() {
        addSubview(tweetText)
        
        tweetText.pin(to: self)
    }
    
    private func configure(tweetText text: String) {
        tweetText.text = text
    }
}

class TweetViewCellTrailingFooter: UIView {
    private var tweet: Tweet?
    
    private let likeButton: UIButton = {
        let likeButton = UIButton()
        
        likeButton.enableAutolayout()
        likeButton.tintColor = .gray
        likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
        likeButton.addTarget(nil, action: #selector(onLikePressed(_:)), for: .touchUpInside)
        
        likeButton.heightConstaint(with: 20)
        
        return likeButton
    }()
    
    private let commentButton: UIButton = {
        let commentButton = UIButton()
        
        commentButton.enableAutolayout()
        commentButton.tintColor = .gray
        commentButton.setImage(UIImage(systemName: "text.bubble"), for: .normal)
        commentButton.addTarget(nil, action: #selector(onCommentPressed(_:)), for: .touchUpInside)
        
        commentButton.heightConstaint(with: 20)
        
        return commentButton
    }()
    
    private let bookmarkButton: UIButton = {
        let bookmarkButton = UIButton()
        
        bookmarkButton.enableAutolayout()
        bookmarkButton.tintColor = .gray
        bookmarkButton.setImage(UIImage(systemName: "bookmark"), for: .normal)
        bookmarkButton.addTarget(nil, action: #selector(onBookmarkPressed(_:)), for: .touchUpInside)
        
        bookmarkButton.heightConstaint(with: 20)
        
        return bookmarkButton
    }()
    
    private let optionsButton: UIButton = {
        let optionsButton = UIButton()
        
        optionsButton.enableAutolayout()
        optionsButton.tintColor = .gray
        optionsButton.setImage(UIImage(systemName: "square.grid.3x3.topright.fill"), for: .normal)
        optionsButton.addTarget(nil, action: #selector(onOptionsPressed(_:)), for: .touchUpInside)
        
        return optionsButton
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with tweet: Tweet) {
        self.tweet = tweet
    }
    
    private func addSubviews() {
        let stack = UIStackView(arrangedSubviews: [
            likeButton,
            commentButton,
            bookmarkButton,
            optionsButton
        ])
        
        stack.enableAutolayout()
        stack.axis = .horizontal
        stack.spacing = 8
        stack.distribution = .equalSpacing
        stack.alignment = .center
        
        addSubview(stack)
        
        stack.pin(to: self)
    }
    
    @objc private func onLikePressed(_ sender: UIButton) {
        print(#function)
    }
    
    @objc private func onCommentPressed(_ sender: UIButton) {
        print(#function)
    }
    
    @objc private func onBookmarkPressed(_ sender: UIButton) {
        print(#function)
    }
    
    @objc private func onOptionsPressed(_ sender: UIButton) {
        print(#function)
    }
}
