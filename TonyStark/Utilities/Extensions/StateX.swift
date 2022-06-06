//
//  StateX.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 30/05/22.
//

import Foundation

enum State<Success, Failure> {
    case success(data: Success)
    case failure(cause: Failure)
    case processing
    
   func map<T>(
        onSuccess: (_: Success) -> T,
        onFailure: (_: Failure) -> T,
        onProcessing: () -> T
    ) -> T {
        switch self {
        case .success(let success):
            return onSuccess(success)
        case .failure(let failure):
            return onFailure(failure)
        case .processing:
            return onProcessing()
        }
    }
    
    func mapOnSuccess<T>(
        _ onSuccess: (_: Success) -> T,
        orElse: () -> T
    ) -> T {
        switch self {
        case .success(let success):
            return onSuccess(success)
        default:
            return orElse()
        }
    }
    
    func mapOnFailure<T>(
        _ onFailure: (_: Failure) -> T,
        orElse: () -> T
    ) -> T {
        switch self {
        case .failure(let failure):
            return onFailure(failure)
        default:
            return orElse()
        }
    }
}
