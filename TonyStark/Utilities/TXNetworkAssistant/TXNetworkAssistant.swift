//
//  TxNetworkAssistant.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 23/03/22.
//

import Foundation


enum TXNetworkError: Error {
    case unknownError
    case urlError
    case statusCodeError(statusCode: Int)
    case decodeError
}

typealias TXNetworkable = Codable

class TXNetworkAssistant {
    private let baseUrl: String
    
    init(baseUrl: String) {
        self.baseUrl = baseUrl
    }
    
    func get<T: TXNetworkable>(
        path: String,
        query: [String: Codable] = [:],
        headers: [String: String] = [:],
        completion: @escaping (Result<T, TXNetworkError>) -> Void
    ) {
        guard let url = URL(string: buildCompleteURL(withPath: path, query: query)) else {
            completion(.failure(.urlError))
            return
        }
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "GET"
        
        headers.forEach { (key: String, value: String) in
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        URLSession.shared.dataTask(with: request) {
            data, response, error in
            guard error == nil else {
                // TODO: Handle this case
                completion(.failure(.unknownError))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.unknownError))
                return
            }
            
            if httpResponse.statusCode != 200 {
                completion(.failure(.statusCodeError(statusCode: httpResponse.statusCode)))
                return
            }
            
            guard let data = data else {
                completion(.failure(.unknownError))
                return
            }
            
            let decoder = JSONDecoder()
            
            do {
                let result = try decoder.decode(T.self, from: data)
                
                completion(.success(result))
            } catch {
                completion(.failure(.decodeError))
            }
        }
    }
    
    func post<T: TXNetworkable>(
        path: String,
        headers: [String: String] = [:],
        query: [String: Codable] = [:],
        content: Codable,
        completion: @escaping (Result<T, TXNetworkError>) -> Void
    ) {
        completion(.failure(.unknownError))
    }
    
    func put<T: TXNetworkable>(
        path: String,
        headers: [String: String] = [:],
        query: [String: Codable] = [:],
        content: Codable,
        completion: @escaping (Result<T, TXNetworkError>) -> Void
    ) {
        completion(.failure(.unknownError))
    }
    
    func patch<T: TXNetworkable>(
        path: String,
        headers: [String: String] = [:],
        query: [String: Codable] = [:],
        content: Codable,
        completion: @escaping (Result<T, TXNetworkError>) -> Void
    ) {
        completion(.failure(.unknownError))
    }
    
    func delete<T: TXNetworkable>(
        path: String,
        headers: [String: String] = [:],
        query: [String: Codable] = [:],
        content: Codable,
        completion: @escaping (Result<T, TXNetworkError>) -> Void
    ) {
        completion(.failure(.unknownError))
    }
    
    private func buildCompleteURL(
        withPath path: String,
        query: [String: Codable]
    ) -> String {
        var url = baseUrl.hasSuffix("/") ? baseUrl + path : baseUrl + "/" + path
        
        if !query.isEmpty {
            let stringifiedQuery = query.compactMap { "\($0)=\($1)" }.joined(separator: "&")
            
            url += ("?" + stringifiedQuery)
        }
        
        return url
    }
}

extension Dictionary where Key == String, Value == Codable {
    enum Stringify {
        case stringified(string: String)
        case empty
    }
    
    func stringify() -> Stringify {
        let parsed = self.compactMap { "\($0)=\($1)"}.joined(separator: "&")
        
        if parsed.isEmpty {
            let result: Stringify = .empty
            return result
        }
        
        let result: Stringify = .stringified(string: parsed)
        return result
    }
}
