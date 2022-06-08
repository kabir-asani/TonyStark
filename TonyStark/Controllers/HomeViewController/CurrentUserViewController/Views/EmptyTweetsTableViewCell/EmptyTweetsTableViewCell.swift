//
//  EmptyTweetsTableViewCell.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 06/05/22.
//

import UIKit

class EmptyTweetsTableViewCell: TXTableViewCell {
    // Declare
    override class var reuseIdentifier: String {
        String(describing: EmptyTweetsTableViewCell.self)
    }
    
    private let emptyTweetsImage: TXImageView = {
        let emptyTweetsImage = TXImageView()
        
        emptyTweetsImage.enableAutolayout()
        emptyTweetsImage.image = UIImage(systemName: "list.bullet.rectangle")
        emptyTweetsImage.contentMode = .scaleAspectFit
        emptyTweetsImage.squareOff(withSide: 60)
        emptyTweetsImage.tintColor = .label
        
        return emptyTweetsImage
    }()
    
    private let emptyTweetsText: TXLabel = {
        let emptyTweetsText = TXLabel()
        
        emptyTweetsText.enableAutolayout()
        emptyTweetsText.font = .systemFont(
            ofSize: 24,
            weight: .bold
        )
        emptyTweetsText.textColor = .label
        emptyTweetsText.textAlignment = .center
        
        
        return emptyTweetsText
    }()
    
    private let emptyTweetsSubtext: TXLabel = {
        let emptyTweetsSubtext = TXLabel()
        
        emptyTweetsSubtext.enableAutolayout()
        emptyTweetsSubtext.font = .systemFont(
            ofSize: 16,
            weight: .regular
        )
        emptyTweetsSubtext.textColor = .secondaryLabel
        emptyTweetsSubtext.textAlignment = .center
        emptyTweetsSubtext.numberOfLines = 0
        
        return emptyTweetsSubtext
    }()
    
    private let composeTweetButton: TXButton = {
        let composeTweetButton = TXButton()
        
        composeTweetButton.enableAutolayout()
        if #available(iOS 15.0, *) {
            composeTweetButton.tintColor = .systemBlue
            composeTweetButton.configuration = TXButton.Configuration.borderedProminent()
        } else {
            composeTweetButton.setTitleColor(
                .white,
                for: .normal
            )
            composeTweetButton.setTitleColor(
                .white.withAlphaComponent(0.8),
                for: .highlighted
            )
            composeTweetButton.contentEdgeInsets = .symmetric(
                horizontal: 16,
                vertical: 8
            )
            composeTweetButton.backgroundColor = .systemBlue
            composeTweetButton.clipsToBounds = true
            composeTweetButton.layer.cornerRadius = 8
        }
        
        return composeTweetButton
    }()
    
    
    // Arrange
    override init(
        style: UITableViewCell.CellStyle,
        reuseIdentifier: String?
    ) {
        super.init(
            style: style,
            reuseIdentifier: reuseIdentifier
        )
        
        arrangeBaseView()
        arrangeSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func arrangeBaseView() {
        selectionStyle = .none
    }
    
    private func arrangeSubviews() {
        arrangeEmptyFeedText()
        arrangeEmptySubText()
        arrangeSearchButton()
        
        let combinedStackView = makeCombinedStackView()
        
        addSubview(combinedStackView)
        
        combinedStackView.pin(
            to: self,
            withInsets: .symmetric(
                horizontal: 16,
                vertical: 32
            )
        )
    }
    
    private func makeCombinedStackView() -> TXStackView {
        let combinedStack = TXStackView(
            arrangedSubviews: [
                emptyTweetsImage,
                emptyTweetsText,
                emptyTweetsSubtext,
                composeTweetButton
            ]
        )
        
        combinedStack.enableAutolayout()
        combinedStack.axis = .vertical
        combinedStack.distribution = .equalSpacing
        combinedStack.alignment = .center
        combinedStack.spacing = 16
        
        return combinedStack
    }
    
    private func arrangeEmptyFeedText() {
        emptyTweetsText.text = "Your Tweets"
    }
    
    private func arrangeEmptySubText() {
        emptyTweetsSubtext.text = "When you compose tweets, they'll show up here"
    }
    
    private func arrangeSearchButton() {
        composeTweetButton.setTitle(
            "Compose Tweet",
            for: .normal
        )
        
        composeTweetButton.addTarget(
            self,
            action: #selector(onComposeTweetPressed(_:)),
            for: .touchUpInside
        )
    }
    
    // Configure
    
    
    // Interact
    @objc private func onComposeTweetPressed(_ sender: TXButton) {
        TXEventBroker.shared.emit(
            event: HomeTabSwitchEvent(
                tab: .feed
            )
        )
    }
}
