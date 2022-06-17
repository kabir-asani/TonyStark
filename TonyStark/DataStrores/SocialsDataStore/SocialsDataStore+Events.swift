//
//  SocialsDataStore+Events.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 16/06/22.
//

import Foundation

class FollowCreatedEvent: TXEvent {
    let userId: String
    
    init(userId: String) {
        self.userId = userId
    }
}

class FollowDeletedEvent: TXEvent {
    let userId: String
    
    init(userId: String) {
        self.userId = userId
    }
}
