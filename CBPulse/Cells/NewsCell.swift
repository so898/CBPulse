//
//  NewsCell.swift
//  CBPulse
//
//  Created by Bill Cheng on 16/6/4.
//  Copyright © 2016年 R3 Studio. All rights reserved.
//

import UIKit

@objc
protocol NewsCellOptionalDelegate {
    optional func selectTitle(title : String)
}

protocol NewsCellDelegate {
    func openNewsDetail(news : CBNews)
}

class NewsCell: UITableViewCell{
    var mainView : UIView = UIView()
    var line : UIView = UIView()
    var titleLabel : UILabel = UILabel()
    var detailLabel : UILabel = UILabel()
    var backgImage : UIView = UIView()
    var detailImage : UIImageView = UIImageView()
    var topicImage : UIImageView = UIImageView()
    var store : CBNews!
    var optionalDelegate : NewsCellOptionalDelegate?
    var delegate : NewsCellDelegate?
    var detailStatus : Bool = false
    
    var moreIcon : UIImageView = UIImageView()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.addNotification()
        
        clipsToBounds = true
        selectionStyle = UITableViewCellSelectionStyle.None
        backgroundColor = KLTheme.sharedInstance.cellBackgroundColor
        contentView.backgroundColor = UIColor.clearColor()
        
        moreIcon.contentMode = UIViewContentMode.ScaleAspectFit
        moreIcon.image = UIImage(named: "ic_more")?.imageWithRenderingMode(.AlwaysTemplate)
        moreIcon.tintColor = UIColor(white: 153/255, alpha: 1)
        contentView.addSubview(moreIcon)
        
        mainView.backgroundColor = UIColor(white: 245, alpha: 1)
        mainView.clipsToBounds = true
        contentView.addSubview(mainView)
        
        line.backgroundColor = UIColor(white: 204/255, alpha: 1)
        contentView.addSubview(line)
        
        backgImage.backgroundColor = UIColor(white: 1, alpha: 0.5)
        backgImage.layer.cornerRadius = 5.0
        mainView.addSubview(backgImage)
        
        detailImage.contentMode = UIViewContentMode.ScaleAspectFit
        detailImage.clipsToBounds = true
        detailImage.layer.cornerRadius = 5.0
        mainView.addSubview(detailImage)
        
        topicImage.contentMode = UIViewContentMode.ScaleAspectFit
        topicImage.clipsToBounds = true
        topicImage.layer.cornerRadius = 5.0
        mainView.addSubview(topicImage)
        
        titleLabel.font = UIFont.boldSystemFontOfSize(16)
        titleLabel.numberOfLines = 0
        titleLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
        titleLabel.userInteractionEnabled = true//和OBJC不同
        mainView.addSubview(titleLabel)
        
        detailLabel.font = UIFont.systemFontOfSize(14)
        detailLabel.numberOfLines = 0;
        detailLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
        
        let pan : UIPanGestureRecognizer = UIPanGestureRecognizer.init(target: self, action: #selector(self.panMainView(_:)))
        pan.delegate = self
        addGestureRecognizer(pan)
    }
    
    @objc func titleTaped(tap : UITapGestureRecognizer){
        optionalDelegate?.selectTitle?(titleLabel.text!)
    }
    
