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
    @objc optional func selectTitle(_ title : String)
}

protocol NewsCellDelegate {
    func openNewsDetail(_ news : CBNews)
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
        selectionStyle = UITableViewCellSelectionStyle.none
        backgroundColor = KLTheme.sharedInstance.cellBackgroundColor
        contentView.backgroundColor = UIColor.clear
        
        moreIcon.contentMode = UIViewContentMode.scaleAspectFit
        moreIcon.image = UIImage(named: "ic_more")?.withRenderingMode(.alwaysTemplate)
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
        
        detailImage.contentMode = UIViewContentMode.scaleAspectFit
        detailImage.clipsToBounds = true
        detailImage.layer.cornerRadius = 5.0
        mainView.addSubview(detailImage)
        
        topicImage.contentMode = UIViewContentMode.scaleAspectFit
        topicImage.clipsToBounds = true
        topicImage.layer.cornerRadius = 5.0
        mainView.addSubview(topicImage)
        
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        titleLabel.numberOfLines = 0
        titleLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        titleLabel.isUserInteractionEnabled = true//和OBJC不同
        mainView.addSubview(titleLabel)
        
        detailLabel.font = UIFont.systemFont(ofSize: 14)
        detailLabel.numberOfLines = 0;
        detailLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        
        let pan : UIPanGestureRecognizer = UIPanGestureRecognizer.init(target: self, action: #selector(self.panMainView(_:)))
        pan.delegate = self
        addGestureRecognizer(pan)
    }
    
    @objc func titleTaped(_ tap : UITapGestureRecognizer){
        optionalDelegate?.selectTitle?(titleLabel.text!)
    }
    
