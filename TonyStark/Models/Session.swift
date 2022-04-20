//
//  Session.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 13/04/22.
//

import Foundation

struct Session {
    let accessToken: String
    
    func copyWith(
        accessToken: String? = nil
    ) -> Session {
        let newSession = Session(
            accessToken: accessToken ?? self.accessToken
        )
        
        return newSession
    }
}
