//
//  LikesDataStore.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 25/04/22.
//

import Foundation

protocol LikesDataStoreProtocol: DataStore {
    func likes(onTweetWithId tweetId: String) async -> Result<Paginated<User>, LikesFailure>
    
    func likes(
        onTweetWithId tweetId: String,
        after nextToken: String
    ) async -> Result<Paginated<User>, LikesFailure>
    
    func like(tweetWithId tweetId: String) async -> Result<Void, LikeFailure>
    
    func unlike(tweetWithId tweetId: String) async -> Result<Void, UnlikeFailure>
}

class LikesDataStore: LikesDataStoreProtocol {
    static let shared: LikesDataStoreProtocol = LikesDataStore()
    
    private init() { }
    
    func bootUp() async {
        // Do nothing
    }
    
    func bootDown() async {
        // Do nothing
    }

    func like(tweetWithId tweetId: String) async -> Result<Void, LikeFailure> {
        let _: Void = await withUnsafeContinuation {
            continuation in
                
            DispatchQueue
                .global(qos: .background)
                .asyncAfter(deadline: .now()) {
                    continuation.resume(returning: Void())
                }
        }
        
        return .success(Void())
    }
    
    func unlike(tweetWithId tweetId: String) async -> Result<Void, UnlikeFailure> {
        let _: Void = await withUnsafeContinuation {
            continuation in
                
            DispatchQueue
                .global(qos: .background)
                .asyncAfter(deadline: .now()) {
                    continuation.resume(returning: Void())
                }
        }
        
        return .success(Void())
    }
    
    func likes(onTweetWithId tweetId: String) async -> Result<Paginated<User>, LikesFailure> {
        return await paginatedLikes(onTweetWithId: tweetId, after: nil)
    }
    
    func likes(
        onTweetWithId tweetId: String,
        after nextToken: String
    ) async -> Result<Paginated<User>, LikesFailure> {
        return await paginatedLikes(onTweetWithId: tweetId, after: nextToken)
    }
    
    private func paginatedLikes(
        onTweetWithId tweetId: String,
        after nextToken: String?
    ) async -> Result<Paginated<User>, LikesFailure> {
        let paginated: Paginated<User> = await withCheckedContinuation {
            continuation in
            
            DispatchQueue
                .global(qos: .background)
                .asyncAfter(deadline: .now()) {
                    let users: [User] = [
                        User(
                            id: "sadiyakhan",
                            name: "Sadiya Khan",
                            email: "sadiya@gmail.com",
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
                            email: "zain@gmail.com",
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
                            email: "ramya@gmail.com",
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
                            email: "gabbar@gmail.com",
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
                    
                    let result = Paginated<User>(
                        page: users,
                        nextToken: nil
                    )
                    
                    continuation.resume(returning: result)
                }
        }
        
        return .success(paginated)
    }
}
