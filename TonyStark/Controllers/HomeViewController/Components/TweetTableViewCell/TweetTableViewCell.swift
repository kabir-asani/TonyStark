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
        
        configureSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func populate(with tweet: Tweet) {
        self.tweet = tweet
        
        leading.populate(with: tweet)
        trailing.populate(with: tweet)
    }
    
    private func configureSubviews() {
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
    
    private let profileImage: TXCircularImageView = {
        let profileImage = TXCircularImageView(radius: 22)
        
        profileImage.enableAutolayout()
        profileImage.backgroundColor = .lightGray
        
        return profileImage
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func populate(with tweet: Tweet) {
        self.tweet = tweet
        
        populate(imageWith: tweet.author.image)
    }
    
    private func populate(imageWith imageURL: String) {
        Task {
            let image = await TXImageProvider.shared.image(imageURL)
            
            DispatchQueue.main.async {
                [weak self] in
                guard let image = image else { return }
                self?.profileImage.image = image
            }
        }
    }
    
    private func configureSubviews() {
        addSubview(profileImage)
        
        profileImage.pin(to: self)
    }
}

class TweetViewCellTrailing: UIView {
    private var tweet: Tweet?
    
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
        
        configureSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func populate(with tweet: Tweet) {
        self.tweet = tweet
        
        header.populate(with: tweet)
        body.configure(with: tweet)
        footer.populate(with: tweet)
    }
    
    private func configureSubviews() {
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
    
    func populate(with tweet: Tweet) {
        self.tweet = tweet
        
        populate(nameTextWith: tweet.author.name)
        populate(usernameTextWith: tweet.author.username)
    }
    
    private func addSubviews() {
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
    
    private func populate(nameTextWith name: String) {
        nameText.text = name
    }
    
    private func populate(usernameTextWith username: String) {
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
        
        likeButton.heightConstaint(with: 20)
        
        return likeButton
    }()
    
    private let commentButton: UIButton = {
        let commentButton = UIButton()
        
        commentButton.enableAutolayout()
        commentButton.tintColor = .gray
        commentButton.setImage(UIImage(systemName: "text.bubble"), for: .normal)
        
        commentButton.heightConstaint(with: 20)
        
        return commentButton
    }()
    
    private let optionsButton: UIButton = {
        let optionsButton = UIButton()
        
        optionsButton.enableAutolayout()
        optionsButton.tintColor = .gray
        optionsButton.setImage(UIImage(systemName: "tray.full"), for: .normal)
        if #available(iOS 14.0, *) {
            optionsButton.showsMenuAsPrimaryAction = true
        }
        
        optionsButton.heightConstaint(with: 20)
        
        return optionsButton
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func populate(with tweet: Tweet) {
        self.tweet = tweet
        
        populate(optionsButtonWith: tweet)
    }
    
    private func populate(optionsButtonWith tweet: Tweet) {
        if #available(iOS 14.0, *) {
            optionsButton.showsMenuAsPrimaryAction = true
            optionsButton.menu = UIMenu(
                title: "",
                children: [
                    UIAction(
                        title: tweet.viewables.bookmarked ? "Remove bookmark" : "Bookmark",
                        image: UIImage(systemName: tweet.viewables.bookmarked ? "bookmark.fill" : "bookmark")
                    ) { action in
                        
                    },
                    UIAction(
                        title: tweet.author.viewables.follower
                        ? "Unfollow"
                        : "Follow",
                        image: UIImage(
                            systemName: tweet.author.viewables.follower
                            ? "person.badge.plus.fill"
                            : "person.badge.plus"
                        )
                    ) { action in
                        
                    }
                ]
            )
        }
    }
    
    private func configureSubviews() {
        configureLikeButton()
        configureCommentButton()
        configureOptionsButton()
        
        let stack = UIStackView(
            arrangedSubviews: [
                likeButton,
                commentButton,
                UIStackView.spacer,
                optionsButton,
            ]
        )
        
        stack.enableAutolayout()
        stack.axis = .horizontal
        stack.spacing = 16
        stack.distribution = .fill
        stack.alignment = .center
        
        addSubview(stack)
        
        stack.pin(to: self)
    }
    
    private func configureLikeButton() {
        likeButton.addTarget(
            self,
            action: #selector(onLikePressed(_:)),
            for: .touchUpInside
        )
    }
    
    private func configureCommentButton() {
        commentButton.addTarget(
            self,
            action: #selector(onCommentPressed(_:)),
            for: .touchUpInside
        )
    }
    
    private func configureOptionsButton() {
        optionsButton.addTarget(
            self,
            action: #selector(onOptionsPressed(_:)),
            for: .touchUpInside
        )
    }
    
    @objc private func onLikePressed(
        _ sender: UIButton
    ) {
        print(#function)
    }
    
    @objc private func onCommentPressed(
        _ sender: UIButton
    ) {
        print(#function)
    }
    
    @objc private func onOptionsPressed(
        _ sender: UIButton
    ) {
        print(#function)
    }
}
