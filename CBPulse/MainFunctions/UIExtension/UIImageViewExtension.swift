//
//  UIImageViewExtension.swift
//  CBPulse
//
//  Created by Bill Cheng on 16/6/4.
//  Copyright © 2016年 R3 Studio. All rights reserved.
//

import UIKit

class ImageCache : NSCache{
    static let sharedInstance = ImageCache()//Singleton
}

extension UIImageView{
    func setNetImage(url : NSURL){
        let session = NSURLSession.sharedSession();
        //make request
        let request : NSMutableURLRequest = NSMutableURLRequest.init(URL: url, cachePolicy: NSURLRequestCachePolicy.ReturnCacheDataElseLoad, timeoutInterval: 10)
        request.HTTPMethod = "GET"
        
        let cache : ImageCache = ImageCache.sharedInstance
        let cacheData = cache.objectForKey(url)
        if nil != cacheData{
            dispatch_async(dispatch_queue_create("My Queue", nil), {
                let image = UIImage(data: cacheData as! NSData)
                
                dispatch_async(dispatch_get_main_queue(), {
                    // Update the UI
                        self.image = image
                    })
                })
            
            return
        }
        
        //fire session
        session.dataTaskWithRequest(request as NSURLRequest) { (data, response, error) in
            if response is NSHTTPURLResponse{
                let statusCode : NSInteger = (response as! NSHTTPURLResponse).statusCode
                if 200 == statusCode{
                    ImageCache.sharedInstance.setObject(data!, forKey: url)
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.image = UIImage(data: data!)
                    })
                } else {
                    
                }
            }
            }.resume()
    }
}
