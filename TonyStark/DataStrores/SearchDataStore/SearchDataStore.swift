//
//  SearchDataStore.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 29/04/22.
//

import Foundation

protocol SearchDataStoreProtocol: DataStore {
    func search(withKeyword keyword: String) async -> Result<Paginated<User>, SearchFailure>
    
    func captureKeyword(_ keyword: String) async
    
    func previousSearchKeywords() async -> Result<[String], PreviousSearchKeywordsFailure>
}

class SearchDataStore: SearchDataStoreProtocol {
    static let shared: SearchDataStoreProtocol = SearchDataStore()
    
    private static let keywordsStorageKey = "keywordsStorageKey"
    
    private init() { }
    
    func bootUp() async {
        // Do nothing
    }
    
    func bootDown() async {
        // Do nothing
    }
    
    func search(withKeyword keyword: String) async -> Result<Paginated<User>, SearchFailure> {
        let paginated: Paginated<User> = await withCheckedContinuation {
            continuation in
            
            DispatchQueue
                .global(qos: .background)
                .asyncAfter(deadline: .now()) {
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
        }
        
        return .success(paginated)
    }
    
    func captureKeyword(_ keyword: String) async {
        if await TXLocalStorageAssistant.shallow.exists(key: SearchDataStore.keywordsStorageKey) {
            let previousKeywords: TXLocalStorageElement<[String]> = try! await TXLocalStorageAssistant.shallow.retrieve(
                key: SearchDataStore.keywordsStorageKey
            )
            
            do {
                // We're storing only the latest 6
                var latestKeywords = previousKeywords.value.count > 5
                ? Array(previousKeywords.value[..<5])
                : previousKeywords.value
                
                latestKeywords.insert(keyword, at: 0)
                
                let result = try await TXLocalStorageAssistant.shallow.update(
                    key: SearchDataStore.keywordsStorageKey,
                    value: latestKeywords
                )
                print(result)
            } catch {
                // Do nothing
                print(error)
            }
        } else {
            do {
                let latestKeywords = [keyword]
                
                let result = try await TXLocalStorageAssistant.shallow.store(
                    key: SearchDataStore.keywordsStorageKey,
                    value: latestKeywords
                )
                print(result)
            } catch {
                // Do nothing
                print(error)
            }
        }
    }
    
    func previousSearchKeywords() async -> Result<[String], PreviousSearchKeywordsFailure> {
        do {
            let previousKeywords: TXLocalStorageElement<[String]> = try await TXLocalStorageAssistant.shallow.retrieve(
                key: SearchDataStore.keywordsStorageKey
            )
            
            let latestKeywords = previousKeywords.value
            
            return .success(latestKeywords)
        } catch {
            // do nothing
            return .failure(.unknown)
        }
    }
}
