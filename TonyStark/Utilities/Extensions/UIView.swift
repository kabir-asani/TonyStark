//
//  UIViewExtensions.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 14/04/22.
//

import UIKit

extension UIView {
    func pin(
        to view: UIView,
        padding: UIEdgeInsets? = nil
    ) {
        NSLayoutConstraint.activate([
            self.topAnchor.constraint(
                equalTo: view.topAnchor,
                constant: padding?.top ?? 0
            ),
            self.bottomAnchor.constraint(
                equalTo: view.bottomAnchor,
                constant: padding?.bottom ?? 0
            ),
            self.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: padding?.left ?? 0
            ),
            self.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: padding?.right ?? 0
            )
        ])
    }
    
    func pin(
        toVerticalCenterOf verticalParent: UIView? = nil,
        toHorizonCenterOf horizontalParent: UIView? = nil
    ) {
        if let view = verticalParent {
            NSLayoutConstraint.activate([
                self.centerYAnchor.constraint(
                    equalTo: view.centerYAnchor
                )
            ])
        }
        
        if let view = horizontalParent {
            NSLayoutConstraint.activate([
                self.centerXAnchor.constraint(
                    equalTo: view.centerXAnchor
                )
            ])
        }
    }
    
    func squareOffConstraint(with side: Double) {
        NSLayoutConstraint.activate([
            self.widthAnchor.constraint(equalToConstant: side),
            self.heightAnchor.constraint(equalTo: self.widthAnchor)
        ])
    }
    
    func widthConstraint(with width: Double) {
        NSLayoutConstraint.activate([
            self.widthAnchor.constraint(equalToConstant: width)
        ])
    }
    
    func heightConstaint(with height: Double) {
        NSLayoutConstraint.activate([
            self.heightAnchor.constraint(equalToConstant: height)
        ])
    }
    
    func enableAutolayout() {
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}
