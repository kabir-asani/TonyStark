//
//  UITableView.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 18/04/22.
//

import Foundation
import UIKit

extension UITableView {
    func beginPaginating() {
        DispatchQueue.main.async {
            [weak self] in
            guard let strongSelf = self else {
                return
            }
            
            let activityIndicator = TXActivityIndicatorView(
                frame: .init(
                    x: 0,
                    y: 0,
                    width: 0,
                    height: 40
                )
            )
            
            strongSelf.tableFooterView = activityIndicator

            activityIndicator.startAnimating()
        }
    }
    
    func endPaginating() {
        DispatchQueue.main.async {
            [weak self] in
            guard let strongSelf = self else {
                return
            }
            
            strongSelf.tableFooterView = nil
        }
    }
    
    func addBufferOnHeader(withHeight height: Double) {
        DispatchQueue.main.async {
            [weak self] in
            guard let strongSelf = self else {
                return
            }
            
            let buffer = TXView(
                frame: .init(
                    x: 0,
                    y: 0,
                    width: 0,
                    height: height
                )
            )
            
            strongSelf.tableHeaderView = buffer
        }
    }
    
    func removeBufferOnHeader() {
        DispatchQueue.main.async {
            [weak self] in
            guard let strongSelf = self else {
                return
            }
            
            strongSelf.tableHeaderView = nil
        }
    }
    
    func addBufferOnFooter(withHeight height: Double) {
        DispatchQueue.main.async {
            [weak self] in
            guard let strongSelf = self else {
                return
            }
            
            let buffer = TXView(
                frame: .init(
                    x: 0,
                    y: 0,
                    width: 0,
                    height: height
                )
            )
            
            strongSelf.tableFooterView = buffer
        }
    }
    
    func removeBufferOnFooter() {
        DispatchQueue.main.async {
            [weak self] in
            guard let strongSelf = self else {
                return
            }
            
            strongSelf.tableFooterView = nil
        }
    }
    
    func dequeueReusableCell(
        withIdentifier identifier: String,
        assigning indexPath: IndexPath
    ) -> TXTableViewCell {
        let cell = dequeueReusableCell(
            withIdentifier: identifier,
            for: indexPath
        ) as! TXTableViewCell
        
        cell.indexPath = indexPath
        
        return cell
    }
}
