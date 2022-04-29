//
//  UIViewExtensions.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 14/04/22.
//

import UIKit

// MARK: Main
extension UIView {
    func enableAutolayout() {
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    static var spacer: UIView {
        UIView()
    }
}

// MARK: Pin
extension UIView {
    func pin(
        to view: UIView,
        withInsets insets: TXEdgeInsets? = nil,
        byBeingSafeAreaAware safeAreaEnabled: Bool = false
    ) {
        NSLayoutConstraint.activate([
            self.topAnchor.constraint(
                equalTo: safeAreaEnabled
                ? view.safeAreaLayoutGuide.topAnchor
                : view.topAnchor,
                constant: insets?.top ?? 0
            ),
            self.bottomAnchor.constraint(
                equalTo: safeAreaEnabled
                ? view.safeAreaLayoutGuide.bottomAnchor
                : view.bottomAnchor,
                constant: -(insets?.bottom ?? 0)
            ),
            self.leadingAnchor.constraint(
                equalTo: safeAreaEnabled
                ? view.safeAreaLayoutGuide.leadingAnchor
                : view.leadingAnchor,
                constant: insets?.left ?? 0
            ),
            self.trailingAnchor.constraint(
                equalTo: safeAreaEnabled
                ? view.safeAreaLayoutGuide.trailingAnchor
                : view.trailingAnchor,
                constant: -(insets?.right ?? 0)
            )
        ])
    }
    
    func pin(
        toTopOf view: UIView,
        withInset inset: Double? = nil,
        byBeingSafeAreaAware safeAreaEnabled: Bool = false
    ) {
        NSLayoutConstraint.activate([
            self.topAnchor.constraint(
                equalTo: safeAreaEnabled
                ? view.safeAreaLayoutGuide.topAnchor
                : view.topAnchor,
                constant: inset ?? 0
            )
        ])
    }
    
    func pin(
        toBottomOf view: UIView,
        withInset inset: Double? = nil,
        byBeingSafeAreaAware safeAreaEnabled: Bool = false
    ) {
        NSLayoutConstraint.activate([
            self.bottomAnchor.constraint(
                equalTo: safeAreaEnabled
                ? view.safeAreaLayoutGuide.bottomAnchor
                : view.bottomAnchor,
                constant: -(inset ?? 0)
            )
        ])
    }
    
    func pin(
        toLeftOf view: UIView,
        withInset inset: Double? = nil,
        byBeingSafeAreaAware safeAreaEnabled: Bool = false
    ) {
        NSLayoutConstraint.activate([
            self.leadingAnchor.constraint(
                equalTo: safeAreaEnabled
                ? view.safeAreaLayoutGuide.leadingAnchor
                : view.leadingAnchor,
                constant: inset ?? 0
            )
        ])
    }
    
    func pin(
        toRightOf view: UIView,
        withInset inset: Double? = nil,
        byBeingSafeAreaAware safeAreaEnabled: Bool = false
    ) {
        NSLayoutConstraint.activate([
            self.trailingAnchor.constraint(
                equalTo: safeAreaEnabled
                ? view.safeAreaLayoutGuide.trailingAnchor
                : view.trailingAnchor,
                constant: -(inset ?? 0)
            )
        ])
    }
}

// MARK: Alignment
extension UIView {
    func align(
        toVerticalCenterOf view: UIView
    ) {
        NSLayoutConstraint.activate([
            self.centerYAnchor.constraint(
                equalTo: view.centerYAnchor
            )
        ])
    }
    
    func align(
        toHorizonCenterOf view: UIView
    ) {
        NSLayoutConstraint.activate([
            self.centerXAnchor.constraint(
                equalTo: view.centerXAnchor
            )
        ])
    }
}

// MARK: Attach
extension UIView {
    func attach(
        topToBottomOf view: UIView,
        withMargin margin: Double? = nil,
        byBeingSafeAreaAware safeAreaEnabled: Bool = false
    ) {
        NSLayoutConstraint.activate([
            self.topAnchor.constraint(
                equalTo: safeAreaEnabled
                ? view.safeAreaLayoutGuide.bottomAnchor
                : view.bottomAnchor,
                constant: -(margin ?? 0)
            )
        ])
    }
    
