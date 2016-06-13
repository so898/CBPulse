//
//  Utils.swift
//  CBPulse
//
//  Created by Bill Cheng on 16/6/4.
//  Copyright © 2016年 R3 Studio. All rights reserved.
//

import Foundation
import UIKit
import Security

var ScreenWidth : CGFloat = UIScreen.mainScreen().bounds.size.width
var ScreenHeight : CGFloat = UIScreen.mainScreen().bounds.size.height

class Utils {
    
    static let timeStamp : String = String.init(NSString.init(format: "%.0f", (NSDate().timeIntervalSince1970*1000)))
    
    class func decodeJSONToData(data: NSData) -> AnyObject {
        var result : AnyObject
        do {
            result = try NSJSONSerialization.JSONObjectWithData(data, options:NSJSONReadingOptions.MutableLeaves) as! NSMutableDictionary
        } catch _ {
            result = NSMutableDictionary()
        }
        
        return result
    }
    
    class func MD5(string: String) -> String {
        var digest = [UInt8](count: Int(CC_MD5_DIGEST_LENGTH), repeatedValue: 0)
        if let data = string.dataUsingEncoding(NSUTF8StringEncoding) {
            CC_MD5(data.bytes, CC_LONG(data.length), &digest)
        }
        
        var digestHex = ""
        for index in 0..<Int(CC_MD5_DIGEST_LENGTH) {
            digestHex += String(format: "%02x", digest[index])
        }
        
        return digestHex
    }
    
    class func imageWithView(view : UIView) -> UIImage{
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, 0.0);
        view.layer.renderInContext(UIGraphicsGetCurrentContext()!);
        
        let img : UIImage = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
        
        return img;
    }
    
    func Width() -> CGFloat {
        return UIScreen.mainScreen().bounds.size.width
    }
}