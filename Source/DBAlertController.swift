//
//  DBAlertController.swift
//  DBAlertController
//
//  Created by Dylan Bettermann on 5/11/15.
//  Copyright (c) 2015 Dylan Bettermann. All rights reserved.
//

import UIKit

public class DBAlertController: UIAlertController {
    public static var windowLevel: UIWindowLevel = UIWindowLevelNormal // default
   
    /// The UIWindow that will be at the top of the window hierarchy. The DBAlertController instance is presented on the rootViewController of this window.
    private lazy var alertWindow: UIWindow = {
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.windowLevel = DBAlertController.windowLevel
        window.rootViewController = DBClearViewController()
        window.backgroundColor = UIColor.clear
        return window
    }()
    
    /**
    Present the DBAlertController on top of the visible UIViewController.
    
    - parameter flag:       Pass true to animate the presentation; otherwise, pass false. The presentation is animated by default.
    - parameter completion: The closure to execute after the presentation finishes.
    */
    public func show(animated flag: Bool = true, completion: (() -> Void)? = nil) {
        let duplicatedAlerts = UIApplication.shared.windows.filter { [weak self] in
            $0.rootViewController?.presentedViewController?.restorationIdentifier == self?.restorationIdentifier
        }
        if duplicatedAlerts.count > 0 { return }
        if let rootViewController = alertWindow.rootViewController {
            alertWindow.makeKeyAndVisible()
            
            rootViewController.present(self, animated: flag, completion: completion)
        }
    }
    
    /**
    Dismiss the DBAlertController
    
    - parameter flag:       Pass true to animate the presentation; otherwise, pass false. The presentation is animated by default.
    - parameter completion: The closure to execute after the dismiss finishes.
    */
    public override func dismiss(animated flag: Bool = true, completion: (() -> Void)? = nil) {
        dismiss(animated: flag, completion: completion)
    }
    
    
    // Fix for bug in iOS 9 Beta 5 that prevents the original window from becoming keyWindow again
    deinit {
        alertWindow.isHidden = true
    }
    
}

// In the case of view controller-based status bar style, make sure we use the same style for our view controller
private class DBClearViewController: UIViewController {
    
    fileprivate override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIApplication.shared.statusBarStyle
    }
    
    fileprivate override var prefersStatusBarHidden: Bool {
        return UIApplication.shared.isStatusBarHidden
    }
    
}
