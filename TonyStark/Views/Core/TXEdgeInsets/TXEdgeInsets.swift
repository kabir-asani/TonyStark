//
//  TXEdgeInsets.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 21/04/22.
//

import UIKit

struct TXEdgeInsets {
    let top: Double
    let right: Double
    let bottom: Double
    let left: Double
}

extension TXEdgeInsets {
    static func all(_ inset: Double) -> TXEdgeInsets {
        return TXEdgeInsets(
            top: inset,
            right: inset,
            bottom: inset,
            left: inset
        )
    }
}
