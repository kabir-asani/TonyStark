//
//  UIViewController.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 26/04/22.
//

import UIKit

// MARK: Keyboard
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
}

// MARK: SnackBar
extension UIViewController {
    func showSnackBar(
        text: String,
        variant: SnackBar.Variant = .informative,
        duration: TimeInterval = 2,
        dismissible: Bool = true
    ) async {
        await hideSnackBar()
        
        let snackBar = SnackBar(
            text: text,
            variant: variant,
            duration: duration,
            dismissible: dismissible
        ) {
            Task {
                [weak self] in
                guard let strongSelf = self else {
                    return
                }
                
                await strongSelf.hideSnackBar()
            }
        }
        
        view.addSubview(snackBar)
        
        snackBar.pin(
            toLeftOf: view,
            withInset: 16,
            byBeingSafeAreaAware: true
        )
        snackBar.pin(
            toRightOf: view,
            withInset: 16,
            byBeingSafeAreaAware: true
        )
        snackBar.pin(
            toTopOf: view,
            byBeingSafeAreaAware: false
        )
        
        let hiddenSnackbarTransform = CGAffineTransform(
            translationX: 0,
            y: snackBar.frame.size.height - view.safeAreaInsets.top
        )
        
        snackBar.layer.setAffineTransform(hiddenSnackbarTransform)
        
        UIView.animate(
            withDuration: 0.1,
            delay: 0,
            options: .curveLinear
        ) {
            [weak self] in
            guard let strongSelf = self else {
                return
            }
            
            
            let visibleSnackbarTransform = CGAffineTransform(
                translationX: 0,
                y: strongSelf.view.safeAreaInsets.top + 16
            )
            
            snackBar.layer.setAffineTransform(visibleSnackbarTransform)
        } completion: {
            completed in
            
            if completed {
                Timer.scheduledTimer(withTimeInterval: 2, repeats: false) {
                    timer in
                    timer.invalidate()
                    
                    Task {
                        [weak self] in
                        guard let strongSelf = self else {
                            return
                        }
                        
                        await strongSelf.hideSnackBar(snackBar)
                    }
                }
            }
        }
    }
    
    func hideSnackBar(
        _ snackBar: SnackBar? = nil
    ) async {
        let mayBeSnackBar = snackBar ?? view.subviews.first {
            view in
            
            if view is SnackBar {
                return true
            }
            
            return false
        }
        
        if let snackBar = mayBeSnackBar {
            let _: Void = await withUnsafeContinuation({
                continuation in
                UIView.animate(
                    withDuration: 0.1,
                    delay: 0,
                    options: .curveLinear
                ) {
                    let hiddenSnackbarTransform = CGAffineTransform(
                        translationX: 0,
                        y: -snackBar.frame.size.height
                    )
                    
                    snackBar.layer.setAffineTransform(hiddenSnackbarTransform)
                } completion: {
                    completed in
                    
                    continuation.resume(returning: Void())
                }
            })
            
            snackBar.removeFromSuperview()
        }
    }
    
    func showUnknownFailureSnackBar() {
        Task {
            [weak self] in
            guard let strongSelf = self else {
                return
            }
            
            await strongSelf.showSnackBar(
                text: "Something Went Wrong!",
                variant: .failure
            )
        }
    }
}

// MARK: ActivityIndicator
extension UIViewController {
    func showActivityIndicator() {
        view.isUserInteractionEnabled = false
        
        let activityIndicator = ActivityIndicator()
        
        view.addSubview(activityIndicator)
        activityIndicator.align(toCenterOf: view)
    }

    func hideActivityIndicator() {
        view.isUserInteractionEnabled = true
        
        let mayBeActivityIndicator = view.subviews.first {
            view in
            
            if view is ActivityIndicator {
                return true
            }
            
            return false
        }
        
        if let activityIndicator = mayBeActivityIndicator {
            activityIndicator.removeFromSuperview()
        }
    }
}
