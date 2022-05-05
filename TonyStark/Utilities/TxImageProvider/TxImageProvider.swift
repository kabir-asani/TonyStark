//
//  TxImageDataStore.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 20/03/22.
//

import UIKit

protocol TXImageDataStoreProtocol {
    func image(
        _ urlString: String
    ) async -> UIImage?
}

class TXImageDataStore: TXImageDataStoreProtocol {
    static let shared: TXImageDataStoreProtocol = TXImageDataStore()
    
    private let cache = NSCache<NSString, UIImage>()
    
    private init() { }
    
    func image(
        _ urlString: String
    ) async -> UIImage? {
        if let image = cache.object(forKey: NSString(string: urlString)) {
            return image
        }
        
        do {
            let result = try await TXNetworkAssistant.shared.get(
                url: urlString
            )
            
            if result.statusCode >= 200 && result.statusCode <= 299 {
                let image: UIImage? = await withCheckedContinuation {
                    continuation in
                    
                    DispatchQueue.main.async {
                        guard let image = UIImage(data: result.data) else {
                            continuation.resume(returning: nil)
                            return
                        }
                        
                        continuation.resume(returning: image)
                    }
                }
                
                if let image = image {
                    cache.setObject(image, forKey: NSString(string: urlString))
                }
                
                return image
            } else {
                return nil
            }
        } catch {
            return nil
        }
    }
}
