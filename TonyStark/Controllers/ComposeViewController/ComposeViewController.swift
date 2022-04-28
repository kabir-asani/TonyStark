//
//  ComposeViewController.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 16/03/22.
//

import UIKit

class ComposeViewController: TXTabBarController {
    // Declare
    private let composableTextView: TXTextView = {
        let composableTextView = TXTextView()
        
        composableTextView.enableAutolayout()
        composableTextView.font = .systemFont(
            ofSize: 16,
            weight: .regular
        )

        return composableTextView
    }()
    
    // Configure
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSubviews()
        
        configureNavigationBar()
        configureComposableTextView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        composableTextView.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        composableTextView.resignFirstResponder()
    }
    
    private func addSubviews() {
        view.addSubview(composableTextView)
    }
    
    private func configureNavigationBar() {
        navigationItem.title = "Compose"
        
        navigationItem.leftBarButtonItem = TXBarButtonItem(
            barButtonSystemItem: .cancel,
            target: self,
            action: #selector(onCancelPressed(_:))
        )
        
        navigationItem.rightBarButtonItem = TXBarButtonItem(
            title: "Tweet",
            style: .done,
            target: self,
            action: #selector(onDonePressed(_:))
        )
    }
    
    private func configureComposableTextView() {
        composableTextView.delegate = self
        
        composableTextView.textContainer.lineFragmentPadding = 0
        
        composableTextView.pin(
            to: view,
            withInsets: .all(16),
            byBeingSafeAreaAware: true
        )
        
        composableTextView.text = "What's happening?"
        composableTextView.textColor = UIColor.lightGray

        composableTextView.selectedTextRange = composableTextView.textRange(
            from: composableTextView.beginningOfDocument,
            to: composableTextView.beginningOfDocument
        )
    }
    
    // Populate
    
    // Interact
    @objc private func onDonePressed(_ sender: UIBarButtonItem) {
    }
    
    @objc private func onCancelPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
}

extension ComposeViewController: TXTextViewDelegate {
    func textView(
        _ textView: UITextView,
        shouldChangeTextIn range: NSRange, replacementText text: String
    ) -> Bool {
        let currentText = textView.text! as String
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: text)

        if updatedText.isEmpty {
            textView.text = "What's happening?"
            textView.textColor = .lightGray

            textView.selectedTextRange = textView.textRange(
                from: textView.beginningOfDocument,
                to: textView.beginningOfDocument
            )
        } else if textView.textColor == .lightGray && !text.isEmpty {
            textView.textColor = .label
            textView.text = text
        } else {
            return true
        }
        
        return false
    }
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        if textView.textColor == .lightGray {
            textView.selectedTextRange = textView.textRange(
                from: textView.beginningOfDocument,
                to: textView.beginningOfDocument
            )
        }
    }
}
