//
//  TXExtensiveLocalStorageAssistant.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 06/05/22.
//

import Foundation

// TODO: Implement functionality across all TXLocalStorageAssistantProtocol's methods
class TXExtensiveLocalStorageAssistant: TXLocalStorageAssistantProtocol {
    func boot() async {
        // TODO: Implement this to create persistent storage container
    }
    
    func exists(key: String) async -> Bool {
        return false
    }
    
    func store<T: Codable>(
        key: String,
        value: T
    ) async throws {
        throw TXStoreFailure.unknown
    }
    
    func retrieve<T: Codable>(
        key: String
    ) async throws -> TXLocalStorageElement<T> {
        throw TXRetrieveFailure.unknown
    }
    
    func update<T: Codable>(
        key: String, value: T
    ) async throws {
        throw TXUpdateFailure.unknown
    }
    
    func delete(
        key: String
    ) async throws {
        throw TXDeleteFailure.unknown
    }
}
