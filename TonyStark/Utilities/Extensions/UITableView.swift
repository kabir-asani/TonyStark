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
            if let strongSelf = self {
                let activityIndicator = UIActivityIndicatorView()
                strongSelf.tableFooterView = activityIndicator
                                
                activityIndicator.enableAutolayout()
                activityIndicator.fixHeight(to: 80)
                activityIndicator.align(toHorizonCenterOf: strongSelf)

                activityIndicator.startAnimating()
            }
        }
    }
    
    func hideActivityIndicatorAtTheBottomOfTableView() {
        DispatchQueue.main.async {
            [weak self] in
            if let strongSelf = self {
                strongSelf.tableFooterView = nil
            }
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
