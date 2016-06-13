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
    
    
    
    class func initWithDictionary(dic: NSDictionary) -> CBNewsDetail{
        let detail : CBNewsDetail = CBNewsDetail.init()
        detail.sid = (dic.objectForKey("sid") as! NSString).integerValue
        detail.title = (dic.objectForKey("title") as! String)
        detail.thumb = (dic.objectForKey("thumb") as! String)
        detail.hometext = (dic.objectForKey("hometext") as! String)
        detail.bodytext = (dic.objectForKey("bodytext") as! String)
        detail.source = (dic.objectForKey("source") as! String)
        detail.inputtime = (dic.objectForKey("inputtime") as! NSString).integerValue
        detail.counter = (dic.objectForKey("counter") as! NSString).integerValue
        detail.comments = (dic.objectForKey("comments") as! NSString).integerValue
        detail.time = (dic.objectForKey("time") as! String)
        detail.topic = (dic.objectForKey("topic") as! NSString).integerValue
        detail.ratings = (dic.objectForKey("ratings") as! NSString).integerValue
        detail.ratins_story = (dic.objectForKey("ratings_story") as! NSString).integerValue
        detail.score = (dic.objectForKey("score") as! NSString).integerValue
        detail.score_story = (dic.objectForKey("score_story") as! NSString).integerValue
        return detail
    }
}