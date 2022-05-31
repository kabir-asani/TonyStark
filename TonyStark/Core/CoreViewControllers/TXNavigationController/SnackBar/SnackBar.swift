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
        variant: Variant = .informative,
        duration: TimeInterval = 2
    ) {
        self.variant = variant
        self.duration = duration
        
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
            dismissSnackBar()
        }
    }
}

extension SnackBar {
    func present() {
        dismissPreviousSnackBar {
            [weak self] in
            guard let strongSelf = self else {
                return
            }
            
            if let keyWindow = AppDelegate.keyWindow {
                keyWindow.addSubview(strongSelf)
                
                strongSelf.pin(
                    toLeftOf: keyWindow,
                    withInset: 16,
                    byBeingSafeAreaAware: true
                )
                strongSelf.pin(
                    toRightOf: keyWindow,
                    withInset: 16,
                    byBeingSafeAreaAware: true
                )
                strongSelf.pin(
                    toTopOf: keyWindow,
                    byBeingSafeAreaAware: false
                )
                
                let hiddenSnackbarTransform = CGAffineTransform(
                    translationX: 0,
                    y: strongSelf.frame.size.height - keyWindow.safeAreaInsets.top
                )
                
                strongSelf.layer.setAffineTransform(hiddenSnackbarTransform)
                
                UIView.animate(
                    withDuration: 0.2,
                    delay: 0,
                    options: .curveEaseIn
                ) {
                    [weak self] in
                    guard let strongSelf = self else {
                        return
                    }
                    
                    let visibleSnackbarTransform = CGAffineTransform(
                        translationX: 0,
                        y: keyWindow.safeAreaInsets.top + 16
                    )
                    
                    strongSelf.layer.setAffineTransform(visibleSnackbarTransform)
                } completion: {
                    [weak self] completed in
                    guard let strongSelf = self else {
                        return
                    }
                    
                    if completed {
                        DispatchQueue.main.asyncAfter(deadline: .now() + strongSelf.duration) {
                            [weak self] in
                            guard let strongSelf = self else {
                                return
                            }
                            
                            strongSelf.dismissSnackBar()
                        }
                    }
                }
            }
        }
    }
    
    func dismissSnackBar() {
        UIView.animate(
            withDuration: 0.1,
            delay: 0,
            options: .curveEaseInOut
        ) {
            [weak self] in
            guard let strongSelf = self else {
                return
            }
            
            let hiddenSnackbarTransform = CGAffineTransform(
                translationX: 0,
                y: -strongSelf.frame.size.height
            )
            
            strongSelf.layer.setAffineTransform(hiddenSnackbarTransform)
        } completion: {
            [weak self] completed in
            guard let strongSelf = self else {
                return
            }
            
            if completed {
                strongSelf.removeFromSuperview()
            }
        }
    }
    
    private func dismissPreviousSnackBar(completion: (() -> Void)? = nil) {
        if let keyWindow = AppDelegate.keyWindow {
            let mayBeSnackBar = keyWindow.subviews.first {
                view in
                
                if view is SnackBar {
                    return true
                }
                
                return false
            }
            
            if let snackBar = mayBeSnackBar as? SnackBar {
                snackBar.dismissSnackBar()
                completion?()
            } else {
                completion?()
            }
        } else {
            completion?()
        }
    }
}
