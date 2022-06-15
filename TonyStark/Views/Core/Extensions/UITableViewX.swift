//
//  UITableView.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 18/04/22.
//

import Foundation
import UIKit

extension UITableView {
    func beginRefreshing() {
        self.refreshControl?.beginRefreshing()
    }
    
    func endRefreshing() {
        self.refreshControl?.endRefreshing()
    }
    
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
    
    func appendSpacerOnHeader(
        withHeight height: Double = 0
    ) {
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
    
    func removeSpaceOnHeader() {
        DispatchQueue.main.async {
            [weak self] in
            guard let strongSelf = self else {
                return
            }
            
            strongSelf.tableHeaderView = nil
        }
    }
    
    func appendSpacerOnFooter(
        withHeight height: Double = 100
    ) {
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
    
    func removeSpacerOnFooter() {
        DispatchQueue.main.async {
            [weak self] in
            guard let strongSelf = self else {
                return
            }
            
            strongSelf.tableFooterView = nil
        }
    }
    
    func appendSepartorToLastMostVisibleCell() {
        if let lastMostVisibleCell = visibleCells.last {
            appendSeparatorOnCell(lastMostVisibleCell)
        }
    }
    
    func removeSeparatorOnCell(
        _ cell: UITableViewCell
    ) {
        cell.separatorInset = .leading(.infinity)
    }
    
    func appendSeparatorOnCell(
        _ cell: UITableViewCell,
        withInset insets: UIEdgeInsets = .leading(20)
    ) {
        cell.separatorInset = insets
    }
}
