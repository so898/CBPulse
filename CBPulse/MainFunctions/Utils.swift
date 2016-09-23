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

var ScreenWidth : CGFloat = UIScreen.main.bounds.size.width
var ScreenHeight : CGFloat = UIScreen.main.bounds.size.height

class Utils {
    
    static let timeStamp : String = String.init(NSString.init(format: "%.0f", (Date().timeIntervalSince1970*1000)))
    
    class func decodeJSONToData(_ data: Data) -> AnyObject {
        var result : AnyObject
        do {
            result = try JSONSerialization.jsonObject(with: data, options:JSONSerialization.ReadingOptions.mutableLeaves) as! NSDictionary
        } catch _ {
            result = NSDictionary()
        }
        
        return result
    }
    
    class func MD5(_ string: String) -> String {
        var digest = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
        if let data = string.data(using: String.Encoding.utf8) {
            CC_MD5((data as NSData).bytes, CC_LONG(data.count), &digest)
        }
        
        var digestHex = ""
        for index in 0..<Int(CC_MD5_DIGEST_LENGTH) {
            digestHex += String(format: "%02x", digest[index])
        }
        
        return digestHex
    }
    
    class func imageWithView(_ view : UIView) -> UIImage{
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.isOpaque, 0.0);
        view.layer.render(in: UIGraphicsGetCurrentContext()!);
        
        let img : UIImage = UIGraphicsGetImageFromCurrentImageContext()!;
        
        UIGraphicsEndImageContext();
        
        return img;
    }
    
    func Width() -> CGFloat {
        return UIScreen.main.bounds.size.width
    }
}
