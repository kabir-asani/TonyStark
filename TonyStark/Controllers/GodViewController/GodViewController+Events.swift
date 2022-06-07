//
//  Events.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 08/06/22.
//

import Foundation

class HomeEvent: TXEvent { }

class AuthenticationEvent: TXEvent { }

class ShowSnackBarEvent: TXEvent {
    let text: String
    let variant: SnackBar.Variant
    let duration: TimeInterval
    let dismissible: Bool
    
    init(
        text: String,
        variant: SnackBar.Variant = .informative,
        duration: TimeInterval = 2,
        dismissible: Bool = true
    ) {
        self.text = text
        self.variant = variant
        self.duration = duration
        self.dismissible = dismissible
    }
}

class HideSnackBarEvent: TXEvent { }
