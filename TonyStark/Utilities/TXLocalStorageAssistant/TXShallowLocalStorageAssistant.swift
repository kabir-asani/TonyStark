//
//  TXShallowLocalStorageAssistant.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 06/05/22.
//

import Foundation

class TXShallowLocalStorageAssistant: TXLocalStorageAssistantProtocol {
    func boot() async {
        // Do nothing
    }
    
    func exists(
        key: String
    ) async -> Bool {
        let encodedValue = UserDefaults.standard.object(
            forKey: key
        )
        
        return encodedValue != nil
    }
    
    func store<T: Storable>(
        key: String,
        value: T
    ) async throws {
        if await exists(key: key) {
            throw TXStoreFailure.keyAlreadyExists
        }
        
        do {
            let encodedValue = try TXJsonCoder.encode(
                value
            )
            
            UserDefaults.standard.set(
                encodedValue,
                forKey: key
            )
        } catch {
            throw TXStoreFailure.valueNotEncodable
        }
    }
    
    func retrieve<T: Storable>(
        key: String
    ) async throws -> TXLocalStorageElement<T> {
        do {
            if let encodedValue = UserDefaults.standard.data(forKey: key) {
                let decodedValue = try TXJsonCoder.decode(
                    T.self,
                    from: encodedValue
                )
                
                let result = (
                    key: key,
                    value: decodedValue
                )
                
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
    ) async throws {
        if await exists(key: key) {
            do {
                let encodedValue = try TXJsonCoder.encode(
                    value
                )
                
                UserDefaults.standard.set(
                    encodedValue,
                    forKey: key
                )
            } catch {
                throw TXUpdateFailure.valueNotEncodable
            }
        } else {
            throw TXUpdateFailure.keyDoesNotExists
        }
    }
    
    func delete(
        key: String
    ) async throws {
        do {
            if await exists(key: key) {
                UserDefaults.standard.set(
                    nil,
                    forKey: key
                )
            } else {
                throw TXDeleteFailure.keyDoesNotExists
            }
        } catch {
            throw TXDeleteFailure.valueNotDecodable
        }
    }
}
