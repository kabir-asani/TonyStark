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
    private static let placeholder: String = "What's happening?"
    
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
        composableTextView.text = Composer.placeholder
        composableTextView.textColor = .lightGray
        composableTextView.font = .systemFont(
            ofSize: 16,
            weight: .regular
        )

        composableTextView.selectedTextRange = composableTextView.textRange(
            from: composableTextView.beginningOfDocument,
            to: composableTextView.beginningOfDocument
        )

        return composableTextView
    }()
    
    var text: String {
        get {
            if composableTextView.isDisplayingPlaceholder {
                return ""
            } else {
                return composableTextView.text
            }
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
    
    // Configure
    func configure(withUser user: User) {
        profileImage.configure(withImageURL: user.image)
    }
    
    func focusTextView() {
        composableTextView.becomeFirstResponder()
    }
    
    func unfocusTextView() {
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

        if updatedText.isEmpty {
            textView.text = Composer.placeholder
            textView.textColor = .lightGray

            textView.selectedTextRange = textView.textRange(
                from: textView.beginningOfDocument,
                to: textView.beginningOfDocument
            )
            
            delegate?.composer(self, didChangeText: "")
            return false
        } else if textView.isDisplayingPlaceholder && !text.isEmpty {
            textView.textColor = .label
            textView.text = text
            delegate?.composer(self, didChangeText: text)
            
            return false
        } else {
            return updatedText.count <= 280
        }
    }
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        if textView.isDisplayingPlaceholder {
            textView.selectedTextRange = textView.textRange(
                from: textView.beginningOfDocument,
                to: textView.beginningOfDocument
            )
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.isDisplayingPlaceholder {
            delegate?.composer(self, didChangeText: "")
        } else {
            delegate?.composer(self, didChangeText: textView.text)
        }
    }
}

fileprivate extension UITextView {
    var isDisplayingPlaceholder: Bool {
        self.textColor == .lightGray
    }
}
