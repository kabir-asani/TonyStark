//
//  BookmarksDataStore.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 27/04/22.
//

import Foundation

protocol BookmarksDataStoreProtocol: DataStore {
    func bookmark(tweetWithId tweetId: String) async -> Result<Void, BookmarkFailure>
    
    func unbookmark(tweetWithId tweetId: String) async -> Result<Void, UnbookmarkFailure>
    
    func bookmarks() async -> Result<Paginated<Tweet>, BookmarksFailure>
    
    func bookmarks(after nextToken: String) async -> Result<Paginated<Tweet>, BookmarksFailure>
}

class BookmarksDataStore: BookmarksDataStoreProtocol {
    static let shared: BookmarksDataStoreProtocol = BookmarksDataStore()
    
    private init() { }
    
    func bootUp() async {
        // Do nothing
    }
    
    func bootDown() async {
        // Do nothing
    }
    
    func bookmark(tweetWithId tweetId: String) async -> Result<Void, BookmarkFailure> {
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
    
    func unbookmark(tweetWithId tweetId: String) async -> Result<Void, UnbookmarkFailure> {
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
    
    func bookmarks() async -> Result<Paginated<Tweet>, BookmarksFailure> {
        return await paginatedBookmarks(after: nil)
    }
    
    func bookmarks(after nextToken: String) async -> Result<Paginated<Tweet>, BookmarksFailure> {
        return await paginatedBookmarks(after: nextToken)
    }
    
    func paginatedBookmarks(after nextToken: String? = nil) async -> Result<Paginated<Tweet>, BookmarksFailure> {
        let paginated: Paginated<Tweet> = await withCheckedContinuation {
            continuation in
            
            DispatchQueue
                .global(qos: .background)
                .asyncAfter(deadline: .now()) {
                    let tweets: [Tweet] = [
                        Tweet(
                            id: "ar93hdkj",
                            text: """
                            English
                            """,
                            creationDate: Date(),
                            meta: TweetMeta(
                                likesCount: 1,
                                commentsCount: 0
                            ),
                            author: User(
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
                            viewables: TweetViewables(
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
                            creationDate: Date(),
                            meta: TweetMeta(
                                likesCount: 1,
                                commentsCount: 0
                            ),
                            author: User(
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
                            viewables: TweetViewables(
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
                            creationDate: Date(),
                            meta: TweetMeta(
                                likesCount: 0,
                                commentsCount: 44
                            ),
                            author: User(
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
                            viewables: TweetViewables(
                                liked: false,
                                bookmarked: true
                            )
                        ),
                        Tweet(
                            id: "ar93hdk4",
                            text: """
                            This is super fun
                            """,
                            creationDate: Date(),
                            meta: TweetMeta(
                                likesCount: 0,
                                commentsCount: 0
                            ),
                            author: User(
                                id: "mzaink",
                                name: "Zain Khan",
                                email: "zain@gmail.com",
                                username: "mzaink",
                                image: "https://pbs.twimg.com/profile_images/1483797876522512385/9CcO904A_400x400.jpg",
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
                            viewables: TweetViewables(
                                liked: false,
                                bookmarked: true
                            )
                        ),
                        Tweet(
                            id: "ar93hdk4",
                            text: """
                            Every entrepreneur I meet says it’s so difficult to find people to work, and on the other hand the unemployment percentage is so high. Something is broken, and it needs fixing asap.
                            """,
                            creationDate: Date(),
                            meta: TweetMeta(
                                likesCount: 1,
                                commentsCount: 10
                            ),
                            author: User(
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
                            ),
                            viewables: TweetViewables(
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
