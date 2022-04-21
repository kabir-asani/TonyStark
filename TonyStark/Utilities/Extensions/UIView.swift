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
}

// MARK: Pin
extension UIView {
    func pin(
        to view: UIView,
        withPadding padding: TXEdgeInsets? = nil,
        byBeingSafeAreaAware safeAreaEnabled: Bool = false
    ) {
        NSLayoutConstraint.activate([
            self.topAnchor.constraint(
                equalTo: safeAreaEnabled
                ? view.safeAreaLayoutGuide.topAnchor
                : view.topAnchor,
                constant: padding?.top ?? 0
            ),
            self.bottomAnchor.constraint(
                equalTo: view.bottomAnchor,
                constant: -(padding?.bottom ?? 0)
            ),
            self.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: padding?.left ?? 0
            ),
            self.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -(padding?.right ?? 0)
            )
        ])
    }
    
    func pin(
        toTopOf view: UIView,
        withMargin margin: Double? = nil,
        byBeingSafeAreaAware safeAreaEnabled: Bool = false
    ) {
        NSLayoutConstraint.activate([
            self.topAnchor.constraint(
                equalTo: safeAreaEnabled
                ? view.safeAreaLayoutGuide.topAnchor
                : view.topAnchor,
                constant: margin ?? 0
            )
        ])
    }
    
    func pin(
        toBottomOf view: UIView,
        withMargin margin: Double? = nil,
        byBeingSafeAreaAware safeAreaEnabled: Bool = false
    ) {
        NSLayoutConstraint.activate([
            self.bottomAnchor.constraint(
                equalTo: safeAreaEnabled
                ? view.safeAreaLayoutGuide.bottomAnchor
                : view.bottomAnchor,
                constant: -(margin ?? 0)
            )
        ])
    }
    
    func pin(
        toLeftOf view: UIView,
        withMargin margin: Double? = nil,
        byBeingSafeAreaAware safeAreaEnabled: Bool = false
    ) {
        NSLayoutConstraint.activate([
            self.leftAnchor.constraint(
                equalTo: safeAreaEnabled
                ? view.safeAreaLayoutGuide.leftAnchor
                : view.leftAnchor,
                constant: margin ?? 0
            )
        ])
    }
    
    func pin(
        toRightOf view: UIView,
        withMargin margin: Double? = nil,
        byBeingSafeAreaAware safeAreaEnabled: Bool = false
    ) {
        NSLayoutConstraint.activate([
            self.rightAnchor.constraint(
                equalTo: safeAreaEnabled
                ? view.safeAreaLayoutGuide.rightAnchor
                : view.rightAnchor,
                constant: -(margin ?? 0)
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
        withMargin margin: Double? = nil
    ) {
        NSLayoutConstraint.activate([
            self.topAnchor.constraint(
                equalTo: view.bottomAnchor,
                constant: margin ?? 0
            )
        ])
    }
    
    func attach(
        bottomToTopOf view: UIView,
        withMargin margin: Double? = nil
    ) {
        NSLayoutConstraint.activate([
            self.bottomAnchor.constraint(
                equalTo: view.topAnchor,
                constant: margin ?? 0
            )
        ])
    }
    
    func attach(
        leftToRightOf view: UIView,
        withMargin margin: Double? = nil
    ) {
        NSLayoutConstraint.activate([
            self.leftAnchor.constraint(
                equalTo: view.rightAnchor,
                constant: margin ?? 0
            )
        ])
    }
    
    func attach(
        rightToLeftOf view: UIView,
        withMargin margin: Double? = nil
    ) {
        NSLayoutConstraint.activate([
            self.rightAnchor.constraint(
                equalTo: view.leftAnchor,
                constant: margin ?? 0
            )
        ])
    }
}

// MARK: Dimensions
extension UIView {
    func squareOff(with side: Double) {
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
    func addTapGestureRecognizer(target: UIView, action: Selector) {
        let gestureRecognizer = UITapGestureRecognizer(
            target: target,
            action: action
        )
        
        self.addGestureRecognizer(gestureRecognizer)
    }
}
