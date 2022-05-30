//
//  Social.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 13/04/22.
//

import Foundation

struct Follower {
    static func `default`() -> Follower {
        Follower(
            user: .default(),
            creationDate: .now()
        )
    }
    
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

struct Followee {
    static func `default`() -> Followee {
        Followee(
            user: .default(),
            creationDate: .now()
        )
    }
    
    let user: User
    let creationDate: Date
    
    func copyWith(
        user: User? = nil,
        creationDate: Date? = nil
    ) -> Followee {
        let newFollowing = Followee(
            user: user ?? self.user,
            creationDate: creationDate ?? self.creationDate
        )
        
        return newFollowing
    }
}
