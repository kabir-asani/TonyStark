//
//  ResultX.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 29/04/22.
//

import Foundation

extension Result {
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
