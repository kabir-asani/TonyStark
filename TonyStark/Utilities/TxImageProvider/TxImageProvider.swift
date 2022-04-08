//
//  TxImageProvider.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 20/03/22.
//

import UIKit

protocol TXImageProviderProtocol {
    func image(
        _ urlString: String,
        completion: @escaping (UIImage?) -> Void
    )
}

class TXImageProvider: TXImageProviderProtocol {
    static let shared: TXImageProviderProtocol = TXImageProvider()
    
    private let cache = NSCache<NSString, UIImage>()
    
    private init() {}
    
    func image(
        _ urlString: String,
        completion: @escaping (UIImage?) -> Void
    ) {
        if let image = cache.object(forKey: NSString(string: urlString)) {
            completion(image)
            return
        }
        
        TXNetworkAssistant.shared.get(
            url: urlString,
            query: nil,
            headers: nil
        ) { result in
            switch result {
            case .failure(_):
                completion(nil)
            case .success(let success):
                if success.statusCode >= 200 && success.statusCode <= 299 {
                    DispatchQueue.main.async {
                        [weak self] in
                        guard let image = UIImage(data: success.data) else {
                            completion(nil)
                            return
                        }
                        
                        self?.cache.setObject(image, forKey: NSString(string: urlString))
                        completion(image)
                    }
                } else {
                    completion(nil)
                }
            }
        }
    }
}
