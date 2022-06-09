//
//  StateX.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 30/05/22.
//

import Foundation

enum State<Success, Failure> {
    case success(Success)
    case failure(Failure)
    case processing
    
   func map<T>(
        onSuccess: (Success) -> T,
        onFailure: (Failure) -> T,
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
        _ onSuccess: (Success) -> T,
        orElse: () -> T
    ) -> T {
        switch self {
        case .success(let success):
            return onSuccess(success)
        default:
            return orElse()
        }
    }
    
    func mapOnlyOnSuccess<T>(
        _ onSuccess: (Success) -> T
    ) -> T? {
        switch self {
        case .success(let success):
            return onSuccess(success)
        default:
            return nil
        }
    }
    
    func mapOnFailure<T>(
        _ onFailure: (Failure) -> T,
        orElse: () -> T
    ) -> T {
        switch self {
        case .failure(let failure):
            return onFailure(failure)
        default:
            return orElse()
        }
    }
    
    func mapOnlyOnFailure<T>(
        _ onFailure: (Failure) -> T
    ) -> T? {
        switch self {
        case .failure(let failure):
            return onFailure(failure)
        default:
            return nil
        }
    }
}
