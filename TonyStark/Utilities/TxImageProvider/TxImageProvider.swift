//
//  TxImageProvider.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 20/03/22.
//

import UIKit

protocol TxImageProviderProtocol {
    func image(
        _ urlString: String,
        completion: @escaping (UIImage?) -> Void
    )
}

class TxImageProvider: TxImageProviderProtocol {
    static let shared: TxImageProviderProtocol = TxImageProvider()
    
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
        
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) {
            [weak self] data, response, error in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }
            
            DispatchQueue.main.async {
                [weak self] in
                guard let image = UIImage(data: data) else {
                    completion(nil)
                    return
                }
                
                self?.cache.setObject(image, forKey: NSString(string: urlString))
                completion(image)
            }
        }
        
        task.resume()
    }
}
