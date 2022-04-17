//
//  ProfileTableViewCell.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 17/04/22.
//

import UIKit

class ProfileTableViewCell: TXTableViewCell {
    static let reuseIdentifier = String(describing: ProfileTableViewCell.self)
    
    private var user: User?
    
    let header: ProfileTableViewCellHeader = {
        let header = ProfileTableViewCellHeader()
        
        header.enableAutolayout()
        
        return header
    }()
    
    let body: ProfileTableViewCellBody = {
        let body = ProfileTableViewCellBody()
        
        body.enableAutolayout()
        
        return body
    }()
    
    let footer: ProfileTableViewCellFooter = {
        let footer = ProfileTableViewCellFooter()
        
        footer.enableAutolayout()
        
        return footer
    }()
    
    override init(
        style: UITableViewCell.CellStyle,
        reuseIdentifier: String?
    ) {
        super.init(
            style: style,
            reuseIdentifier: reuseIdentifier
        )
        
        configureBaseView()
        configureSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func populate(with user: User) {
        self.user = user
        
        header.populate(with: user)
        body.populate(with: user)
        footer.populate(with: user)
    }
    
    
    private func configureBaseView() {
        selectionStyle = .none
        separatorInset = UIEdgeInsets(
            top: 0,
            left: Double.infinity,
            bottom: 0,
            right: 0
        )
    }
    
    private func configureSubviews() {
        let stack = UIStackView(arrangedSubviews: [
            header,
            body,
            footer
        ])
        
        stack.enableAutolayout()
        stack.axis = .vertical
        stack.distribution = .equalSpacing
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

class ProfileTableViewCellHeader: UIView {
    private var user: User?
    
    let profileImage: TXImageView = {
        let profileImage = TXCircularImageView(radius: 40)
        
        profileImage.enableAutolayout()
        
        return profileImage
    }()
    
    let editButton: TXButton = {
        let editButton = TXButton()
        
        editButton.enableAutolayout()
        editButton.widthConstraint(with: 140)
        editButton.heightConstaint(with: 40)
        editButton.setTitle("Edit", for: .normal)
        
        if #available(iOS 15.0, *) {
            editButton.setTitleColor(.label, for: .normal)
            editButton.setTitleColor(.label, for: .highlighted)
            editButton.configuration = UIButton.Configuration.bordered()
        } else {
            editButton.setTitleColor(.systemBlue, for: .normal)
            editButton.layer.borderWidth = 2
            editButton.layer.borderColor = UIColor.systemBlue.cgColor
            editButton.showsTouchWhenHighlighted = true
        }
        
        editButton.layer.cornerRadius = 22
        editButton.clipsToBounds = true
        
        return editButton
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func populate(with user: User) {
        self.user = user
        
        populate(profileImageWith: user.image)
    }
    
    private func populate(profileImageWith imageURL: String) {
        Task {
            let image = await TXImageProvider.shared.image(imageURL)
            
            if let image = image {
                DispatchQueue.main.async {
                    [weak self] in
                    self?.profileImage.image = image
                }
            }
        }
    }
    
    private func configureSubviews() {
        configureEditButton()
        
        let stack = UIStackView(arrangedSubviews: [
            profileImage,
            UIStackView.spacer,
            editButton
        ])
        
        stack.enableAutolayout()
        stack.axis = .horizontal
        stack.distribution = .fill
        stack.alignment = .center
        
        addSubview(stack)
        
        stack.pin(to: self)
    }
    
    private func configureEditButton() {
        editButton.addTarget(
            self,
            action: #selector(onEditPressed(_:)),
            for: .touchUpInside
        )
    }
    
    @objc private func onEditPressed(_ sender: UIButton) {
        print(#function)
    }
}


class ProfileTableViewCellBody: UIView {
    private var user: User?
    
    let nameText: UILabel = {
        let nameText = UILabel()
        
        nameText.enableAutolayout()
        nameText.numberOfLines = 0
        nameText.font = .systemFont(ofSize: 16, weight: .bold)
        
        return nameText
    }()
    
    let usernameText: UILabel = {
        let usernameText = UILabel()
        
        usernameText.enableAutolayout()
        usernameText.numberOfLines = 0
        usernameText.font = .systemFont(ofSize: 16, weight: .regular)
        usernameText.textColor = .gray
        
        return usernameText
    }()
    
    let bioText: UILabel = {
        let bioText = UILabel()
        
        bioText.enableAutolayout()
        bioText.numberOfLines = 0
        bioText.font = .systemFont(ofSize: 16, weight: .regular)
        
        return bioText
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func populate(with user: User) {
        self.user = user
        
        populate(nameTextWith: user.name)
        populate(usernameTextWith: user.username)
        populate(bioTextWith: user.bio)
    }
    
    private func populate(nameTextWith text: String) {
        nameText.text = text
    }
    
    private func populate(usernameTextWith text: String) {
        usernameText.text = "@\(text)"
    }
    
    private func populate(bioTextWith text: String) {
        bioText.text = text
    }
    
    private func configureSubviews() {
        let stack = UIStackView(arrangedSubviews: [
            nameText,
            usernameText,
            bioText
        ])
        
        stack.enableAutolayout()
        stack.axis = .vertical
        stack.spacing = 8
        stack.distribution = .equalSpacing
        stack.alignment = .leading
        
        addSubview(stack)
        
        stack.pin(to: self)
    }
}


class ProfileTableViewCellFooter: UIView {
    private var user: User?
    
    let followersSocialDetails: SocialDetails = {
        let followersSocialDetails = SocialDetails()
        
        followersSocialDetails.enableAutolayout()
        
        return followersSocialDetails
    }()
    
    let followingsSocialDetails: SocialDetails = {
        let followingsSocialDetails = SocialDetails()
        
        followingsSocialDetails.enableAutolayout()
        
        return followingsSocialDetails
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func populate(with user: User) {
        self.user = user
        
        followersSocialDetails.populate(
            with: (
                leadingText: "\(user.socialDetails.followersCount)",
                trailingText: "Followers"
            )
        )
        
        followingsSocialDetails.populate(
            with: (
                leadingText: "\(user.socialDetails.followingsCount)",
                trailingText: "Followings"
            )
        )
    }
    
    private func configureSubviews() {
        let stack = UIStackView(arrangedSubviews: [
            followersSocialDetails,
            followingsSocialDetails,
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
}

class SocialDetails: UIView {
    let leadingText: UILabel = {
        let leadingText = UILabel()
        
        leadingText.enableAutolayout()
        leadingText.font = .systemFont(ofSize: 16, weight: .bold)
        
        return leadingText
    }()
    
    let trailingText: UILabel = {
        let trailingText = UILabel()
        
        trailingText.enableAutolayout()
        trailingText.font = .systemFont(ofSize: 16, weight: .regular)
        trailingText.textColor = .gray
        
        return trailingText
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func populate(with data: (leadingText: String, trailingText: String)) {
        leadingText.text = data.leadingText
        trailingText.text = data.trailingText
    }
    
    private func configureSubviews() {
        let stack = UIStackView(arrangedSubviews: [
            leadingText,
            trailingText
        ])
        
        stack.enableAutolayout()
        stack.axis = .horizontal
        stack.spacing = 8
        stack.distribution = .equalSpacing
        stack.alignment = .center
        
        addSubview(stack)
        
        stack.pin(to: self)
    }
}
