//
//  TxNetworkMonitor.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 06/04/22.
//

import Foundation
import Network

protocol NetworkMonitorProtocol {
    var status: NetworkMonitor.NetworkStatus { get }
    
    func start()
    
    func stop()
    
    func onStatusChanged(listener: @escaping NetworkMonitor.Listener)
}

class NetworkMonitor: NetworkMonitorProtocol {
    enum NetworkStatus {
        case connected
        case disconnected
    }
    
    typealias Listener = (_ status: NetworkStatus) -> Void
    
    static let shared: NetworkMonitorProtocol = NetworkMonitor()
    
    private let queue: DispatchQueue = DispatchQueue.global()
    private let monitor: NWPathMonitor = NWPathMonitor()
    private var listeners: [Listener] = []
    
    var status: NetworkStatus = .disconnected
    
    private init() { }
    
    func start() {
        monitor.pathUpdateHandler = {
            [weak self] path in
            let status: NetworkStatus
            
            if path.status != .unsatisfied {
                status = .connected
            } else {
                status = .disconnected
            }
            
            self?.status = status
            self?.listeners.forEach({ listener in
                listener(status)
            })
        }
        
        monitor.start(queue: queue)
    }
    
    func stop() {
        self.listeners.removeAll()
        monitor.cancel()
    }
    
    public func onStatusChanged(listener: @escaping Listener) {
        listeners.append(listener)
    }
}
