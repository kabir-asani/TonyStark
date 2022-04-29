//
//  UITableView.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 18/04/22.
//

import Foundation
import UIKit

extension UITableView {
    func showActivityIndicatorAtTheBottomOfTableView() {
        DispatchQueue.main.async {
            [weak self] in
            guard let strongSelf = self else {
                return
            }
            
            let activityIndicator = UIActivityIndicatorView(
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
    
    func hideActivityIndicatorAtTheBottomOfTableView() {
        DispatchQueue.main.async {
            [weak self] in
            guard let strongSelf = self else {
                return
            }
            
            strongSelf.tableFooterView = nil
        }
    }
    
    func dequeueReusableCellWithIndexPath(
        withIdentifier identifier: String,
        for indexPath: IndexPath
    ) -> TXTableViewCell {
        let cell = dequeueReusableCell(
            withIdentifier: identifier,
            for: indexPath
        ) as! TXTableViewCell
        
        cell.indexPath = indexPath
        
        return cell
    }
}
