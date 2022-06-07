//
//  TXJsonSnakeCoder.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 07/06/22.
//

import Foundation

class TXJsonSnakeCoder {
    static func encode<T: Encodable>(_ value: T) throws -> Data {
        let encoder = JSONEncoder()
        
        encoder.keyEncodingStrategy = .convertToSnakeCase
        
        return try encoder.encode(value)
    }
    
    static func decode<T: Decodable>(_ type: T.Type, from data: Data) throws -> T {
        let decoder = JSONDecoder()
        
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        return try decoder.decode(
            type,
            from: data
        )
    }
}
