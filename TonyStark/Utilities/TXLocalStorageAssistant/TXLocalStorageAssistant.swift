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
    ) async throws -> TXLocalStorageElement<T>
    
    func retrieve<T: Storable>(
        key: String
    ) async throws -> TXLocalStorageElement<T>
    
    func update<T: Storable>(
        key: String,
        value: T
    ) async throws -> TXLocalStorageElement<T>
    
    func delete<T: Storable>(
        key: String
    ) async throws -> TXLocalStorageElement<T>
}


class TXLocalStorageAssistant {
    static let shallow: TXLocalStorageAssistantProtocol = TXShallowLocalStorageAssistant()
    static let extensive: TXLocalStorageAssistantProtocol = TXExtensiveLocalStorageAssistant()
}

class TXShallowLocalStorageAssistant: TXLocalStorageAssistantProtocol {
    func boot() async {
        // Do nothing
    }
    
    func exists(
        key: String
    ) async -> Bool {
        let encodedValue = UserDefaults.standard.object(forKey: key)
        
        return encodedValue != nil
    }
    
    func store<T: Storable>(
        key: String,
        value: T
    ) async throws -> TXLocalStorageElement<T> {
        if await exists(key: key) {
            throw TXStoreFailure.keyAlreadyExists
        }
        
        do {
            let encoder = JSONEncoder()
            
            let encodedValue = try encoder.encode(value)
            
            UserDefaults.standard.set(encodedValue, forKey: key)
            
            let result = (key: key, value: value)
            return result
        } catch {
            throw TXStoreFailure.valueNotEncodable
        }
    }
    
    func retrieve<T: Storable>(
        key: String
    ) async throws -> TXLocalStorageElement<T> {
        do {
            let decoder = JSONDecoder()
            
            if let encodedValue = UserDefaults.standard.data(forKey: key) {
                let decodedValue = try decoder.decode(T.self, from: encodedValue)
                
                let result = (key: key, value: decodedValue)
                return result
            } else {
                throw TXRetrieveFailure.keyDoesNotExists
            }
        } catch {
            throw TXRetrieveFailure.valueNotDecodable
        }
    }
    
    func update<T: Storable>(
        key: String,
        value: T
    ) async throws -> TXLocalStorageElement<T> {
        if await exists(key: key) {
            do {
                let encoder = JSONEncoder()
                
                let encodedValue = try encoder.encode(value)
                
                UserDefaults.standard.set(encodedValue, forKey: key)
                
                let result = (key: key, value: value)
                return result
            } catch {
                throw TXUpdateFailure.valueNotEncodable
            }
        } else {
            throw TXUpdateFailure.keyDoesNotExists
        }
    }
    
    func delete<T: Storable>(
        key: String
    ) async throws -> TXLocalStorageElement<T> {
        do {
            let decoder = JSONDecoder()
            
            if let encodedValue = UserDefaults.standard.data(forKey: key) {
                let decodedValue = try decoder.decode(T.self, from: encodedValue)
                
                UserDefaults.standard.set(nil, forKey: key)
                
                let result = (key: key, value: decodedValue)
                return result
            } else {
                throw TXDeleteFailure.keyDoesNotExists
            }
        } catch {
            throw TXDeleteFailure.valueNotDecodable
        }
    }
}

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
    ) async throws -> TXLocalStorageElement<T> {
        throw TXStoreFailure.unknown
    }
    
    func retrieve<T: Codable>(
        key: String
    ) async throws -> TXLocalStorageElement<T> {
        throw TXRetrieveFailure.unknown
    }
    
    func update<T: Codable>(
        key: String,
        value: T
    ) async throws -> TXLocalStorageElement<T> {
        throw TXUpdateFailure.unknown
    }
    
    func delete<T: Codable>(
        key: String
    ) async throws -> TXLocalStorageElement<T> {
        throw TXDeleteFailure.unknown
    }
}
