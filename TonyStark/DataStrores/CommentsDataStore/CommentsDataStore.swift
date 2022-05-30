//
//  CommentsDataStore.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 20/04/22.
//

import Foundation

protocol CommentsDataStoreProtocol: DataStore {
    func comments(ofTweetWithId tweetId: String) async -> Result<Paginated<Comment>, CommentsFailure>
    
    func comments(
        ofTweetWithId tweetId: String,
        after nextToken: String
    ) async -> Result<Paginated<Comment>, CommentsFailure>
    
    func comment(withText text: String, onTweetWithId tweetId: String) async -> Result<Void, CommentFailure>
}

class CommentsDataStore: CommentsDataStoreProtocol {
    static let shared: CommentsDataStoreProtocol = CommentsDataStore()
    
    private init() { }
    
    func bootUp() async {
        // Do nothing
    }
    
    func bootDown() async {
        // Do nothing
    }
    
    func comment(withText text: String, onTweetWithId tweetId: String) async -> Result<Void, CommentFailure> {
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
    
    func comments(ofTweetWithId tweetId: String) async -> Result<Paginated<Comment>, CommentsFailure>  {
        return await paginatedComments(
            ofTweetWithId: tweetId,
            after: nil
        )
    }
    
    func comments(
        ofTweetWithId tweetId: String,
        after nextToken: String
    ) async -> Result<Paginated<Comment>, CommentsFailure> {
        return await paginatedComments(
            ofTweetWithId: tweetId,
            after: nextToken
        )
    }
    
    private func paginatedComments(
        ofTweetWithId tweetId: String,
        after nextToken: String?
    ) async -> Result<Paginated<Comment>, CommentsFailure>{
        let paginated: Paginated<Comment> = await withUnsafeContinuation {
            continuation in
            
            DispatchQueue
                .global(qos: .background)
                .asyncAfter(deadline: .now()) {
                    var comments: [Comment] = []
                    
                    for _ in 0...20 {
                        if Bool.random() {
                            comments.append(
                                Comment(
                                    id: "3939",
                                    text: "Hello World!",
                                    creationDate: .now(),
                                    tweetId: "d4had8",
                                    author: User(
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
                                    )
                                )
                            )
                        } else {
                            comments.append(
                                Comment(
                                    id: "3939",
                                    text: "Black is the color that speaks to me",
                                    creationDate: .now(),
                                    tweetId: "d4had8",
                                    author: User(
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
                                    )
                                )
                            )
                        }
                    }
                    
                    let paginated = Paginated<Comment>(
                        page: comments,
                        nextToken: nil
                    )
                    
                    continuation.resume(returning: paginated)
                }
        }
        
        return .success(paginated)
    }
}
