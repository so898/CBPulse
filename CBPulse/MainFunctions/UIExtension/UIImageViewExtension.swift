//
//  UIImageViewExtension.swift
//  CBPulse
//
//  Created by Bill Cheng on 16/6/4.
//  Copyright © 2016年 R3 Studio. All rights reserved.
//

import UIKit

class ImageCache : NSCache<AnyObject, AnyObject>{
    static let sharedInstance = ImageCache()//Singleton
}

extension UIImageView{
    func setNetImage(_ url : URL){
        let session = URLSession.shared;
        //make request
        let request : NSMutableURLRequest = NSMutableURLRequest.init(url: url, cachePolicy: NSURLRequest.CachePolicy.returnCacheDataElseLoad, timeoutInterval: 10)
        request.httpMethod = "GET"
        
        let cache : ImageCache = ImageCache.sharedInstance
        let cacheData = cache.object(forKey: url as AnyObject)
        if nil != cacheData{
            DispatchQueue(label: "My Queue", attributes: []).async(execute: {
                let image = UIImage(data: cacheData as! Data)
                
                DispatchQueue.main.async(execute: {
                    // Update the UI
                        self.image = image
                    })
                })
            
            return
        }
        
        //fire session
        session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) in
            if response is HTTPURLResponse{
                let statusCode : NSInteger = (response as! HTTPURLResponse).statusCode
                if 200 == statusCode{
                    ImageCache.sharedInstance.setObject(data! as AnyObject, forKey: url as AnyObject)
                    DispatchQueue.main.async(execute: { () -> Void in
                        self.image = UIImage(data: data!)
                    })
                } else {
                    
                }
            }
            }) .resume()
    }
}
