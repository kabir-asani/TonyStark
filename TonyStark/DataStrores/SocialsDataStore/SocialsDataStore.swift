//
//  SocialsDataStores.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 27/04/22.
//

import Foundation

class SocialsDataStore: DataStore {
    static let shared = SocialsDataStore()
    
    static let createFollowURL = "\(SocialsDataStore.baseUrl)/self/followees"
    static let deleteFollowURL = "\(SocialsDataStore.baseUrl)/self/followees"
    static let selfFolloweesURL = "\(SocialsDataStore.baseUrl)/self/followees"
    static let selfFollowersURL = "\(SocialsDataStore.baseUrl)/self/followers"
    
    static func otherFolloweesURL(userId: String) -> String {
        "\(SocialsDataStore.baseUrl)/users/\(userId)/followees"
    }
    static func otherFollowersURL(userId: String) -> String {
        "\(SocialsDataStore.baseUrl)/users/\(userId)/followers"
    }
    
    private override  init() { }
    
    func follow(
        userWithId userId: String
    ) async -> Result<Void, FollowFailure> {
        if let session = CurrentUserDataStore.shared.session {
            do {
                let followResult = try await TXNetworkAssistant.shared.post(
                    url: Self.createFollowURL,
                    headers: secureHeaders(
                        withAccessToken: session.accessToken
                    ),
                    content: [
                        "userId": userId
                    ]
                )
                
                if followResult.statusCode == 204 {
                    TXEventBroker.shared.emit(
                        event: FollowCreatedEvent(
                            userId: userId
                        )
                    )
                    
                    return .success(Void())
                } else {
                    return .failure(.unknown)
                }
            } catch {
                return .failure(.unknown)
            }
        } else {
            return .failure(.unknown)
        }
    }
    
    func unfollow(
        userWithId userId: String
    ) async -> Result<Void, UnfollowFailure> {
        if let session = CurrentUserDataStore.shared.session {
            do {
                let unfollowResult = try await TXNetworkAssistant.shared.delete(
                    url: Self.deleteFollowURL,
                    query: [
                        "userId": userId
                    ],
                    headers: secureHeaders(
                        withAccessToken: session.accessToken
                    )
                )
                
                if unfollowResult.statusCode == 204 {
                    TXEventBroker.shared.emit(
                        event: FollowDeletedEvent(
                            userId: userId
                        )
                    )
                    
                    return .success(Void())
                } else {
                    return .failure(.unknown)
                }
            } catch {
                return .failure(.unknown)
            }
        } else {
            return .failure(.unknown)
        }
    }
    
    func followers(
        ofUserWithId userId: String,
        after nextToken: String? = nil
    ) async -> Result<Paginated<Follower>, FollowersFailure> {
        if let session = CurrentUserDataStore.shared.session, let currentUser = CurrentUserDataStore.shared.user {
            do {
                let query = nextToken != nil ? [
                    "nextToken": nextToken!
                ] : nil
                
                let followersResult = try await TXNetworkAssistant.shared.delete(
                    url: userId == currentUser.id
                    ? Self.selfFollowersURL
                    : Self.otherFollowersURL(userId: userId),
                    query: query,
                    headers: secureHeaders(
                        withAccessToken: session.accessToken
                    )
                )
                
                if followersResult.statusCode == 200 {
                    let followers = try TXJsonAssistant.decode(
                        SuccessData<Paginated<Follower>>.self,
                        from: followersResult.data
                    ).data
                    
                    return .success(followers)
                } else {
                    return .failure(.unknown)
                }
            } catch {
                return .failure(.unknown)
            }
        } else {
            return .failure(.unknown)
        }
    }
    
    func followees(
        ofUserWithId userId: String,
        after nextToken: String? = nil
    ) async -> Result<Paginated<Followee>, FollowingsFailure> {
        if let session = CurrentUserDataStore.shared.session, let currentUser = CurrentUserDataStore.shared.user {
            do {
                let query = nextToken != nil ? [
                    "nextToken": nextToken!
                ] : nil
                
                let followeesResult = try await TXNetworkAssistant.shared.delete(
                    url: userId == currentUser.id
                    ? Self.selfFolloweesURL
                    : Self.otherFolloweesURL(userId: userId),
                    query: query,
                    headers: secureHeaders(
                        withAccessToken: session.accessToken
                    )
                )
                
                if followeesResult.statusCode == 200 {
                    let followees = try TXJsonAssistant.decode(
                        SuccessData<Paginated<Followee>>.self,
                        from: followeesResult.data
                    ).data
                    
                    return .success(followees)
                } else {
                    return .failure(.unknown)
                }
            } catch {
                return .failure(.unknown)
            }
        } else {
            return .failure(.unknown)
        }
    }
}
