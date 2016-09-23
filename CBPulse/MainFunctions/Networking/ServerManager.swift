//
//  ServerManager.swift
//  CBPulse
//
//  Created by Bill Cheng on 16/6/4.
//  Copyright © 2016年 R3 Studio. All rights reserved.
//

import Foundation

class ServerManager{
    fileprivate var BaseURL = "http://api.cnbeta.com/capi"
    
    static let sharedInstance = ServerManager()//Singleton
    
    fileprivate var session : URLSession
    
    init(){
        session = URLSession.shared;
    }
    
    func getNewsList(_ sid: Int?, success: ((_ array : NSArray) -> Void)?, fail: ((_ code : NSInteger, _ error : NSError?) -> Void)?) {
        var dic : NSDictionary
        if nil == sid {
            dic = NSDictionary.init(objects: ["Article.Lists"], forKeys: ["method" as NSCopying])
        } else {
            dic = NSDictionary.init(objects: ["Article.Lists", String(sid!)], forKeys: ["method" as NSCopying, "end_sid" as NSCopying])
        }
        
        self.GET(BaseURL, paramaters: self.generateSign(dic), success: { (data) in
            let dic : AnyObject = Utils.decodeJSONToData(data!)
            let status = dic.object(forKey: "status")
            if ((status! as AnyObject).isEqual(to: "success")){
                let array = dic.object(forKey: "result")
                let results : NSMutableArray = NSMutableArray()
                
                for item in (array as! NSArray){
                    results.add(CBNews.initWithDictionary((item as! NSDictionary)))
                }
                
                if nil != success{
                    DispatchQueue.main.async(execute: { () -> Void in
                        success!(results)
                    })
                }
            } else {
                if nil != fail{
                    fail!(-1, nil)
                }
            }
        }, fail: fail)
    }
    
    func getNewsDetail(_ sid: Int, success: ((_ detail : CBNewsDetail) -> Void)?, fail: ((_ code : NSInteger, _ error : NSError?) -> Void)?) {
        let paramaters : NSDictionary = NSDictionary.init(objects: [String(sid), "Article.NewsContent"], forKeys: ["sid" as NSCopying,"method" as NSCopying])
        self.GET(BaseURL, paramaters: self.generateSign(paramaters), success: { (data) in
            let dic : AnyObject = Utils.decodeJSONToData(data!)
            let status = dic.object(forKey: "status")
            if ((status! as AnyObject).isEqual(to: "success")){
                let result = dic.object(forKey: "result")
                
                let detail : CBNewsDetail = CBNewsDetail.initWithDictionary(result as! NSDictionary)
                
                if nil != success{
                    DispatchQueue.main.async(execute: { () -> Void in
                        success!(detail)
                    })
                }
            } else {
                if nil != fail{
                    fail!(-1, nil)
                }
            }
        }, fail: { (code, error) in
                
        })
    }
    
