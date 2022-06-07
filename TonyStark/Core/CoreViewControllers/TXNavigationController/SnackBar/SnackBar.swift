//
//  SnackBarController.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 09/05/22.
//

import UIKit

class SnackBar: TXVisualEffectView {
    // Declare
    enum Variant {
        case informative
        case inconvenience
        case success
        case failure
        case warning
    }
    
    private let variant: Variant
    private let duration: TimeInterval
    private let dismissible: Bool
    
    private let image: TXImageView = {
        let image = TXImageView()
        
        image.enableAutolayout()
        image.squareOff(withSide: 30)
        image.contentMode = .scaleAspectFit
        image.tintColor = .label
        
        return image
    }()
    
    private let information: TXLabel = {
        let information = TXLabel()
        
        information.enableAutolayout()
        information.font = .systemFont(
            ofSize: 16,
            weight: .medium
        )
        information.numberOfLines = 0
        
        return information
    }()
    
    // Arrange
    init(
        text: String,
        variant: Variant,
        duration: TimeInterval,
        dismissible: Bool
    ) {
        self.variant = variant
        self.duration = duration
        self.dismissible = dismissible
        
        super.init(effect: UIBlurEffect(style: .prominent))
        
        self.information.text = text
        
        arrangeBaseView()
        arrangeSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func arrangeBaseView() {
        switch variant {
        case .informative:
            backgroundColor = .systemGray
            image.image = UIImage(systemName: "info.circle")
        case .inconvenience:
            backgroundColor = .systemGray
            image.image = UIImage(systemName: "exclamationmark.circle")
        case .success:
            backgroundColor = .systemGreen
            image.image = UIImage(systemName: "checkmark.seal")
        case .failure:
            backgroundColor = .systemRed
            image.image = UIImage(systemName: "multiply.circle")
        case .warning:
            backgroundColor = .systemYellow
            image.image = UIImage(systemName: "exclamationmark.triangle")
        }
        
        clipsToBounds = true
        layer.cornerRadius = 8
        
        enableAutolayout()
        addGesturesToBaseView()
    }
    
    private func arrangeSubviews() {
        let combinedStackView = makeCombinedStackView()
        
        contentView.addSubview(combinedStackView)
        
        combinedStackView.pin(
            to: contentView,
            withInsets: .all(16)
        )
    }
    
    private func makeCombinedStackView() -> TXStackView {
        let combinedStack = TXStackView(
            arrangedSubviews: [
                image,
                information
            ]
        )
        
        combinedStack.enableAutolayout()
        combinedStack.axis = .horizontal
        combinedStack.distribution = .fill
        combinedStack.alignment = .center
        combinedStack.spacing = 16
        
        return combinedStack
    }
    
    private func addGesturesToBaseView() {
        contentView.isUserInteractionEnabled = true
        
        let swipeGesture = UIPanGestureRecognizer(
            target: self,
            action: #selector(onSlideUp(_:))
        )
        
        contentView.addGestureRecognizer(swipeGesture)
    }
    
    // Configure
    
    // Interact
    @objc private func onSlideUp(_ sender: UIPanGestureRecognizer) {
        let velocity = sender.velocity(in: self)
        
        if velocity.y < 0 {
            if dismissible {
                TXEventBroker.shared.emit(
                    event: HideSnackBarEvent()
                )
            }
        }
    }
}