    @objc fileprivate func panMainView(_ pan : UIPanGestureRecognizer){
        let point : CGPoint = pan.translation(in: self.contentView)
        if point.x > 0 {
            return
        }
        mainView.center = CGPoint(x: point.x + ScreenWidth/2, y: mainView.center.y)
        if -70 <= point.x {
            moreIcon.frame = CGRect(x: ScreenWidth + point.x, y: moreIcon.frame.origin.y, width: 70, height: 24)
        } else {
            moreIcon.frame = CGRect(x: ScreenWidth - 70, y: moreIcon.frame.origin.y, width: 70, height: 24)
        }
        if UIGestureRecognizerState.ended == pan.state {
            if -70 > point.x {
                delegate?.openNewsDetail(store)
            }
            UIView.animate(withDuration: 0.2, delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                self.mainView.center = CGPoint(x: ScreenWidth/2, y: self.mainView.center.y)
                self.moreIcon.frame = CGRect(x: ScreenWidth + ScreenWidth / 5, y: self.moreIcon.frame.origin.y, width: 70, height: 24)
            }, completion: nil)
        }
    }
    
    func setCBNews(_ news : CBNews, showDetail : Bool){
        detailStatus = showDetail
        updateThemeForKL()
        store = news
        
        if 0 != news.topic_logo.characters.count{
            topicImage.setNetImage(URL.init(string: news.topic_logo)!)
        }
        
        if 0 != news.thumb.characters.count{
            detailImage.setNetImage(URL.init(string: news.thumb)!)
        }
        
        var height : CGFloat = 10.0
        
        titleLabel.text = news.title
        let titleHeight : CGFloat = max(40, titleLabel.sizeThatFits(CGSize(width: ScreenWidth - 35 - 40, height: CGFloat.greatestFiniteMagnitude)).height)
        titleLabel.frame = CGRect(x: 15, y: height, width: ScreenWidth - 35 - 40, height: titleHeight)
        titleLabel.textColor = KLTheme.sharedInstance.titleTextColor
        
        detailLabel.text = news.summary
        let detailHeight : CGFloat = detailLabel.sizeThatFits(CGSize(width: ScreenWidth - 30, height: CGFloat.greatestFiniteMagnitude)).height
        detailLabel.frame = CGRect(x: 15, y: height + titleHeight + 10, width: ScreenWidth - 30, height: detailHeight)
        detailLabel.textColor = KLTheme.sharedInstance.detailTextColor
        
        detailImage.frame = CGRect(x: ScreenWidth - 15 - 40, y: (max(height, 60) - 40) / 2, width: 40, height: 40)
        topicImage.frame = CGRect(x: ScreenWidth - 15 - 40, y: (max(height, 60) - 40) / 2, width: 40, height: 40)
        backgImage.frame = CGRect(x: ScreenWidth - 15 - 40, y: (max(height, 60) - 40) / 2, width: 40, height: 40)
        
        height += titleHeight + 10
        
        if showDetail {
            mainView.addSubview(detailLabel)
            detailLabel.alpha = 1
            detailImage.alpha = 1
            topicImage.alpha = 0
            
            height += detailHeight + 10
            self.mainView.backgroundColor = KLTheme.sharedInstance.themeType == .defaultTheme ? UIColor(white:245/255, alpha:1) : UIColor(white:38/255, alpha:1)
        } else {
            detailLabel.alpha = 0
            detailLabel.removeFromSuperview()
            detailImage.alpha = 0
            topicImage.alpha = 1
            self.mainView.backgroundColor = KLTheme.sharedInstance.themeType == .defaultTheme ? UIColor(white:255/255, alpha:1) : UIColor(white:51/255, alpha:1)
        }
        
        mainView.frame = CGRect(x: 0, y: 0, width: ScreenWidth, height: height)
        line.frame = CGRect(x: 0, y: height - 0.5, width: ScreenWidth, height: 0.5)
        
        moreIcon.frame = CGRect(x: ScreenWidth, y: (height - 24) / 2, width: 70, height: 24)
    }
    
    func setDetailViewable(_ showDetail : Bool) {
        detailStatus = showDetail
        if showDetail {
            mainView.addSubview(detailLabel)
            self.detailLabel.alpha = 0
            UIView.animate(withDuration: 0.3, animations: {
                self.mainView.frame = CGRect(x: 0, y: 0, width: ScreenWidth, height: 10 + self.titleLabel.frame.size.height + 10 + self.detailLabel.frame.size.height + 10)
                self.line.frame = CGRect(x: 0, y: self.mainView.frame.size.height - 0.5, width: ScreenWidth, height: 0.5)
                self.detailLabel.alpha = 1
                
                self.detailImage.alpha = 1
                self.topicImage.alpha = 0
                self.mainView.backgroundColor = KLTheme.sharedInstance.detailTextBackgroundColor
            }, completion:nil)
            moreIcon.frame = CGRect(x: ScreenWidth, y: (self.mainView.frame.size.height - 24) / 2, width: 70, height: 24)
        } else {
            UIView.animate(withDuration: 0.3, animations: {
                self.mainView.frame = CGRect(x: 0, y: 0, width: ScreenWidth, height: 10 + self.titleLabel.frame.size.height + 10)
                self.line.frame = CGRect(x: 0, y: self.mainView.frame.size.height - 0.5, width: ScreenWidth, height: 0.5)
                self.detailLabel.alpha = 0
                
                self.detailImage.alpha = 0
                self.topicImage.alpha = 1
                self.mainView.backgroundColor = KLTheme.sharedInstance.textBackgroundColor
            },completion:{ (complete) in
                self.detailLabel.removeFromSuperview()
            })
            moreIcon.frame = CGRect(x: ScreenWidth, y: (self.mainView.frame.size.height - 24) / 2, width: 70, height: 24)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

extension NewsCell{
    class func calHeight(_ news: CBNews, showDetail: Bool) -> CGFloat {
        var height : CGFloat = 10.0
        
        let titleLabel : UILabel = UILabel()
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        titleLabel.numberOfLines = 0
        titleLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        titleLabel.text = news.title
        let titleHeight : CGFloat = max(40, titleLabel.sizeThatFits(CGSize(width: ScreenWidth - 35 - 40, height: CGFloat.greatestFiniteMagnitude)).height)
        
        height += titleHeight + 10
        
        if showDetail{
            let detailLabel : UILabel = UILabel()
            detailLabel.font = UIFont.systemFont(ofSize: 14)
            detailLabel.numberOfLines = 0;
            detailLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
            detailLabel.text = news.summary
            let detailHeight : CGFloat = detailLabel.sizeThatFits(CGSize(width: ScreenWidth - 30, height: CGFloat.greatestFiniteMagnitude)).height
            
            height += detailHeight + 10
        }
        
        return max(height, 60)
    }
    
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if let panGestureRecognizer = gestureRecognizer as? UIPanGestureRecognizer {
            let point = panGestureRecognizer.velocity(in: self)
            if abs(point.x) > abs(point.y) {
                return true
            } else {
                return false
            }
        }
        return !isEditing
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