    @objc private func panMainView(pan : UIPanGestureRecognizer){
        let point : CGPoint = pan.translationInView(self.contentView)
        if point.x > 0 {
            return
        }
        mainView.center = CGPointMake(point.x + ScreenWidth/2, mainView.center.y)
        if -70 <= point.x {
            moreIcon.frame = CGRectMake(ScreenWidth + point.x, moreIcon.frame.origin.y, 70, 24)
        } else {
            moreIcon.frame = CGRectMake(ScreenWidth - 70, moreIcon.frame.origin.y, 70, 24)
        }
        if UIGestureRecognizerState.Ended == pan.state {
            if -70 > point.x {
                delegate?.openNewsDetail(store)
            }
            UIView.animateWithDuration(0.2, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                self.mainView.center = CGPointMake(ScreenWidth/2, self.mainView.center.y)
                self.moreIcon.frame = CGRectMake(ScreenWidth + ScreenWidth / 5, self.moreIcon.frame.origin.y, 70, 24)
            }, completion: nil)
        }
    }
    
    func setCBNews(news : CBNews, showDetail : Bool){
        detailStatus = showDetail
        updateThemeForKL()
        store = news
        
        if 0 != news.topic_logo.characters.count{
            topicImage.setNetImage(NSURL.init(string: news.topic_logo)!)
        }
        
        if 0 != news.thumb.characters.count{
            detailImage.setNetImage(NSURL.init(string: news.thumb)!)
        }
        
        var height : CGFloat = 10.0
        
        titleLabel.text = news.title
        let titleHeight : CGFloat = max(40, titleLabel.sizeThatFits(CGSizeMake(ScreenWidth - 35 - 40, CGFloat.max)).height)
        titleLabel.frame = CGRectMake(15, height, ScreenWidth - 35 - 40, titleHeight)
        titleLabel.textColor = KLTheme.sharedInstance.titleTextColor
        
        detailLabel.text = news.summary
        let detailHeight : CGFloat = detailLabel.sizeThatFits(CGSizeMake(ScreenWidth - 30, CGFloat.max)).height
        detailLabel.frame = CGRectMake(15, height + titleHeight + 10, ScreenWidth - 30, detailHeight)
        detailLabel.textColor = KLTheme.sharedInstance.detailTextColor
        
        detailImage.frame = CGRectMake(ScreenWidth - 15 - 40, (max(height, 60) - 40) / 2, 40, 40)
        topicImage.frame = CGRectMake(ScreenWidth - 15 - 40, (max(height, 60) - 40) / 2, 40, 40)
        backgImage.frame = CGRectMake(ScreenWidth - 15 - 40, (max(height, 60) - 40) / 2, 40, 40)
        
        height += titleHeight + 10
        
        if showDetail {
            mainView.addSubview(detailLabel)
            detailLabel.alpha = 1
            detailImage.alpha = 1
            topicImage.alpha = 0
            
            height += detailHeight + 10
            self.mainView.backgroundColor = KLTheme.sharedInstance.themeType == .DefaultTheme ? UIColor(white:245/255, alpha:1) : UIColor(white:38/255, alpha:1)
        } else {
            detailLabel.alpha = 0
            detailLabel.removeFromSuperview()
            detailImage.alpha = 0
            topicImage.alpha = 1
            self.mainView.backgroundColor = KLTheme.sharedInstance.themeType == .DefaultTheme ? UIColor(white:255/255, alpha:1) : UIColor(white:51/255, alpha:1)
        }
        
        mainView.frame = CGRectMake(0, 0, ScreenWidth, height)
        line.frame = CGRectMake(0, height - 0.5, ScreenWidth, 0.5)
        
        moreIcon.frame = CGRectMake(ScreenWidth, (height - 24) / 2, 70, 24)
    }
    
    func setDetailViewable(showDetail : Bool) {
        detailStatus = showDetail
        if showDetail {
            mainView.addSubview(detailLabel)
            self.detailLabel.alpha = 0
            UIView.animateWithDuration(0.3, animations: {
                self.mainView.frame = CGRectMake(0, 0, ScreenWidth, 10 + self.titleLabel.frame.size.height + 10 + self.detailLabel.frame.size.height + 10)
                self.line.frame = CGRectMake(0, self.mainView.frame.size.height - 0.5, ScreenWidth, 0.5)
                self.detailLabel.alpha = 1
                
                self.detailImage.alpha = 1
                self.topicImage.alpha = 0
                self.mainView.backgroundColor = KLTheme.sharedInstance.detailTextBackgroundColor
            }, completion:nil)
            moreIcon.frame = CGRectMake(ScreenWidth, (self.mainView.frame.size.height - 24) / 2, 70, 24)
        } else {
            UIView.animateWithDuration(0.3, animations: {
                self.mainView.frame = CGRectMake(0, 0, ScreenWidth, 10 + self.titleLabel.frame.size.height + 10)
                self.line.frame = CGRectMake(0, self.mainView.frame.size.height - 0.5, ScreenWidth, 0.5)
                self.detailLabel.alpha = 0
                
                self.detailImage.alpha = 0
                self.topicImage.alpha = 1
                self.mainView.backgroundColor = KLTheme.sharedInstance.textBackgroundColor
            },completion:{ (complete) in
                self.detailLabel.removeFromSuperview()
            })
            moreIcon.frame = CGRectMake(ScreenWidth, (self.mainView.frame.size.height - 24) / 2, 70, 24)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

extension NewsCell{
    class func calHeight(news: CBNews, showDetail: Bool) -> CGFloat {
        var height : CGFloat = 10.0
        
        let titleLabel : UILabel = UILabel()
        titleLabel.font = UIFont.boldSystemFontOfSize(16)
        titleLabel.numberOfLines = 0
        titleLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
        titleLabel.text = news.title
        let titleHeight : CGFloat = max(40, titleLabel.sizeThatFits(CGSizeMake(ScreenWidth - 35 - 40, CGFloat.max)).height)
        
        height += titleHeight + 10
        
        if showDetail{
            let detailLabel : UILabel = UILabel()
            detailLabel.font = UIFont.systemFontOfSize(14)
            detailLabel.numberOfLines = 0;
            detailLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
            detailLabel.text = news.summary
            let detailHeight : CGFloat = detailLabel.sizeThatFits(CGSizeMake(ScreenWidth - 30, CGFloat.max)).height
            
            height += detailHeight + 10
        }
        
        return max(height, 60)
    }
    
    override func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        if let panGestureRecognizer = gestureRecognizer as? UIPanGestureRecognizer {
            let point = panGestureRecognizer.velocityInView(self)
            if abs(point.x) > abs(point.y) {
                return true
            } else {
                return false
            }
        }
        return !editing
    }
}

extension NewsCell{
    @objc override func updateThemeForKL() {
        if detailStatus {
            mainView.backgroundColor = KLTheme.sharedInstance.detailTextBackgroundColor
        } else {
            mainView.backgroundColor = KLTheme.sharedInstance.textBackgroundColor
        }
        line.backgroundColor = KLTheme.sharedInstance.lineColor
        backgroundColor = KLTheme.sharedInstance.cellBackgroundColor
        titleLabel.textColor = KLTheme.sharedInstance.titleTextColor
        detailLabel.textColor = KLTheme.sharedInstance.detailTextColor
    }
}




