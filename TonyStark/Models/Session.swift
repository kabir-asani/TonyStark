//
//  Session.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 13/04/22.
//

import Foundation

struct Session: Model {
    static var `default`: Session {
        Session(
            accessToken: ""
        )
    }
    
    let accessToken: String
    
    func copyWith(
        accessToken: String? = nil
    ) -> Session {
        Session(
            accessToken: accessToken ?? self.accessToken
        )
    }
}
