//
//  SwiftX.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 28/04/22.
//

import Foundation

enum Result<Success, Failure> {
    case success(_: Success)
    case failure(_: Failure)
    
    func map<T>(
        onSuccess: (_ success: Success) -> T,
        onFailure: (_ failure: Failure) -> T
    ) -> T {
        switch self {
        case .success(let success):
            return onSuccess(success)
        case .failure(let failure):
            return onFailure(failure)
        }
    }
}
