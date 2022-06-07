//
//  TXAppleAssistant.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 06/06/22.
//

import Foundation

enum AppleAuthenticationFailure: Error {
    case unknown
}

class TXAppleAssistant {
    static let shared = TXAppleAssistant()
    
    private init() { }
    
    func authenticate() async -> Result<AuthenticationProfile, AppleAuthenticationFailure> {
        return .failure(.unknown)
    }
}
