//
//  UIEdgeInsets.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 22/04/22.
//

import UIKit

extension UIEdgeInsets {
    static var empty: UIEdgeInsets {
        get {
            return UIEdgeInsets(
                top: 0,
                left: Double.infinity,
                bottom: 0,
                right: 0
            )
        }
    }
}
