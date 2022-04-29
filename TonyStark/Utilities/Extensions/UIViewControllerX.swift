//
//  UIViewController.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 26/04/22.
//

import UIKit

extension UIViewController {
    func addKeyboardListenersToAdjustConstraintsOnBottomMostView() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(onKeyboardWillShow(_:)),
            name: UIWindow.keyboardWillShowNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(onKeyboardWillHide(_:)),
            name: UIWindow.keyboardWillHideNotification,
            object: nil
        )
    }
    
    func removeKeyboardListeners() {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func onKeyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo else {
            return
        }
        
        let constraint = view.constraints.first { constraint in
            constraint.secondAnchor == view.safeAreaLayoutGuide.bottomAnchor
        }
        
        if let constraint = constraint {
            let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            let keyboardHeight = keyboardFrame?.size.height ?? 0
            
            let duration: TimeInterval = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIView.AnimationOptions.curveEaseInOut.rawValue
            let animationCurve:UIView.AnimationOptions = UIView.AnimationOptions(rawValue: animationCurveRaw)
            
            let bottomTabBarHeight = tabBarController?.tabBar.frame.height ?? 0
    
            let bottomInset = keyboardHeight - bottomTabBarHeight
            
            constraint.constant = -bottomInset
            
            UIView.animate(
              withDuration: duration,
              delay: TimeInterval(0),
              options: animationCurve,
              animations: { self.view.layoutIfNeeded() },
              completion: nil
            )
        }
    }
    
    @objc func onKeyboardWillHide(_ notification: Notification) {
        let constraint = view.constraints.first { constraint in
            constraint.secondAnchor == view.safeAreaLayoutGuide.bottomAnchor
        }
        
        if let constraint = constraint {
            constraint.constant = 0
        }
    }
}
