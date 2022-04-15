//
//  TxNetworkAssistant.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 23/03/22.
//

import Foundation

enum TXNetworkFailure: Error {
    case unknown
    case malformedURL
    case malformedContent
}

typealias TXNetworkSuccess = (
    data: Data,
    statusCode: Int
)

class TXNetworkAssistant {
    static let shared: TXNetworkAssistant = TXNetworkAssistant()
    
    private init() { }
    
    func get(
        url baseURL: String,
        query: [String: String]? = nil,
        headers: [String: String]? = nil
    ) async throws -> TXNetworkSuccess {
        let result = try await request(
            url: baseURL,
            method: "GET",
            headers: headers,
            query: query,
            content: nil
        )
        
        return result
    }
    
    func post(
        url baseURL: String,
        headers: [String: String]? = nil,
        query: [String: String]? = nil,
        content: Encodable
    ) async throws -> TXNetworkSuccess {
        let result = try await request(
            url: baseURL,
            method: "POST",
            headers: headers,
            query: query,
            content: content
        )
        
        return result
    }
    
    func put(
        url baseURL: String,
        headers: [String: String]? = nil,
        query: [String: String]? = nil,
        content: Encodable
    ) async throws -> TXNetworkSuccess {
        let result = try await request(
            url: baseURL,
            method: "PUT",
            headers: headers,
            query: query,
            content: content
        )
        
        return result
    }
    
    func patch(
        url baseURL: String,
        headers: [String: String]? = nil,
        query: [String: String]? = nil,
        content: Encodable
    ) async throws -> TXNetworkSuccess {
        let result = try await request(
            url: baseURL,
            method: "PATCH",
            headers: headers,
            query: query,
            content: content
        )
        
        return result
    }
    
    func delete(
        url baseURL: String,
        query: [String: String]? = nil,
        headers: [String: String]? = nil
    ) async throws -> TXNetworkSuccess {
        let result = try await request(
            url: baseURL,
            method: "DELETE",
            headers: headers,
            query: query,
            content: nil
        )
        
        return result
    }
    
    private func request(
        url baseURL: String,
        method: String,
        headers: [String: String]? = nil,
        query: [String: String]? = nil,
        content: Encodable?
    ) async throws -> TXNetworkSuccess {
        guard let url = URL(string: baseURL.buildCompleteURL(query: query)) else {
            throw TXNetworkFailure.malformedURL
        }
        
        var request = URLRequest(url: url)
        
        request.setMethod(method)
        
        if let headers = headers {
            request.setHeaders(headers)
        }
        
        if let content = content {
            do {
                try request.setContent(content)
            } catch {
                throw TXNetworkFailure.malformedContent
            }
        }
        
        let result: TXNetworkSuccess = try await withCheckedThrowingContinuation { continuation in
            let task = URLSession.shared.dataTask(with: request) {
                data, response, error in
                guard error == nil else {
                    continuation.resume(throwing: TXNetworkFailure.unknown)
                    return
                }
                
                guard let response = response as? HTTPURLResponse else {
                    continuation.resume(throwing: TXNetworkFailure.unknown)
                    return
                }
                
                guard let data = data else {
                    continuation.resume(throwing: TXNetworkFailure.unknown)
                    return
                }
                
                let result = (
                    data: data,
                    statusCode: response.statusCode
                )
                
                continuation.resume(returning: result)
            }
            
            task.resume()
        }
        
        return result
    }
}

extension URLRequest {
    mutating func setMethod(_ method: String) {
        self.httpMethod = method
    }
    
    mutating func setHeaders(_ headers: [String: String]) {
        for (key, value) in headers {
            self.setValue(
                value,
                forHTTPHeaderField: key
            )
        }
    }
    
    mutating func setContent(_ content: Encodable) throws {
        self.httpBody = try JSONSerialization.data(withJSONObject: content, options: .prettyPrinted)
    }
}

extension String {
    func buildCompleteURL(query: [String: String]?) -> String {
        var url = self
        
        if let query = query, !query.isEmpty {
            let stringifiedQuery = query.compactMap { "\($0)=\($1)" }.joined(separator: "&")
            
            url += ("?" + stringifiedQuery)
        }
        
        return url
    }
}
