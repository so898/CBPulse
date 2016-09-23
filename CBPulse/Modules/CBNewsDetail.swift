//
//  CBNewsDetail.swift
//  CBPulse
//
//  Created by Bill Cheng on 16/6/4.
//  Copyright © 2016年 R3 Studio. All rights reserved.
//

import Foundation

class CBNewsDetail{
    var sid : NSInteger = 0//新闻ID
    var catid : NSInteger = 0//
    var title : String = ""//新闻标题
    var aid : String = ""//新闻发布者昵称
    var user_id : Int = 0//新闻发布者ID
    var thumb : String = ""//封面地址
    var counter : Int = 0//查看数量
    var comments : Int = 0//评论数量
    var time : String = ""//发布时间 注意这个和list里面的不一样
    var topic : Int = 0//话题ID
    var ratings : Int = 0//评分
    
    var hometext : String = ""//新闻第一段
    var bodytext : String = ""//内容
    var source : String = ""//新闻来源
    var inputtime : Int = 0//发布时间？
    
    var ratins_story : Int = 0//
    var score : Int = 0//
    var score_story : Int = 0//
    var style : String = ""//
    var keywords : String = ""//
    var listorder : Int = 0//
    var mview : Int = 0//移动阅读次数？
    var data_id : Int = 0
    
    
    
    class func initWithDictionary(_ dic: NSDictionary) -> CBNewsDetail{
        let detail : CBNewsDetail = CBNewsDetail()
        detail.sid = (dic.object(forKey: "sid") as! NSString).integerValue
        detail.title = (dic.object(forKey: "title") as! String)
        detail.thumb = (dic.object(forKey: "thumb") as! String)
        detail.hometext = (dic.object(forKey: "hometext") as! String)
        detail.bodytext = (dic.object(forKey: "bodytext") as! String)
        detail.source = (dic.object(forKey: "source") as! String)
        detail.inputtime = (dic.object(forKey: "inputtime") as! NSString).integerValue
        detail.counter = (dic.object(forKey: "counter") as! NSString).integerValue
        detail.comments = (dic.object(forKey: "comments") as! NSString).integerValue
        detail.time = (dic.object(forKey: "time") as! String)
        detail.topic = (dic.object(forKey: "topic") as! NSString).integerValue
        detail.ratings = (dic.object(forKey: "ratings") as! NSString).integerValue
        detail.ratins_story = (dic.object(forKey: "ratings_story") as! NSString).integerValue
        detail.score = (dic.object(forKey: "score") as! NSString).integerValue
        detail.score_story = (dic.object(forKey: "score_story") as! NSString).integerValue
        return detail
    }
}
