//
//  ComposeTableViewCell.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 29/04/22.
//

import UIKit

protocol ComposerDelegate: AnyObject {
    func composer(
        _ composer: Composer,
        didChangeText text: String
    )
}

class Composer: TXView {
    // Declare
    weak var delegate: ComposerDelegate?
    
    private var profileImage: AvatarImage = {
        let profileImage = AvatarImage(size: .small)
        
        profileImage.enableAutolayout()
        
        return profileImage
    }()
    
    private let composableTextView: TXTextView = {
        let composableTextView = TXTextView()
        
        composableTextView.enableAutolayout()
        composableTextView.keyboardDismissMode = .none
        composableTextView.font = .systemFont(
            ofSize: 16,
            weight: .regular
        )
        
        return composableTextView
    }()
    
    private let placeholderLabel : TXLabel = {
        let placeholderLabel = TXLabel()
        
        placeholderLabel.enableAutolayout()
        placeholderLabel.sizeToFit()
        placeholderLabel.font = .systemFont(
            ofSize: 16,
            weight: .regular
        )
        placeholderLabel.textColor = .systemGray
        placeholderLabel.text = "What's happening?"
        
        return placeholderLabel
    }()
    
    var text: String {
        get {
            composableTextView.text
        }
    }
    
    // Arrange
    override init(
        frame: CGRect
    ) {
        super.init(frame: frame)
        
        arrangeSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func arrangeSubviews() {
        addSubview(profileImage)
        addSubview(composableTextView)
        
        arrangeProfileImage()
        arrangeComposeTextView()
        arrangePlaceholderLabel()
    }
    
    private func arrangeProfileImage() {
        profileImage.pin(toTopOf: self)
        profileImage.pin(toLeftOf: self)
    }
    
    private func arrangeComposeTextView() {
        composableTextView.delegate = self
        
        composableTextView.attach(
            leftToRightOf: profileImage,
            withMargin: 8
        )
        composableTextView.pin(toTopOf: self)
        composableTextView.pin(toRightOf: self)
        composableTextView.pin(toBottomOf: self)
    }
    
    private func arrangePlaceholderLabel() {
        composableTextView.addSubview(placeholderLabel)
        
        placeholderLabel.pin(
            toLeftOf: composableTextView,
            withInset: 5
        )
        placeholderLabel.pin(
            toTopOf: composableTextView,
            withInset: 8
        )
    }
    
    // Configure
    func configure(withUser user: User) {
        profileImage.configure(withImageURL: user.image)
    }
    
    override func becomeFirstResponder() -> Bool {
        composableTextView.becomeFirstResponder()
    }
    
    override func resignFirstResponder() -> Bool {
        composableTextView.resignFirstResponder()
    }
    
    // Interact
}

// MARK: TXTextViewDelegate
extension Composer: TXTextViewDelegate {
    func textView(
        _ textView: UITextView,
        shouldChangeTextIn range: NSRange,
        replacementText text: String
    ) -> Bool {
        let currentText = textView.text! as String
        let updatedText = (currentText as NSString).replacingCharacters(
            in: range,
            with: text
        )
        
        return updatedText.count <= 280
    }
    
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
        
        delegate?.composer(self, didChangeText: textView.text)
    }
}
