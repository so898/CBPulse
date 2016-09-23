//
//  CBNews.swift
//  CBPulse
//
//  Created by Bill Cheng on 16/6/4.
//  Copyright © 2016年 R3 Studio. All rights reserved.
//

import Foundation

class CBNews{
    var sid : Int = 0//新闻ID
    var title : String = ""//新闻标题
    var summary : String = ""//简介
    var thumb : String = ""//封面地址
    var counter : Int = 0//查看数量
    var comments : Int = 0//评论数量
    var pubtime : String = ""//发布时间
    var topic : Int = 0//话题ID
    var topic_logo : String = ""//话题封面
    var ratings : Int = 0//评分
    var ratins_story : Int = 0//
    var score : Int = 0//
    var score_story : Int = 0//
    
    class func initWithDictionary(_ dic: NSDictionary) -> CBNews{
        let news : CBNews = CBNews()
        news.sid = (dic.object(forKey: "sid") as! NSString).integerValue
        news.title = (dic.object(forKey: "title") as! String)
        news.summary = (dic.object(forKey: "summary") as! String)
        news.thumb = (dic.object(forKey: "thumb") as! String)
        news.counter = (dic.object(forKey: "counter") as! NSString).integerValue
        news.comments = (dic.object(forKey: "comments") as! NSString).integerValue
        news.pubtime = (dic.object(forKey: "pubtime") as! String)
        news.topic = (dic.object(forKey: "topic") as! NSString).integerValue
        news.topic_logo = (dic.object(forKey: "topic_logo") as! String)
        news.ratings = (dic.object(forKey: "ratings") as! NSString).integerValue
        news.ratins_story = (dic.object(forKey: "ratings_story") as! NSString).integerValue
        news.score = (dic.object(forKey: "score") as! NSString).integerValue
        news.score_story = (dic.object(forKey: "score_story") as! NSString).integerValue
        return news
    }
}
