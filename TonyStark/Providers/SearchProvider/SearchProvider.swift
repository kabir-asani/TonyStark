//
//  SearchProvider.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 29/04/22.
//

import Foundation


class SearchProvider: Provider {
    static let shared = SearchProvider()
    
    enum SearchFailure: Error {
        case unknown
    }
    
    private init() { }
    
    func bootUp() async {
        
    }
    
    func bootDown() async {
        
    }
    
    func search(withKeyword keyword: String) async -> Result<Paginated<User>, SearchFailure> {
        let paginated: Paginated<User> = await withCheckedContinuation({ continuation in
            DispatchQueue.global(qos: .background).asyncAfter(deadline: .now()) {
                let users: [User] = [
                    User(
                        id: "sadiyakhan",
                        name: "Sadiya Khan",
                        username: "sadiyakhan",
                        image: "https://www.mirchi9.com/wp-content/uploads/2022/02/Mahesh-Fans-Firing-on-Pooja-Hegde.jpg",
                        bio: """
                        I'm simple and soft.
                        """,
                        creationDate: Date(),
                        socialDetails: UserSocialDetails(
                            followersCount: 0,
                            followingsCount: 0
                        ),
                        activityDetails: UserActivityDetails(
                            tweetsCount: 0
                        ),
                        viewables: UserViewables(
                            follower: false
                        )
                    ),
                    User(
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
                        viewables: UserViewables(
                            follower: true
                        )
                    ),
                    User(
                        id: "RamyaKembal",
                        name: "Ramya kembal",
                        username: "RamyaKembal",
                        image: "https://pbs.twimg.com/profile_images/1190200299727851526/A26tGnda_400x400.jpg",
                        bio: """
                        I'm simple and soft.
                        """,
                        creationDate: Date(),
                        socialDetails: UserSocialDetails(
                            followersCount: 0,
                            followingsCount: 0
                        ),
                        activityDetails: UserActivityDetails(
                            tweetsCount: 0
                        ),
                        viewables: UserViewables(
                            follower: true
                        )
                    ),
                    User(
                        id: "GabbbarSingh",
                        name: "Gabbar",
                        username: "GabbbarSingh",
                        image: "https://pbs.twimg.com/profile_images/1271082702326784003/1kIF_loZ_400x400.jpg",
                        bio: """
                        Co-Founder @JoinZorro | Founder @GingerMonkeyIN
                        """,
                        creationDate: Date(),
                        socialDetails: UserSocialDetails(
                            followersCount: 0,
                            followingsCount: 0
                        ),
                        activityDetails: UserActivityDetails(
                            tweetsCount: 0
                        ),
                        viewables: UserViewables(
                            follower: true
                        )
                    )
                ]
                
                
                let filteredUsers = users.filter { user in
                    user.username.lowercased().hasPrefix(keyword.lowercased())
                }
                
                let result = Paginated<User>(
                    page: filteredUsers,
                    nextToken: nil
                )
                
                continuation.resume(returning: result)
            }
        })
        
        return .success(paginated)
    }
}
