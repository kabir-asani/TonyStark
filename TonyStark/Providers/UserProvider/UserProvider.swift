//
//  UserProvider.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 17/04/22.
//

import Foundation

class UserProvider {
    static let current = CurrentUserProvider()
    static let other = OtherUserProvider()
}

class OtherUserProvider {
    
}

enum CurrentUserProviderFailure: Error {
    case unknown
}

class CurrentUserProvider {
    func user() async -> Result<User, CurrentUserProviderFailure> {
        let result: User = await withCheckedContinuation { continuation in
            DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + 2) {
                let user = User(
                    id: "mzaink",
                    name: "Zain Khan",
                    username: "mzaink",
                    image: "https://pbs.twimg.com/profile_images/1483797876522512385/9CcO904A_400x400.jpg",
                    bio: """
                    Hungry for knowledge. Satiated with life. ✌️
                    """,
                    creationDate: Date(),
                    socialDetails: UserSocialDetails(
                        followersCount: 0,
                        followingsCount: 0
                    ),
                    activityDetails: UserActivityDetails(
                        tweetsCount: 0
                    ),
                    viewables: UserViewables(follower: true)
                )
                
                
                continuation.resume(returning: user)
            }
        }
        
        return .success(result)
    }
}
