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
    static var zero: TXEdgeInsets = all(0)
    
    static func all(_ inset: Double) -> TXEdgeInsets {
        return TXEdgeInsets(
            top: inset,
            right: inset,
            bottom: inset,
            left: inset
        )
    }
    
    static func symmetric(
        horizontal horizontalInset: Double = 0,
        vertical verticalInset: Double = 0
    ) -> TXEdgeInsets {
        return TXEdgeInsets(
            top: verticalInset,
            right: horizontalInset,
            bottom: verticalInset,
            left: horizontalInset
        )
    }
}
