//
//  MainViewController.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 30/04/22.
//

import UIKit

class GodViewController: TXViewController {
    // Declare
    
    // Configure
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureEventListener()
    }
    
    private func configureEventListener() {
        TXEventBroker.shared.listen {
            [weak self] event in
            guard let strongSelf = self else {
                return
            }
            
            if event is HomeEvent {
                strongSelf.switchToHomeViewController()
            }
            
            if event is AuthenticationEvent {
                strongSelf.switchToAuthenticationViewController()
            }
            
            if let event = event as? ShowSnackBarEvent {
                Task {
                    await strongSelf.showSnackBar(
                        text: event.text,
                        variant: event.variant,
                        duration: event.duration,
                        dismissible: event.dismissible
                    )
                }
            }
            
            if event is HideSnackBarEvent {
                Task {
                    await strongSelf.hideSnackBar()
                }
            }
        }
    }
    
    private func switchToHomeViewController() {
        dismiss(animated: false)
        
        let homeViewController = HomeViewController()
        homeViewController.modalPresentationStyle = .fullScreen
        homeViewController.modalTransitionStyle = .crossDissolve
        
        present(
            homeViewController,
            animated: true
        )
    }
    
    private func switchToAuthenticationViewController() {
        dismiss(animated: false)
        
        let authenticationViewController = AuthenticationViewController()
        authenticationViewController.modalPresentationStyle = .fullScreen
        authenticationViewController.modalTransitionStyle = .crossDissolve
        
        present(
            authenticationViewController,
            animated: true
        )
    }
    
    private func showSnackBar(
        text: String,
        variant: SnackBar.Variant,
        duration: TimeInterval,
        dismissible: Bool
    ) async {
        guard let presentedViewController = presentedViewController else {
            return
        }
        
        await hideSnackBar()
        
        let snackBar = SnackBar(
            text: text,
            variant: variant,
            duration: duration,
            dismissible: dismissible
        )
        
        presentedViewController.view.addSubview(snackBar)
        
        snackBar.pin(
            toLeftOf: presentedViewController.view,
            withInset: 16,
            byBeingSafeAreaAware: true
        )
        snackBar.pin(
            toRightOf: presentedViewController.view,
            withInset: 16,
            byBeingSafeAreaAware: true
        )
        snackBar.pin(
            toTopOf: presentedViewController.view,
            byBeingSafeAreaAware: false
        )
        
        let hiddenSnackbarTransform = CGAffineTransform(
            translationX: 0,
            y: snackBar.frame.size.height - presentedViewController.view.safeAreaInsets.top
        )
        
        snackBar.layer.setAffineTransform(hiddenSnackbarTransform)
        
        UIView.animate(
            withDuration: 0.1,
            delay: 0,
            options: .curveLinear
        ) {
            let visibleSnackbarTransform = CGAffineTransform(
                translationX: 0,
                y: presentedViewController.view.safeAreaInsets.top + 16
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
    
    private func hideSnackBar(
        _ snackBar: SnackBar? = nil
    ) async {
        guard let presentedViewController = presentedViewController else {
            return
        }
        
        let mayBeSnackBar = snackBar ?? presentedViewController.view.subviews.first {
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
    
    // Populate
    
    // Interact
}
