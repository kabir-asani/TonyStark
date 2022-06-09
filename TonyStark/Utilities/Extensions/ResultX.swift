//
//  ResultX.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 29/04/22.
//

import Foundation

extension Result {
    func map<T>(
        onSuccess: (_: Success) -> T,
        onFailure: (_: Failure) -> T
    ) -> T {
        switch self {
        case .success(let success):
            return onSuccess(success)
        case .failure(let failure):
            return onFailure(failure)
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
