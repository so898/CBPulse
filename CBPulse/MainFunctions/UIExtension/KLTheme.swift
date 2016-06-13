//
//  UITheme.swift
//  CBPulse
//
//  Created by Bill Cheng on 16/6/6.
//  Copyright © 2016年 R3 Studio. All rights reserved.
//

import Foundation
import UIKit

public let KLThemeUpdateNotification = "KLThemeUpdateNotification"

private var KLThemeKey = ""
private var KLNightMode = "CBNightMode"

public enum KLThemeType{
    case DefaultTheme
    case DarkTheme
}

class KLTheme {
    var themeType : KLThemeType
    
    //Colors
    var titleTextColor : UIColor! {
        get {
            return KLTheme.sharedInstance.themeType == .DefaultTheme ? UIColor.blackColor() : UIColor.whiteColor()
        }
    }
    
    var detailTextColor : UIColor! {
        get {
            return KLTheme.sharedInstance.themeType == .DefaultTheme ? UIColor(white:78/255, alpha:1) : UIColor(white:198/255, alpha:1)
        }
    }
    
    var textBackgroundColor : UIColor! {
        get {
            return KLTheme.sharedInstance.themeType == .DefaultTheme ? UIColor(white:255/255, alpha:1) : UIColor(white:51/255, alpha:1)
        }
    }
    
    var detailTextBackgroundColor : UIColor! {
        get {
            return KLTheme.sharedInstance.themeType == .DefaultTheme ? UIColor(white:245/255, alpha:1) : UIColor(white:38/255, alpha:1)
        }
    }
    
    var cellBackgroundColor : UIColor! {
        get {
            return KLTheme.sharedInstance.themeType == .DefaultTheme ? UIColor(white: 230/255, alpha: 1) : UIColor(white: 26/255, alpha: 1)
        }
    }
    
    var lineColor : UIColor! {
        get {
            return KLTheme.sharedInstance.themeType == .DefaultTheme ? UIColor(white: 204/255, alpha: 1) : UIColor(white: 78/255, alpha: 1)
        }
    }
    
    var tableBackgroundColor : UIColor! {
        get {
            return KLTheme.sharedInstance.themeType == .DefaultTheme ? UIColor(white: 245/255, alpha: 1) : UIColor(white: 77/255, alpha: 1)
        }
    }
    
    static let sharedInstance = KLTheme()//Singleton
    
    init(){
        if NSUserDefaults.standardUserDefaults().boolForKey(KLNightMode){
            themeType = .DarkTheme
        } else {
            themeType = .DefaultTheme
        }
        
    }
    
    func changeType(){
        if .DefaultTheme == self.themeType {
            self.themeType = .DarkTheme
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: KLNightMode)
        } else if .DarkTheme == self.themeType {
            self.themeType = .DefaultTheme
            NSUserDefaults.standardUserDefaults().setBool(false, forKey: KLNightMode)
        }
        NSNotificationCenter.defaultCenter().postNotificationName(KLThemeUpdateNotification, object: nil)
    }
}

//extension UILabel{
//    @objc override func updateThemeForKL() {
//        if KLThemeType.DefaultTheme == KLTheme.sharedInstance.themeType {
//            self.textColor = UIColor.blackColor()
//        } else if KLThemeType.DarkTheme == KLTheme.sharedInstance.themeType {
//            self.textColor = UIColor.whiteColor()
//        }
//        self.backgroundColor = UIColor.clearColor()
//    }
//}

extension UIScrollView{
    public override func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        if 2 == gestureRecognizer.numberOfTouches() && !gestureRecognizer.isKindOfClass(UISwipeGestureRecognizer){
            return false
        }
        return true
    }
}

extension UITableView{
    @objc override func updateThemeForKL() {
        backgroundColor = KLTheme.sharedInstance.tableBackgroundColor
    }
}

extension UITextView{
    @objc override func updateThemeForKL() {
        textColor = KLTheme.sharedInstance.detailTextColor
        backgroundColor = KLTheme.sharedInstance.detailTextBackgroundColor
    }
}

