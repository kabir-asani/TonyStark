//
//  Social.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 13/04/22.
//

import Foundation

struct Follower {
    let user: User
    let creationDate: Date
    
    func copyWith(
        user: User? = nil,
        creationDate: Date? = nil
    ) -> Follower {
        let newFollower = Follower(
            user: user ?? self.user,
            creationDate: creationDate ?? self.creationDate
        )
        
        return newFollower
    }
}

struct Following {
    let user: User
    let creationDate: Date
    
    func copyWith(
        user: User? = nil,
        creationDate: Date? = nil
    ) -> Following {
        let newFollowing = Following(
            user: user ?? self.user,
            creationDate: creationDate ?? self.creationDate
        )
        
        return newFollowing
    }
}
