//
//  TxNetworkAssistant.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 23/03/22.
//

import Foundation

enum TXNetworkFailure: Error {
    case unknown
    case internetUnavailable
    case malformedURL
    case malformedContent
}

struct TXNetworkSuccess {
    let data: Data
    let statusCode: Int
}

class TXNetworkAssistant {
    static let shared: TXNetworkAssistant = TXNetworkAssistant()
    
    enum HTTPMethod: String {
        case get = "GET"
        case post = "POST"
        case put = "PUT"
        case patch = "PATCH"
        case delete = "DELETE"
    }
    
    private init() { }
    
    func get(
        url: String,
        query: [String: String]? = nil,
        headers: [String: String]? = nil
    ) async throws -> TXNetworkSuccess {
        let result = try await request(
            url: url,
            method: .get,
            query: query,
            headers: headers,
            content: nil
        )
        
        return result
    }
    
    func post(
        url: String,
        query: [String: String]? = nil,
        headers: [String: String]? = nil,
        content: Encodable? = nil
    ) async throws -> TXNetworkSuccess {
        let result = try await request(
            url: url,
            method: .post,
            query: query,
            headers: headers,
            content: content
        )
        
        return result
    }
    
    func put(
        url: String,
        query: [String: String]? = nil,
        headers: [String: String]? = nil,
        content: Encodable? = nil
    ) async throws -> TXNetworkSuccess {
        let result = try await request(
            url: url,
            method: .put,
            query: query,
            headers: headers,
            content: content
        )
        
        return result
    }
    
    func patch(
        url: String,
        query: [String: String]? = nil,
        headers: [String: String]? = nil,
        content: Encodable? = nil
    ) async throws -> TXNetworkSuccess {
        let result = try await request(
            url: url,
            method: .patch,
            query: query,
            headers: headers,
            content: content
        )
        
        return result
    }
    
    func delete(
        url: String,
        query: [String: String]? = nil,
        headers: [String: String]? = nil
    ) async throws -> TXNetworkSuccess {
        let result = try await request(
            url: url,
            method: .delete,
            query: query,
            headers: headers,
            content: nil
        )
        
        return result
    }
    
    private func request(
        url: String,
        method: HTTPMethod,
        query: [String: String]? = nil,
        headers: [String: String]? = nil,
        content: Encodable? = nil
    ) async throws -> TXNetworkSuccess {
        if TXNetworkMonitor.shared.status == .disconnected {
            throw TXNetworkFailure.internetUnavailable
        }
        
        guard let url = URL(string: url.buildCompleteURL(query: query)) else {
            throw TXNetworkFailure.malformedURL
        }
        
        var request = URLRequest(url: url)
        
        request.setMethod(method.rawValue)
        
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
                
                let result = TXNetworkSuccess(
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

fileprivate extension URLRequest {
    mutating func setMethod(
        _ method: String
    ) {
        self.httpMethod = method
    }
    
    mutating func setHeaders(
        _ headers: [String: String]
    ) {
        for (key, value) in headers {
            self.setValue(
                value,
                forHTTPHeaderField: key
            )
        }
    }
    
    mutating func setContent(
        _ content: Encodable
    ) throws {
        self.httpBody = try JSONSerialization.data(withJSONObject: content, options: .prettyPrinted)
    }
}

fileprivate extension String {
    func buildCompleteURL(
        query: [String: String]?
    ) -> String {
        var url = self
        
        if let query = query, !query.isEmpty {
            let stringifiedQuery = query.compactMap { (key: String, value: String) in
                let encodedValue = value.addingPercentEncoding(
                    withAllowedCharacters: .alphanumerics
                )
                
                return "\(key)=\(encodedValue ?? value)"
            }.joined(separator: "&")
            
            url += ("?" + stringifiedQuery)
        }
        
        
        return url
    }
}
