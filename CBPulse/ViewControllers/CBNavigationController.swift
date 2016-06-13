//
//  CBNavigationController.swift
//  CBPulse
//
//  Created by Bill Cheng on 16/6/7.
//  Copyright © 2016年 R3 Studio. All rights reserved.
//

import Foundation
import UIKit

class CBNavigationController : UINavigationController, UIGestureRecognizerDelegate {
    override func viewDidLoad() {
        addNotification()
        if KLThemeType.DefaultTheme == KLTheme.sharedInstance.themeType {
            navigationBar.barStyle = UIBarStyle.Default
        } else if KLThemeType.DarkTheme == KLTheme.sharedInstance.themeType {
            navigationBar.barStyle = UIBarStyle.Black
        }
    }
    
    override func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer.numberOfTouches() == 2 {
            return false
        }
        return true
    }
}
