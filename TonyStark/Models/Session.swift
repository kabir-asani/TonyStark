//
//  Session.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 13/04/22.
//

import Foundation

struct Session {
    let id: String
    let userId: String
    let creationDate: Date
    
    func copyWith(
        id: String? = nil,
        userId: String? = nil,
        creationDate: Date? = nil
    ) -> Session {
        let newSession = Session(
            id: id ?? self.id,
            userId: userId ?? self.userId,
            creationDate: creationDate ?? self.creationDate
        )
        
        return newSession
    }
}
