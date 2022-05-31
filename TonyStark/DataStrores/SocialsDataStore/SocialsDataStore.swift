//
//  SocialsDataStores.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 27/04/22.
//

import Foundation

protocol SocialsDataStoreProtocol: DataStore {
    func follow(
        userWithId userId: String
    ) async -> Result<Void, FollowFailure>
    
    func unfollow(
        userWithId userId: String
    ) async -> Result<Void, UnfollowFailure>
    
    func followers(
        ofUserWithId userId: String
    ) async -> Result<Paginated<Follower>, FollowersFailure>
    
    func followers(
        ofUserWithId userId: String,
        after nextToken: String
    ) async -> Result<Paginated<Follower>, FollowersFailure>
    
    func followees(
        ofUserWithId userId: String
    ) async -> Result<Paginated<Followee>, FollowingsFailure>
    
    func followees(
        ofUserWithId userId: String,
        after nextToken: String
    ) async -> Result<Paginated<Followee>, FollowingsFailure>
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
    
    func follow(
        userWithId userId: String
    ) async -> Result<Void, FollowFailure> {
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
    
    func unfollow(
        userWithId userId: String
    ) async -> Result<Void, UnfollowFailure> {
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
    
    func followers(
        ofUserWithId userId: String
    ) async -> Result<Paginated<Follower>, FollowersFailure>  {
        return await paginatedFollowers(
            ofUserWithId: userId,
            after: nil
        )
    }
    
    func followers(
        ofUserWithId userId: String,
        after nextToken: String
    ) async -> Result<Paginated<Follower>, FollowersFailure> {
        return await paginatedFollowers(
            ofUserWithId: userId,
            after: nextToken
        )
    }
    
    func paginatedFollowers(
        ofUserWithId userId: String,
        after nextToken: String?
    ) async -> Result<Paginated<Follower>, FollowersFailure> {
        let paginatedFollowers = Paginated<Follower>(
            page: [],
            nextToken: nil
        )
        
        return .success(paginatedFollowers)
    }
    
    func followees(
        ofUserWithId userId: String
    ) async -> Result<Paginated<Followee>, FollowingsFailure> {
        return await paginatedFollowees(
            ofUserWithId: userId,
            after: nil
        )
    }
    
    func followees(
        ofUserWithId userId: String,
        after nextToken: String
    ) async -> Result<Paginated<Followee>, FollowingsFailure> {
        return await paginatedFollowees(
            ofUserWithId: userId,
            after: nextToken
        )
    }
    
    func paginatedFollowees(
        ofUserWithId userId: String,
        after nextToken: String?
    ) async -> Result<Paginated<Followee>, FollowingsFailure> {
        let paginatedFollowees = Paginated<Followee>(
            page: [],
            nextToken: nil
        )
        
        return .success(paginatedFollowees)
    }
}
