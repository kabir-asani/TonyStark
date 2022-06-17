//
//  Social.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 13/04/22.
//

import Foundation

struct Follower: Model {
    struct Viewables: Model {
        static var `default`: Viewables {
            Viewables(
                follower: .default
            )
        }
        
        let follower: User
        
        func copyWith(
            follower: User? = nil
        ) -> Viewables {
            Viewables(
                follower: follower ?? self.follower
            )
        }
    }
    
    static var `default`: Follower {
        Follower(
            followerId: "",
            creationDate: .current,
            viewables: .default
        )
    }
    
    let followerId: String
    let creationDate: Date
    let viewables: Viewables
    
    func copyWith(
        followerId: String? = nil,
        creationDate: Date? = nil,
        viewables: Viewables? = nil
    ) -> Follower {
        Follower(
            followerId: followerId ?? self.followerId,
            creationDate: creationDate ?? self.creationDate,
            viewables: viewables ?? self.viewables
        )
    }
}

struct Followee: Model {
    struct Viewables: Model {
        static var `default`: Viewables {
            Viewables(
                followee: .default
            )
        }
        
        let followee: User
        
        func copyWith(
            followee: User? = nil
        ) -> Viewables {
            Viewables(
                followee: followee ?? self.followee
            )
        }
    }
    
    static var `default`: Followee {
        Followee(
            followeeId: "",
            creationDate: .current,
            viewables: .default
        )
    }
    
    let followeeId: String
    let creationDate: Date
    let viewables: Viewables
    
    func copyWith(
        followeeId: String? = nil,
        creationDate: Date? = nil,
        viewables: Viewables? = nil
    ) -> Followee {
        Followee(
            followeeId: followeeId ?? self.followeeId,
            creationDate: creationDate ?? self.creationDate,
            viewables: viewables ?? self.viewables
        )
    }
}