    fileprivate func GET(_ urlString: String, paramaters: NSDictionary?, success: ((_ data : Data?) -> Void)?, fail: ((_ code : NSInteger, _ error : NSError?) -> Void)?){
        guard urlString.characters.count > 0 else {
            if nil != fail{
                fail!(-999, nil)
            }
            return
        }
        
        let dataString = NSMutableString()
        
        //handle paramaters
        if nil != paramaters {
            for key in paramaters!.allKeys {
                dataString.append("&" + (key as! String) + "=" + (paramaters!.object(forKey: key) as! String))
            }
        }
        
        //parser string
        let url = URL(string: dataString.length == 0 ? urlString : urlString + "?" + dataString.substring(from: 1))
        
        //make request
        let request : NSMutableURLRequest = NSMutableURLRequest.init(url: url!, cachePolicy: NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData, timeoutInterval: 10)
        request.httpMethod = "GET"
        
        //fire session
        session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) in
            if response is HTTPURLResponse{
                let statusCode : NSInteger = (response as! HTTPURLResponse).statusCode
                if 200 == statusCode{
                    if nil != success{
                        success!(data)
                    }
                } else {
                    if nil != fail{
                        fail!(statusCode, error as NSError?)
                    }
                }
            }
            }) .resume()
    }
    
    fileprivate func POST(_ urlString: String, paramaters: NSDictionary?, success: ((_ data : Data?) -> Void)?, fail: ((_ code : NSInteger, _ error : NSError?) -> Void)?){
        guard urlString.characters.count > 0 else {
            if nil != fail{
                fail!(-999, nil)
            }
            return
        }
        let dataString = NSMutableString()
        
        //handle paramaters
        if nil != paramaters {
            for key in paramaters!.allKeys {
                dataString.append("&" + (key as! String) + "=" + (paramaters!.object(forKey: key) as! String))
            }
        }
        
        //parser string
        let url = URL(string: urlString)
        
        //make request
        let request : NSMutableURLRequest = NSMutableURLRequest.init(url: url!, cachePolicy: NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData, timeoutInterval: 10)
        request.httpMethod = "POST"
        request.httpBody = dataString.substring(from: 1).data(using: String.Encoding.utf8)
        
        //fire session
        session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) in
            if response is HTTPURLResponse{
                let statusCode : NSInteger = (response as! HTTPURLResponse).statusCode
                if 200 == statusCode{
                    if nil != success{
                        success!(data)
                    }
                } else {
                    if nil != fail{
                        fail!(statusCode, error as NSError?)
                    }
                }
            }
            }) .resume()
    }
    
    @available(iOS, introduced: 2.0, deprecated: 7.0, message: "Just a Test")
    fileprivate func requestUrl(_ url : URL){
        
        let request : NSMutableURLRequest = NSMutableURLRequest.init(url: url, cachePolicy: NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData, timeoutInterval: 10)
        
        let dic : NSMutableDictionary = NSMutableDictionary()
        dic.setObject("13720108952", forKey: "username" as NSCopying)
        dic.setObject("287d8806e0baa07f4a29601d46be49e3", forKey: "password" as NSCopying)
        
        let dataString = NSMutableString()
        
        for key in dic.allKeys {
            dataString.append("&" + (key as! String) + "=" + (dic.object(forKey: key) as! String))
        }
        
        print(dataString.substring(from: 1))
        
        request.httpMethod = "POST"
        request.httpBody = dataString.substring(from: 1).data(using: String.Encoding.utf8)
        
        session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) in
            if response is HTTPURLResponse{
                print((response as! HTTPURLResponse).statusCode)
            }
            if (nil != data) {
                print(data)
                let responseString : String = String.init(data: data!, encoding: String.Encoding.utf8)!
                
                var result : NSMutableDictionary
                do {
                    result = try JSONSerialization.jsonObject(with: data!, options:JSONSerialization.ReadingOptions.mutableLeaves) as! NSMutableDictionary
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
            
        }) .resume()
        
        
    }
    
    fileprivate func generateSign(_ paramaters: NSDictionary?) -> NSDictionary?{
        if nil == paramaters {
            return nil
        }
        
        let timeStamp : String = Utils.timeStamp;
        
        let resultDic = NSMutableDictionary.init(dictionary: paramaters!)
        resultDic.setObject("10000", forKey: "app_key" as NSCopying)
        resultDic.setObject("json", forKey: "format" as NSCopying)
        resultDic.setObject(timeStamp, forKey: "timestamp" as NSCopying)
        resultDic.setObject("1.0", forKey: "v" as NSCopying)
        
        let sortedKeys = (resultDic.allKeys as! [String]).sorted()
        
        var paramatersString : String = ""
        
        for key in sortedKeys {
            paramatersString = paramatersString + key + "=" + (resultDic.object(forKey: key) as! String) + "&"
        }
        paramatersString += "mpuffgvbvbttn3Rc"
        
        let sign : String = Utils.MD5(paramatersString)
        
        resultDic.setObject(sign, forKey: "sign" as NSCopying)
        return resultDic
    }
}