extension UIViewController{
    
    override func addNotification() {
        super.addNotification()
        setupGestureRecognizer()
    }
    
    func setupGestureRecognizer() {
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(changeSystemColor(_:)))
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(changeSystemColor(_:)))        
        
        swipeUp.direction = UISwipeGestureRecognizerDirection.Up
        swipeDown.direction = UISwipeGestureRecognizerDirection.Down
        
        swipeUp.numberOfTouchesRequired = 2
        swipeDown.numberOfTouchesRequired = 2
        
        view.addGestureRecognizer(swipeUp)
        view.addGestureRecognizer(swipeDown)
    }
    
    @objc func changeSystemColor(gesture : UISwipeGestureRecognizer) {
        let coverView : UIView = UIView()
        let tmpCover : UIImageView = UIImageView()
        var cover : UIImage
        
        if nil != self.view.window && self.isViewLoaded() {
            coverView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight)
            coverView.clipsToBounds = true
            self.view.window?.addSubview(coverView)
            
            cover = Utils.imageWithView(self.view.window!)
            tmpCover.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight)
            tmpCover.image = cover
            coverView.addSubview(tmpCover)
        }
        
        if KLTheme.sharedInstance.themeType == .DefaultTheme && gesture.direction == UISwipeGestureRecognizerDirection.Down{
            KLTheme.sharedInstance.changeType()
        } else if KLTheme.sharedInstance.themeType == .DarkTheme && gesture.direction == .Up{
            KLTheme.sharedInstance.changeType()
        }
        
        if nil != self.view.window && self.isViewLoaded() {
            UIView.animateWithDuration(0.15, animations: {
                if KLThemeType.DarkTheme == KLTheme.sharedInstance.themeType {
                    coverView.frame = CGRectMake(0, ScreenHeight, ScreenWidth, ScreenHeight)
                    tmpCover.frame = CGRectMake(0, -ScreenHeight, ScreenWidth, ScreenHeight)
                } else {
                    coverView.frame = CGRectMake(0, -ScreenHeight, ScreenWidth, ScreenHeight)
                    tmpCover.frame = CGRectMake(0, ScreenHeight, ScreenWidth, ScreenHeight)
                }
            }) { (complete) in
                coverView.removeFromSuperview()
            }
        }
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

extension UINavigationController{
    override func addNotification() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: KLThemeUpdateNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(updateThemeForKL), name: KLThemeUpdateNotification, object: nil)
    }
    
    @objc override func updateThemeForKL() {
        if KLThemeType.DefaultTheme == KLTheme.sharedInstance.themeType {
            navigationBar.barStyle = UIBarStyle.Default
        } else if KLThemeType.DarkTheme == KLTheme.sharedInstance.themeType {
            navigationBar.barStyle = UIBarStyle.Black
        }
    }
}

extension NSObject{
    
    func addNotification (){
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(updateThemeForKL), name: KLThemeUpdateNotification, object: nil)
    }
    
    var theme : String {
        get {
            NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(updateThemeForKL), name: KLThemeUpdateNotification, object: nil)
            return "ABC"
        }
    }
    var themeInit : String {
        get {
            return objc_getAssociatedObject(self, &KLThemeKey) as! String
        }
        set {
            objc_setAssociatedObject(self, &KLThemeKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            NSNotificationCenter.defaultCenter().removeObserver(self, name: KLThemeUpdateNotification, object: nil)
            if false == newValue.isEmpty {
                NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(updateThemeForKL), name: KLThemeUpdateNotification, object: nil)
            }
        }
    }
    
    @objc func updateThemeForKL() {
//        themePickers.forEach { selector, picker in
//            UIView.animateWithDuration(ThemeManager.animationDuration) {
//                self.performThemePicker(selector, picker: picker)
//            }
//        }
//        performSelector(Selector("setTextColor:"), withObject: UIColor.redColor())
        
    }
}
