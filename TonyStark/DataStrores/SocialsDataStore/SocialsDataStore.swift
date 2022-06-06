//
//  SocialsDataStores.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 27/04/22.
//

import Foundation

class SocialsDataStore: DataStore {
    static let shared = SocialsDataStore()
    
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
        ofUserWithId userId: String,
        after nextToken: String? = nil
    ) async -> Result<Paginated<Follower>, FollowersFailure> {
        return .failure(.unknown)
    }
    
    func followees(
        ofUserWithId userId: String,
        after nextToken: String? = nil
    ) async -> Result<Paginated<Followee>, FollowingsFailure> {
        return .failure(.unknown)
    }
}
