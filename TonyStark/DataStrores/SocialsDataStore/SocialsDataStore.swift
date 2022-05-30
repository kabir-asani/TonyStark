//
//  SocialsDataStores.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 27/04/22.
//

import Foundation

protocol SocialsDataStoreProtocol: DataStore {
    func follow(userWithId userId: String) async -> Result<Void, FollowFailure>
    
    func unfollow(userWithUserId userId: String) async -> Result<Void, UnfollowFailure>
    
    func followers(ofUserWithId userId: String) async -> Result<Paginated<User>, FollowersFailure>
    
    func followers(
        ofUserWithId userId: String,
        after nextToken: String
    ) async -> Result<Paginated<User>, FollowersFailure>
    
    func followings(ofUserWithId userId: String) async -> Result<Paginated<User>, FollowingsFailure>
    
    func followings(
        ofUserWithId userId: String,
        after nextToken: String
    ) async -> Result<Paginated<User>, FollowingsFailure>
}

class SocialsDataStore: SocialsDataStoreProtocol {
    static let shared: SocialsDataStoreProtocol = SocialsDataStore()
    
    private init() { }
    
    func bootUp() async {
        // Do nothing
    }
    
    func bootDown() async {
        // Do nothing
    }
    
    func follow(userWithId userId: String) async -> Result<Void, FollowFailure> {
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
    
    func unfollow(userWithUserId userId: String) async -> Result<Void, UnfollowFailure> {
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
    
    func followers(ofUserWithId userId: String) async -> Result<Paginated<User>, FollowersFailure>  {
        return await paginatedFollowers(
            ofUserWithId: userId,
            after: nil
        )
    }
    
    func followers(
        ofUserWithId userId: String,
        after nextToken: String
    ) async -> Result<Paginated<User>, FollowersFailure> {
        return await paginatedFollowers(
            ofUserWithId: userId,
            after: nextToken
        )
    }
    
    func paginatedFollowers(
        ofUserWithId userId: String,
        after nextToken: String?
    ) async -> Result<Paginated<User>, FollowersFailure> {
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
                            description: """
                            I'm simple and soft.
                            """,
                            creationDate: Date(),
                            socialDetails: UserSocialDetails(
                                followersCount: 0,
                                followeesCount: 0
                            ),
                            activityDetails: UserActivityDetails(
                                tweetsCount: 0
                            ),
                            viewables: UserViewables(
                                following: false
                            )
                        ),
                        User(
                            id: "mzaink",
                            name: "Zain Khan",
                            email: "zain@gmail.com",
                            username: "mzaink",
                            image: "https://pbs.twimg.com/profile_images/1483797876522512385/9CcO904A_400x400.jpg",
                            description: """
                            Hungry for knowledge. Satiated with life. ✌️
                            """,
                            creationDate: Date(),
                            socialDetails: UserSocialDetails(
                                followersCount: 0,
                                followeesCount: 0
                            ),
                            activityDetails: UserActivityDetails(
                                tweetsCount: 0
                            ),
                            viewables: UserViewables(
                                following: true
                            )
                        ),
                        User(
                            id: "RamyaKembal",
                            name: "Ramya kembal",
                            email: "ramya@gmail.com",
                            username: "RamyaKembal",
                            image: "https://pbs.twimg.com/profile_images/1190200299727851526/A26tGnda_400x400.jpg",
                            description: """
                            I'm simple and soft.
                            """,
                            creationDate: Date(),
                            socialDetails: UserSocialDetails(
                                followersCount: 0,
                                followeesCount: 0
                            ),
                            activityDetails: UserActivityDetails(
                                tweetsCount: 0
                            ),
                            viewables: UserViewables(
                                following: true
                            )
                        ),
                        User(
                            id: "GabbbarSingh",
                            name: "Gabbar",
                            email: "gabbar@gmail.com",
                            username: "GabbbarSingh",
                            image: "https://pbs.twimg.com/profile_images/1271082702326784003/1kIF_loZ_400x400.jpg",
                            description: """
                            Co-Founder @JoinZorro | Founder @GingerMonkeyIN
                            """,
                            creationDate: Date(),
                            socialDetails: UserSocialDetails(
                                followersCount: 0,
                                followeesCount: 0
                            ),
                            activityDetails: UserActivityDetails(
                                tweetsCount: 0
                            ),
                            viewables: UserViewables(
                                following: true
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
    
    func followings(ofUserWithId userId: String) async -> Result<Paginated<User>, FollowingsFailure> {
        return await paginatedFollowings(
            ofUserWithId: userId,
            after: nil
        )
    }
    
    func followings(
        ofUserWithId userId: String,
        after nextToken: String
    ) async -> Result<Paginated<User>, FollowingsFailure> {
        return await paginatedFollowings(
            ofUserWithId: userId,
            after: nextToken
        )
    }
    
    func paginatedFollowings(
        ofUserWithId userId: String,
        after nextToken: String?
    ) async -> Result<Paginated<User>, FollowingsFailure> {
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
                            description: """
                            I'm simple and soft.
                            """,
                            creationDate: Date(),
                            socialDetails: UserSocialDetails(
                                followersCount: 0,
                                followeesCount: 0
                            ),
                            activityDetails: UserActivityDetails(
                                tweetsCount: 0
                            ),
                            viewables: UserViewables(
                                following: false
                            )
                        ),
                        User(
                            id: "mzaink",
                            name: "Zain Khan",
                            email: "zain@gmail.com",
                            username: "mzaink",
                            image: "https://pbs.twimg.com/profile_images/1483797876522512385/9CcO904A_400x400.jpg",
                            description: """
                            Hungry for knowledge. Satiated with life. ✌️
                            """,
                            creationDate: Date(),
                            socialDetails: UserSocialDetails(
                                followersCount: 0,
                                followeesCount: 0
                            ),
                            activityDetails: UserActivityDetails(
                                tweetsCount: 0
                            ),
                            viewables: UserViewables(
                                following: true
                            )
                        ),
                        User(
                            id: "RamyaKembal",
                            name: "Ramya kembal",
                            email: "ramya@gmail.com",
                            username: "RamyaKembal",
                            image: "https://pbs.twimg.com/profile_images/1190200299727851526/A26tGnda_400x400.jpg",
                            description: """
                            I'm simple and soft.
                            """,
                            creationDate: Date(),
                            socialDetails: UserSocialDetails(
                                followersCount: 0,
                                followeesCount: 0
                            ),
                            activityDetails: UserActivityDetails(
                                tweetsCount: 0
                            ),
                            viewables: UserViewables(
                                following: true
                            )
                        ),
                        User(
                            id: "GabbbarSingh",
                            name: "Gabbar",
                            email: "gabbar@gmail.com",
                            username: "GabbbarSingh",
                            image: "https://pbs.twimg.com/profile_images/1271082702326784003/1kIF_loZ_400x400.jpg",
                            description: """
                            Co-Founder @JoinZorro | Founder @GingerMonkeyIN
                            """,
                            creationDate: Date(),
                            socialDetails: UserSocialDetails(
                                followersCount: 0,
                                followeesCount: 0
                            ),
                            activityDetails: UserActivityDetails(
                                tweetsCount: 0
                            ),
                            viewables: UserViewables(
                                following: true
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
