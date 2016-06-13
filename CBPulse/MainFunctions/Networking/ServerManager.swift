//
//  ServerManager.swift
//  CBPulse
//
//  Created by Bill Cheng on 16/6/4.
//  Copyright © 2016年 R3 Studio. All rights reserved.
//

import Foundation

class ServerManager{
    private var BaseURL = "http://api.cnbeta.com/capi"
    
    static let sharedInstance = ServerManager()//Singleton
    
    private var session : NSURLSession
    
    init(){
        session = NSURLSession.sharedSession();
    }
    
    func getNewsList(sid: Int?, success: ((array : NSArray) -> Void)?, fail: ((code : NSInteger, error : NSError?) -> Void)?) {
        var dic : NSDictionary
        if nil == sid {
            dic = NSDictionary.init(objects: ["Article.Lists"], forKeys: ["method"])
        } else {
            dic = NSDictionary.init(objects: ["Article.Lists", String(sid!)], forKeys: ["method", "end_sid"])
        }
        
        self.GET(BaseURL, paramaters: self.generateSign(dic), success: { (data) in
            let dic : AnyObject = Utils.decodeJSONToData(data!)
            let status = dic.objectForKey("status")
            if (status!.isEqualToString("success")){
                let array = dic.objectForKey("result")
                let results : NSMutableArray = NSMutableArray()
                
                for item in (array as! NSArray){
                    results.addObject(CBNews.initWithDictionary((item as! NSDictionary)))
                }
                
                if nil != success{
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        success!(array: results)
                    })
                }
            } else {
                if nil != fail{
                    fail!(code: -1, error: nil)
                }
            }
        }, fail: fail)
    }
    
    func getNewsDetail(sid: Int, success: ((detail : CBNewsDetail) -> Void)?, fail: ((code : NSInteger, error : NSError?) -> Void)?) {
        let paramaters : NSDictionary = NSDictionary.init(objects: [String(sid), "Article.NewsContent"], forKeys: ["sid","method"])
        self.GET(BaseURL, paramaters: self.generateSign(paramaters), success: { (data) in
            let dic : AnyObject = Utils.decodeJSONToData(data!)
            let status = dic.objectForKey("status")
            if (status!.isEqualToString("success")){
                let result = dic.objectForKey("result")
                
                let detail : CBNewsDetail = CBNewsDetail.initWithDictionary(result as! NSDictionary)
                
                if nil != success{
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        success!(detail: detail)
                    })
                }
            } else {
                if nil != fail{
                    fail!(code: -1, error: nil)
                }
            }
        }, fail: { (code, error) in
                
        })
    }
    
    private func GET(urlString: String, paramaters: NSDictionary?, success: ((data : NSData?) -> Void)?, fail: ((code : NSInteger, error : NSError?) -> Void)?){
        guard urlString.characters.count > 0 else {
            if nil != fail{
                fail!(code: -999, error: nil)
            }
            return
        }
        
        let dataString = NSMutableString()
        
        //handle paramaters
        if nil != paramaters {
            for key in paramaters!.allKeys {
                dataString.appendString("&" + (key as! String) + "=" + (paramaters!.objectForKey(key) as! String))
            }
        }
        
        //parser string
        let url = NSURL.init(string: dataString.length == 0 ? urlString : urlString + "?" + dataString.substringFromIndex(1))
        
        if url is NSError{
            if nil != fail{
                fail!(code: -1000, error: (url as! NSError))
            }
        }
        
        //make request
        let request : NSMutableURLRequest = NSMutableURLRequest.init(URL: url!, cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData, timeoutInterval: 10)
        request.HTTPMethod = "GET"
        
        //fire session
        session.dataTaskWithRequest(request as NSURLRequest) { (data, response, error) in
            if response is NSHTTPURLResponse{
                let statusCode : NSInteger = (response as! NSHTTPURLResponse).statusCode
                if 200 == statusCode{
                    if nil != success{
                        success!(data: data)
                    }
                } else {
                    if nil != fail{
                        fail!(code: statusCode, error: error)
                    }
                }
            }
            }.resume()
    }
    
    private func POST(urlString: String, paramaters: NSDictionary?, success: ((data : NSData?) -> Void)?, fail: ((code : NSInteger, error : NSError?) -> Void)?){
        guard urlString.characters.count > 0 else {
            if nil != fail{
                fail!(code: -999, error: nil)
            }
            return
        }
        let dataString = NSMutableString()
        
        //handle paramaters
        if nil != paramaters {
            for key in paramaters!.allKeys {
                dataString.appendString("&" + (key as! String) + "=" + (paramaters!.objectForKey(key) as! String))
            }
        }
        
        //parser string
        let url = NSURL.init(string: urlString)
        
        if url is NSError{
            if nil != fail{
                fail!(code: -1000, error: (url as! NSError))
            }
        }
        
        //make request
        let request : NSMutableURLRequest = NSMutableURLRequest.init(URL: url!, cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData, timeoutInterval: 10)
        request.HTTPMethod = "POST"
        request.HTTPBody = dataString.substringFromIndex(1).dataUsingEncoding(NSUTF8StringEncoding)
        
        //fire session
        session.dataTaskWithRequest(request as NSURLRequest) { (data, response, error) in
            if response is NSHTTPURLResponse{
                let statusCode : NSInteger = (response as! NSHTTPURLResponse).statusCode
                if 200 == statusCode{
                    if nil != success{
                        success!(data: data)
                    }
                } else {
                    if nil != fail{
                        fail!(code: statusCode, error: error)
                    }
                }
            }
            }.resume()
    }
    
    @available(iOS, introduced=2.0, deprecated=7.0, message="Just a Test")
    private func requestUrl(url : NSURL){
        
        let request : NSMutableURLRequest = NSMutableURLRequest.init(URL: url, cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData, timeoutInterval: 10)
        
        let dic : NSMutableDictionary = NSMutableDictionary()
        dic.setObject("13720108952", forKey: "username")
        dic.setObject("287d8806e0baa07f4a29601d46be49e3", forKey: "password")
        
        let dataString = NSMutableString()
        
        for key in dic.allKeys {
            dataString.appendString("&" + (key as! String) + "=" + (dic.objectForKey(key) as! String))
        }
        
        print(dataString.substringFromIndex(1))
        
        request.HTTPMethod = "POST"
        request.HTTPBody = dataString.substringFromIndex(1).dataUsingEncoding(NSUTF8StringEncoding)
        
        session.dataTaskWithRequest(request as NSURLRequest) { (data, response, error) in
            if response is NSHTTPURLResponse{
                print((response as! NSHTTPURLResponse).statusCode)
            }
            if (nil != data) {
                print(data)
                let responseString : String = String.init(data: data!, encoding: NSUTF8StringEncoding)!
                
                var result : NSMutableDictionary
                do {
                    result = try NSJSONSerialization.JSONObjectWithData(data!, options:NSJSONReadingOptions.MutableLeaves) as! NSMutableDictionary
                } catch _ {
                    result = NSMutableDictionary()
                }
                
                print(result)
                
                
                print(responseString)
            } else {
                if (nil != error){
                    print(error)
                }
            }
            
        }.resume()
        
        
    }
    
    private func generateSign(paramaters: NSDictionary?) -> NSDictionary?{
        if nil == paramaters {
            return nil
        }
        
        let timeStamp : String = Utils.timeStamp;
        
        let resultDic = NSMutableDictionary.init(dictionary: paramaters!)
        resultDic.setObject("10000", forKey: "app_key")
        resultDic.setObject("json", forKey: "format")
        resultDic.setObject(timeStamp, forKey: "timestamp")
        resultDic.setObject("1.0", forKey: "v")
        
        let sortedKeys = (resultDic.allKeys as! [String]).sort()
        
        var paramatersString : String = ""
        
        for key in sortedKeys {
            paramatersString = paramatersString + key + "=" + (resultDic.objectForKey(key) as! String) + "&"
        }
        paramatersString += "mpuffgvbvbttn3Rc"
        
        let sign : String = Utils.MD5(paramatersString)
        
        resultDic.setObject(sign, forKey: "sign")
        return resultDic
    }
}