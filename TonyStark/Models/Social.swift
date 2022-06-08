//
//  Social.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 13/04/22.
//

import Foundation

struct Follower: Model {
    static var `default`: Follower {
        Follower(
            user: .default,
            creationDate: .current
        )
    }
    
    let user: User
    let creationDate: Date
    
    func copyWith(
        user: User? = nil,
        creationDate: Date? = nil
    ) -> Follower {
        Follower(
            user: user ?? self.user,
            creationDate: creationDate ?? self.creationDate
        )
    }
}

struct Followee: Model {
    static var `default`: Followee {
        Followee(
            user: .default,
            creationDate: .current
        )
    }
    
    let user: User
    let creationDate: Date
    
    func copyWith(
        user: User? = nil,
        creationDate: Date? = nil
    ) -> Followee {
        Followee(
            user: user ?? self.user,
            creationDate: creationDate ?? self.creationDate
        )
    }
}
