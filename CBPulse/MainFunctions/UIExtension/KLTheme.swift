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
    case defaultTheme
    case darkTheme
}

class KLTheme {
    var themeType : KLThemeType
    
    //Colors
    var titleTextColor : UIColor! {
        get {
            return KLTheme.sharedInstance.themeType == .defaultTheme ? UIColor.black : UIColor.white
        }
    }
    
    var detailTextColor : UIColor! {
        get {
            return KLTheme.sharedInstance.themeType == .defaultTheme ? UIColor(white:78/255, alpha:1) : UIColor(white:198/255, alpha:1)
        }
    }
    
    var textBackgroundColor : UIColor! {
        get {
            return KLTheme.sharedInstance.themeType == .defaultTheme ? UIColor(white:255/255, alpha:1) : UIColor(white:51/255, alpha:1)
        }
    }
    
    var detailTextBackgroundColor : UIColor! {
        get {
            return KLTheme.sharedInstance.themeType == .defaultTheme ? UIColor(white:245/255, alpha:1) : UIColor(white:38/255, alpha:1)
        }
    }
    
    var cellBackgroundColor : UIColor! {
        get {
            return KLTheme.sharedInstance.themeType == .defaultTheme ? UIColor(white: 230/255, alpha: 1) : UIColor(white: 26/255, alpha: 1)
        }
    }
    
    var lineColor : UIColor! {
        get {
            return KLTheme.sharedInstance.themeType == .defaultTheme ? UIColor(white: 204/255, alpha: 1) : UIColor(white: 78/255, alpha: 1)
        }
    }
    
    var tableBackgroundColor : UIColor! {
        get {
            return KLTheme.sharedInstance.themeType == .defaultTheme ? UIColor(white: 245/255, alpha: 1) : UIColor(white: 77/255, alpha: 1)
        }
    }
    
    static let sharedInstance = KLTheme()//Singleton
    
    init(){
        if UserDefaults.standard.bool(forKey: KLNightMode){
            themeType = .darkTheme
        } else {
            themeType = .defaultTheme
        }
        
    }
    
    func changeType(){
        if .defaultTheme == self.themeType {
            self.themeType = .darkTheme
            UserDefaults.standard.set(true, forKey: KLNightMode)
        } else if .darkTheme == self.themeType {
            self.themeType = .defaultTheme
            UserDefaults.standard.set(false, forKey: KLNightMode)
        }
        NotificationCenter.default.post(name: Notification.Name(rawValue: KLThemeUpdateNotification), object: nil)
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
    open override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if 2 == gestureRecognizer.numberOfTouches && !gestureRecognizer.isKind(of: UISwipeGestureRecognizer.self){
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
        
        swipeUp.direction = UISwipeGestureRecognizerDirection.up
        swipeDown.direction = UISwipeGestureRecognizerDirection.down
        
        swipeUp.numberOfTouchesRequired = 2
        swipeDown.numberOfTouchesRequired = 2
        
        view.addGestureRecognizer(swipeUp)
        view.addGestureRecognizer(swipeDown)
    }
    
    @objc func changeSystemColor(_ gesture : UISwipeGestureRecognizer) {
        let coverView : UIView = UIView()
        let tmpCover : UIImageView = UIImageView()
        var cover : UIImage
        
        if nil != self.view.window && self.isViewLoaded {
            coverView.frame = CGRect(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight)
            coverView.clipsToBounds = true
            self.view.window?.addSubview(coverView)
            
            cover = Utils.imageWithView(self.view.window!)
            tmpCover.frame = CGRect(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight)
            tmpCover.image = cover
            coverView.addSubview(tmpCover)
        }
        
        if KLTheme.sharedInstance.themeType == .defaultTheme && gesture.direction == UISwipeGestureRecognizerDirection.down{
            KLTheme.sharedInstance.changeType()
        } else if KLTheme.sharedInstance.themeType == .darkTheme && gesture.direction == .up{
            KLTheme.sharedInstance.changeType()
        }
        
        if nil != self.view.window && self.isViewLoaded {
            UIView.animate(withDuration: 0.15, animations: {
                if KLThemeType.darkTheme == KLTheme.sharedInstance.themeType {
                    coverView.frame = CGRect(x: 0, y: ScreenHeight, width: ScreenWidth, height: ScreenHeight)
                    tmpCover.frame = CGRect(x: 0, y: -ScreenHeight, width: ScreenWidth, height: ScreenHeight)
                } else {
                    coverView.frame = CGRect(x: 0, y: -ScreenHeight, width: ScreenWidth, height: ScreenHeight)
                    tmpCover.frame = CGRect(x: 0, y: ScreenHeight, width: ScreenWidth, height: ScreenHeight)
                }
            }, completion: { (complete) in
                coverView.removeFromSuperview()
            }) 
        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

extension UINavigationController{
    override func addNotification() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: KLThemeUpdateNotification), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateThemeForKL), name: NSNotification.Name(rawValue: KLThemeUpdateNotification), object: nil)
    }
    
    @objc override func updateThemeForKL() {
        if KLThemeType.defaultTheme == KLTheme.sharedInstance.themeType {
            navigationBar.barStyle = UIBarStyle.default
        } else if KLThemeType.darkTheme == KLTheme.sharedInstance.themeType {
            navigationBar.barStyle = UIBarStyle.black
        }
    }
}

extension NSObject{
    
    func addNotification (){
        NotificationCenter.default.addObserver(self, selector: #selector(updateThemeForKL), name: NSNotification.Name(rawValue: KLThemeUpdateNotification), object: nil)
    }
    
    var theme : String {
        get {
            NotificationCenter.default.addObserver(self, selector: #selector(updateThemeForKL), name: NSNotification.Name(rawValue: KLThemeUpdateNotification), object: nil)
            return "ABC"
        }
    }
    var themeInit : String {
        get {
            return objc_getAssociatedObject(self, &KLThemeKey) as! String
        }
        set {
            objc_setAssociatedObject(self, &KLThemeKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: KLThemeUpdateNotification), object: nil)
            if false == newValue.isEmpty {
                NotificationCenter.default.addObserver(self, selector: #selector(updateThemeForKL), name: NSNotification.Name(rawValue: KLThemeUpdateNotification), object: nil)
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
