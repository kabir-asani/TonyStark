//
//  FeedDataStore.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 03/05/22.
//

import Foundation

protocol FeedDataStoreProtocol: DataStoreProtocol {
    func feed() async -> Result<Paginated<Tweet>, FeedFailure>
    
    func feed(after nextToken: String) async -> Result<Paginated<Tweet>, FeedFailure>
}

class FeedDataStore: FeedDataStoreProtocol {
    static let shared: FeedDataStoreProtocol = FeedDataStore()
    
    private init() { }
    
    func bootUp() async {
        // Do nothing
    }
    
    func bootDown() async {
        // Do nothing
    }

    func feed() async -> Result<Paginated<Tweet>, FeedFailure> {
        return await paginatedFeed(after: nil)
    }
    
    func feed(after nextToken: String) async -> Result<Paginated<Tweet>, FeedFailure> {
        return await paginatedFeed(after: nextToken)
    }
    
    private func paginatedFeed(after nextToken: String?) async -> Result<Paginated<Tweet>, FeedFailure> {
        let paginated: Paginated<Tweet> = await withCheckedContinuation { continuation in
            DispatchQueue
                .global(qos: .background)
                .asyncAfter(deadline: .now()) {
                    let tweets: [Tweet] = [
                        Tweet(
                            id: "ar93hdkj",
                            text: """
                            English
                            """,
                            creationDate: .now().addingTimeInterval(-24*60*60*48),
                            lastUpdatedDate: .now(),
                            interactionDetails: Tweet.InteractionDetails(
                                likesCount: 1,
                                commentsCount: 0
                            ),
                            author: User(
                                id: "sadiyakhan",
                                name: "Sadiya Khan",
                                email: "sadiya@gmail.com",
                                username: "sadiyakhan",
                                image: "https://www.mirchi9.com/wp-content/uploads/2022/02/Mahesh-Fans-Firing-on-Pooja-Hegde.jpg",
                                description: """
                                I'm simple and soft.
                                """,
                                creationDate: .now(),
                                lastUpdatedDate: .now(),
                                socialDetails: User.SocialDetails(
                                    followersCount: 0,
                                    followeesCount: 0
                                ),
                                activityDetails: User.ActivityDetails(
                                    tweetsCount: 0
                                ),
                                viewables: User.Viewables(
                                    following: false
                                )
                            ),
                            viewables: Tweet.Viewables(
                                liked: true,
                                bookmarked: true
                            )
                        ),
                        Tweet(
                            id: "ar93hdk4",
                            text: """
                            This is rather fun you know.
                            A lot has been said and done about you guys.
                            Let's rock and roll people.
                            """,
                            creationDate: .now().addingTimeInterval(-24*60*60*12),
                            lastUpdatedDate: .now(),
                            interactionDetails: Tweet.InteractionDetails(
                                likesCount: 1,
                                commentsCount: 0
                            ),
                            author: User(
                                id: "mzaink",
                                name: "Zain Khan",
                                email: "zain@gmail.com",
                                username: "mzaink",
                                image: "https://pbs.twimg.com/profile_images/1483797876522512385/9CcO904A_400x400.jpg",
                                description: """
                                Hungry for knowledge. Satiated with life. ✌️
                                """,
                                creationDate: .now(),
                                lastUpdatedDate: .now(),
                                socialDetails: User.SocialDetails(
                                    followersCount: 0,
                                    followeesCount: 0
                                ),
                                activityDetails: User.ActivityDetails(
                                    tweetsCount: 0
                                ),
                                viewables: User.Viewables(
                                    following: true
                                )
                            ),
                            viewables: Tweet.Viewables(
                                liked: true,
                                bookmarked: false
                            )
                        ),
                        Tweet(
                            id: "ar93hdk4",
                            text: """
                            I agree it's all opinions here.
                            I need to agree yours.
                            You need to agree mine.
                            Because we stand in two different phase of life and speak.
                            """,
                            creationDate: .now().addingTimeInterval(-24*60*60*4),
                            lastUpdatedDate: .now(),
                            interactionDetails: Tweet.InteractionDetails(
                                likesCount: 0,
                                commentsCount: 44
                            ),
                            author: User(
                                id: "RamyaKembal",
                                name: "Ramya kembal",
                                email: "ramya@gmail.com",
                                username: "RamyaKembal",
                                image: "https://pbs.twimg.com/profile_images/1190200299727851526/A26tGnda_400x400.jpg",
                                description: """
                                I'm simple and soft.
                                """,
                                creationDate: .now(),
                                lastUpdatedDate: .now(),
                                socialDetails: User.SocialDetails(
                                    followersCount: 0,
                                    followeesCount: 0
                                ),
                                activityDetails: User.ActivityDetails(
                                    tweetsCount: 0
                                ),
                                viewables: User.Viewables(
                                    following: true
                                )
                            ),
                            viewables: Tweet.Viewables(
                                liked: false,
                                bookmarked: true
                            )
                        ),
                        Tweet(
                            id: "ar93hdk4",
                            text: """
                            This is super fun
                            """,
                            creationDate: .now().addingTimeInterval(-24*60*60),
                            lastUpdatedDate: .now(),
                            interactionDetails: Tweet.InteractionDetails(
                                likesCount: 0,
                                commentsCount: 0
                            ),
                            author: User(
                                id: "mzaink",
                                name: "Zain Khan",
                                email: "zain@gmail.com",
                                username: "mzaink",
                                image: "https://pbs.twimg.com/profile_images/1483797876522512385/9CcO904A_400x400.jpg",
                                description: """
                                I'm simple and soft.
                                """,
                                creationDate: .now(),
                                lastUpdatedDate: .now(),
                                socialDetails: User.SocialDetails(
                                    followersCount: 0,
                                    followeesCount: 0
                                ),
                                activityDetails: User.ActivityDetails(
                                    tweetsCount: 0
                                ),
                                viewables: User.Viewables(
                                    following: true
                                )
                            ),
                            viewables: Tweet.Viewables(
                                liked: false,
                                bookmarked: true
                            )
                        ),
                        Tweet(
                            id: "ar93hdk4",
                            text: """
                            Every entrepreneur I meet says it’s so difficult to find people to work, and on the other hand the unemployment percentage is so high. Something is broken, and it needs fixing asap.
                            """,
                            creationDate: .now().addingTimeInterval(-24*60*60),
                            lastUpdatedDate: .now(),
                            interactionDetails: Tweet.InteractionDetails(
                                likesCount: 1,
                                commentsCount: 10
                            ),
                            author: User(
                                id: "GabbbarSingh",
                                name: "Gabbar",
                                email: "gabbar@gmail.com",
                                username: "GabbbarSingh",
                                image: "https://pbs.twimg.com/profile_images/1271082702326784003/1kIF_loZ_400x400.jpg",
                                description: """
                                Co-Founder @JoinZorro | Founder @GingerMonkeyIN
                                """,
                                creationDate: .now(),
                                lastUpdatedDate: .now(),
                                socialDetails: User.SocialDetails(
                                    followersCount: 0,
                                    followeesCount: 0
                                ),
                                activityDetails: User.ActivityDetails(
                                    tweetsCount: 0
                                ),
                                viewables: User.Viewables(
                                    following: true
                                )
                            ),
                            viewables: Tweet.Viewables(
                                liked: true,
                                bookmarked: true
                            )
                        ),
                    ]
                    
                    let result = Paginated<Tweet>(
                        page: tweets,
                        nextToken: nil
                    )
                    
                    continuation.resume(returning: result)
                }
        }
        
        return .success(paginated)
    }
}
