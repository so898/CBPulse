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
        if KLThemeType.defaultTheme == KLTheme.sharedInstance.themeType {
            navigationBar.barStyle = UIBarStyle.default
        } else if KLThemeType.darkTheme == KLTheme.sharedInstance.themeType {
            navigationBar.barStyle = UIBarStyle.black
        }
    }
    
//    override func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
//        return true
//    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer.numberOfTouches == 2 {
            return false
        }
        return true
    }
}
