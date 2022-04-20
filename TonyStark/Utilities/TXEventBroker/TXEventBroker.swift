//
//  TXEventBroker.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 20/04/22.
//

import Foundation

class TXEvent { }

class TXEventBroker {
    static let shared = TXEventBroker()
    
    typealias Listener = (_ event: TXEvent) -> Void
    
    private var listeners: [Listener] = []
    
    func listen(_ listener: @escaping Listener) {
        listeners.append(listener)
    }
    
    func emit(event: TXEvent) {
        listeners.forEach { listner in
            listner(event)
        }
    }
}


