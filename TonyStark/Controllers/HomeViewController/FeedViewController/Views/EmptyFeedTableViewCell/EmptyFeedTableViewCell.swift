//
//  EmptyFeedTableViewCell.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 06/05/22.
//

import UIKit

class EmptyFeedTableViewCell: TXTableViewCell {
    // Declare
    override class var reuseIdentifier: String {
        String(describing: EmptyFeedTableViewCell.self)
    }
    
    private let emptyFeedText: TXLabel = {
        let emptyFeedText = TXLabel()
        
        emptyFeedText.enableAutolayout()
        emptyFeedText.font = .systemFont(
            ofSize: 24,
            weight: .bold
        )
        emptyFeedText.textColor = .label
        emptyFeedText.textAlignment = .center
        
        
        return emptyFeedText
    }()
    
    private let emptyFeedSubtext: TXLabel = {
        let emptyFeedSubtext = TXLabel()
        
        emptyFeedSubtext.enableAutolayout()
        emptyFeedSubtext.font = .systemFont(
            ofSize: 16,
            weight: .regular
        )
        emptyFeedSubtext.textColor = .secondaryLabel
        emptyFeedSubtext.textAlignment = .center
        emptyFeedSubtext.numberOfLines = 0
        
        return emptyFeedSubtext
    }()
    
    private let searchButton: TXButton = {
        let searchButton = TXButton()
        
        searchButton.enableAutolayout()
        if #available(iOS 15.0, *) {
            searchButton.tintColor = .systemBlue
            searchButton.configuration = TXButton.Configuration.borderless()
        } else {
            searchButton.setTitleColor(
                .white,
                for: .normal
            )
            searchButton.setTitleColor(
                .white.withAlphaComponent(0.8),
                for: .highlighted
            )
        }
        
        return searchButton
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
        separatorInset = .leading(.infinity)
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
                horizontal: 32,
                vertical: 150
            )
        )
    }
    
    private func makeCombinedStackView() -> TXStackView {
        let combinedStack = TXStackView(
            arrangedSubviews: [
                emptyFeedText,
                emptyFeedSubtext,
                searchButton
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
        emptyFeedText.text = "Your Feed"
    }
    
    private func arrangeEmptySubText() {
        emptyFeedSubtext.text = "When you follow people, you'll see there tweets here"
    }
    
    private func arrangeSearchButton() {
        searchButton.setTitle(
            "Search TwitterX",
            for: .normal
        )
        
        searchButton.addTarget(
            self,
            action: #selector(onSearchTwitterXPressed(_:)),
            for: .touchUpInside
        )
    }
    
    // Configure
    
    
    // Interact
    @objc private func onSearchTwitterXPressed(_ sender: TXButton) {
        TXEventBroker.shared.emit(
            event: HomeTabSwitchEvent(
                tab: .explore
            )
        )
    }
}