    func attach(
        bottomToTopOf view: UIView,
        withMargin margin: Double? = nil,
        byBeingSafeAreaAware safeAreaEnabled: Bool = false
    ) {
        NSLayoutConstraint.activate([
            self.bottomAnchor.constraint(
                equalTo: safeAreaEnabled
                ? view.safeAreaLayoutGuide.topAnchor
                : view.topAnchor,
                constant: margin ?? 0
            )
        ])
    }
    
    func attach(
        leftToRightOf view: UIView,
        withMargin margin: Double? = nil,
        byBeingSafeAreaAware safeAreaEnabled: Bool = false
    ) {
        NSLayoutConstraint.activate([
            self.leadingAnchor.constraint(
                equalTo: safeAreaEnabled
                ? view.safeAreaLayoutGuide.trailingAnchor
                : view.trailingAnchor,
                constant: margin ?? 0
            )
        ])
    }
    
    func attach(
        rightToLeftOf view: UIView,
        withMargin margin: Double? = nil,
        byBeingSafeAreaAware safeAreaEnabled: Bool = false
    ) {
        NSLayoutConstraint.activate([
            self.trailingAnchor.constraint(
                equalTo: safeAreaEnabled
                ? view.safeAreaLayoutGuide.leadingAnchor
                : view.leadingAnchor,
                constant: -(margin ?? 0)
            )
        ])
    }
}

// MARK: Dimensions
extension UIView {
    func squareOff(withSide side: Double) {
        NSLayoutConstraint.activate([
            self.widthAnchor.constraint(equalToConstant: side),
            self.heightAnchor.constraint(equalTo: self.widthAnchor)
        ])
    }
    
    func fixWidth(to width: Double) {
        NSLayoutConstraint.activate([
            self.widthAnchor.constraint(equalToConstant: width)
        ])
    }
    
    func fixHeight(to height: Double) {
        NSLayoutConstraint.activate([
            self.heightAnchor.constraint(equalToConstant: height)
        ])
    }
    
    func restrictWidth(toAbove width: Double) {
        NSLayoutConstraint.activate([
            self.widthAnchor.constraint(greaterThanOrEqualToConstant: width)
        ])
    }
    
    func restrictHeight(toAbove height: Double) {
        NSLayoutConstraint.activate([
            self.heightAnchor.constraint(greaterThanOrEqualToConstant: height)
        ])
    }
    
    func restrictWidth(toWithin width: Double) {
        NSLayoutConstraint.activate([
            self.widthAnchor.constraint(lessThanOrEqualToConstant: width)
        ])
    }
    
    func restrictHeight(toWithin height: Double) {
        NSLayoutConstraint.activate([
            self.heightAnchor.constraint(lessThanOrEqualToConstant: height)
        ])
    }
    
    func matchWidth(of view: UIView) {
        NSLayoutConstraint.activate([
            self.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
    }
    
    func matchHeight(of view: UIView) {
        NSLayoutConstraint.activate([
            self.heightAnchor.constraint(equalTo: view.heightAnchor)
        ])
    }
}

// MARK: Gestures
extension UIView {
    func addTapGestureRecognizer(
        target: UIView,
        action: Selector
    ) {
        let gestureRecognizer = UITapGestureRecognizer(
            target: target,
            action: action
        )
        
        self.addGestureRecognizer(gestureRecognizer)
    }
    
    func addDoubleTagGestureRecognizer(
        target: UIView,
        action: Selector
    ) {
        let gestureRecognizer = UITapGestureRecognizer(
            target: target,
            action: action
        )
        
        gestureRecognizer.numberOfTapsRequired = 2
        
        self.addGestureRecognizer(gestureRecognizer)
    }
    
    func addLongPressGestureRecognizer(
        target: UIView,
        action: Selector
    ) {
        let gestureRecognizer = UILongPressGestureRecognizer(
            target: target,
            action: action
        )
        
        self.addGestureRecognizer(gestureRecognizer)
    }
}
