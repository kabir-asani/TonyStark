//
//  UIViewController.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 26/04/22.
//

import UIKit

extension UIViewController {
    func startKeyboardAwareness() {
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
    
    func stopKeyboardAwareness() {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func onKeyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo else {
            return
        }
        
        let constraint = view.constraints.first { constraint in
            constraint.secondAnchor == view.safeAreaLayoutGuide.bottomAnchor
            ||
            constraint.secondAnchor == view.bottomAnchor
        }
        
        if let constraint = constraint {
            let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            let keyboardHeight = keyboardFrame?.size.height ?? 0
            
            let duration = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIView.AnimationOptions.curveEaseInOut.rawValue
            let animationCurve = UIView.AnimationOptions(rawValue: animationCurveRaw)
            
            let bottomTabBarHeight = tabBarController?.tabBar.frame.height ?? 0
            let bottomSafeAreaInset = view.safeAreaInsets.bottom
    
            let bottomInset = keyboardHeight - bottomTabBarHeight - bottomSafeAreaInset
            
            constraint.constant = -bottomInset
            
            UIView.animate(
              withDuration: duration,
              delay: 0,
              options: animationCurve,
              animations: {
                  [weak self] in
                  guard let strongSelf = self else {
                      return
                  }
                  
                  strongSelf.view.layoutIfNeeded()
              },
              completion: nil
            )
        }
    }
    
    @objc func onKeyboardWillHide(_ notification: Notification) {
        guard let userInfo = notification.userInfo else {
            return
        }
        
        let constraint = view.constraints.first { constraint in
            constraint.secondAnchor == view.safeAreaLayoutGuide.bottomAnchor
            ||
            constraint.secondAnchor == view.bottomAnchor
        }
        
        if let constraint = constraint {
            let duration = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIView.AnimationOptions.curveEaseInOut.rawValue
            let animationCurve = UIView.AnimationOptions(rawValue: animationCurveRaw)
            
            constraint.constant = 0
            
            UIView.animate(
              withDuration: duration,
              delay: 0,
              options: animationCurve,
              animations: {
                  [weak self] in
                  guard let strongSelf = self else {
                      return
                  }
                  
                  strongSelf.view.layoutIfNeeded()
              },
              completion: nil
            )
        }
    }
    
    func showUnknownFailureSnackBar() {
        TXEventBroker.shared.emit(
            event: ShowSnackBarEvent(
                text: "Something Went Wrong!",
                variant: .failure
            )
        )
    }
}
