//
//  TXLocalStorageAssistant.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 09/04/22.
//

import Foundation

typealias Storable = Codable

enum TXStoreFailure: Error {
    case unknown
    case keyAlreadyExists
    case valueNotEncodable
}

enum TXRetrieveFailure: Error {
    case unknown
    case keyDoesNotExists
    case valueNotDecodable
}

enum TXUpdateFailure: Error {
    case unknown
    case keyDoesNotExists
    case valueNotEncodable
}

enum TXDeleteFailure: Error {
    case unknown
    case keyDoesNotExists
    case valueNotDecodable
}

typealias TXLocalStorageElement<T> = (key: String, value: T)

protocol TXLocalStorageAssistantProtocol {
    func boot() async
    
    func exists(
        key: String
    ) async -> Bool
    
    func store<T: Storable>(
        key: String,
        value: T
    ) async throws
    
    func retrieve<T: Storable>(
        key: String
    ) async throws -> TXLocalStorageElement<T>
    
    func update<T: Storable>(
        key: String,
        value: T
    ) async throws
    
    func delete(
        key: String
    ) async throws
}


class TXLocalStorageAssistant {
    static let shallow: TXLocalStorageAssistantProtocol = TXShallowLocalStorageAssistant()
    static let extensive: TXLocalStorageAssistantProtocol = TXExtensiveLocalStorageAssistant()
}
