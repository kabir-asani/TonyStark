//
//  CurrentUserProvider.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 20/04/22.
//

import Foundation

class CurrentUserProvider: Provider {
    static let shared = CurrentUserProvider()
    
    enum CurrentUserFailure: Error {
        case unknown
    }
    
    private(set) var isLoggedIn: Bool = false
    
    private(set) var user: User!
    
    private init() { }
    
    func bootUp() async {
        user = User(
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
        
        isLoggedIn = true
    }
    
    func bootDown() async {
        // Do nothing
    }
}
