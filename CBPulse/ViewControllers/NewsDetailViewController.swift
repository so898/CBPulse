//
//  NewsDetailViewController.swift
//  CBPulse
//
//  Created by Bill Cheng on 16/6/8.
//  Copyright © 2016年 R3 Studio. All rights reserved.
//

import Foundation
import UIKit

class NewsDetailViewController: UIViewController, UITextViewDelegate {
    private var mainText : UITextView = UITextView()
    
    private var attributedString = NSMutableAttributedString()
    
    convenience init() {
        self.init(nibName: nil, bundle: nil)
        addNotification()
        title = "详细"
        view.backgroundColor = KLTheme.sharedInstance.detailTextBackgroundColor
        
        mainText.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight)
        mainText.textColor = KLTheme.sharedInstance.detailTextColor
        mainText.backgroundColor = KLTheme.sharedInstance.textBackgroundColor
        mainText.font = UIFont.systemFontOfSize(16)
        mainText.editable = false
        mainText.delegate = self
        mainText.addNotification()
        view.addSubview(mainText)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "改颜色", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(changeTheme))
    }
    
    @objc func changeTheme() {
        KLTheme.sharedInstance.changeType()
    }
    
    func setNews(sid: Int){
        ServerManager.sharedInstance.getNewsDetail(sid, success: { (detail) in
            
            dispatch_async(dispatch_queue_create("NewTextQueue", nil), {
                // Perform long running process
                let titleParagraphStyle : NSMutableParagraphStyle = NSMutableParagraphStyle();
                titleParagraphStyle.alignment = NSTextAlignment.Center
                titleParagraphStyle.lineBreakMode = NSLineBreakMode.ByWordWrapping
                titleParagraphStyle.lineSpacing = 5
                titleParagraphStyle.firstLineHeadIndent = 10
                titleParagraphStyle.headIndent = 10
                titleParagraphStyle.tailIndent = -10
                
                let titleString = NSAttributedString.init(string: detail.title + "\n\n", attributes: [NSFontAttributeName: UIFont.boldSystemFontOfSize(20), NSParagraphStyleAttributeName:titleParagraphStyle])
                self.attributedString.appendAttributedString(titleString)
                
                let bodyContent = detail.hometext + "\n" + detail.bodytext
                print(bodyContent)
                var bodyString : NSMutableAttributedString = NSMutableAttributedString()
                do {
                    let bodyParagraphStyle : NSMutableParagraphStyle = NSMutableParagraphStyle();
                    bodyParagraphStyle.lineBreakMode = NSLineBreakMode.ByWordWrapping
                    bodyParagraphStyle.lineSpacing = 10
                    bodyParagraphStyle.firstLineHeadIndent = 10
                    bodyParagraphStyle.headIndent = 10
                    bodyParagraphStyle.tailIndent = -10
                    
                    
                    bodyString = try NSMutableAttributedString.init(data: bodyContent.dataUsingEncoding(NSUTF8StringEncoding)!, options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute: (NSUTF8StringEncoding)], documentAttributes: nil)
                    bodyString.addAttributes([NSFontAttributeName: UIFont.boldSystemFontOfSize(15), NSParagraphStyleAttributeName: bodyParagraphStyle], range: NSMakeRange(0, bodyString.length))
                } catch _ {
                    
                }
                print(bodyString)
                bodyString.beginEditing()
                bodyString.enumerateAttribute(NSAttachmentAttributeName, inRange: NSMakeRange(0, bodyString.length), options: NSAttributedStringEnumerationOptions(rawValue: 0)) { (value, range, stop) -> Void in
                    if let attachement = value as? NSTextAttachment {
                        let image = attachement.imageForBounds(attachement.bounds, textContainer: NSTextContainer(), characterIndex: range.location)
                        if image!.size.width > ScreenWidth-30 {
                            let newImage = image!.resizeImage((ScreenWidth - 30)/image!.size.width)
                            let newAttribut = NSTextAttachment()
                            newAttribut.image = newImage
                            bodyString.addAttribute(NSAttachmentAttributeName, value: newAttribut, range: range)
                        }
                    }
                }
                bodyString.endEditing()
                
                self.attributedString.appendAttributedString(bodyString)
                dispatch_async(dispatch_get_main_queue(), {
                    // Update the UI
                    self.mainText.attributedText = self.attributedString
                    self.mainText.textColor = KLTheme.sharedInstance.detailTextColor
                })
            })
            
        }, fail: { (code, error) in
            print(error)
        })
    }
}

class CBTextAttachment: NSTextAttachment {
    
    override func attachmentBoundsForTextContainer(textContainer: NSTextContainer?, proposedLineFragment lineFrag: CGRect, glyphPosition position: CGPoint, characterIndex charIndex: Int) -> CGRect {
        let height = lineFrag.size.height
        var scale: CGFloat = 1.0;
        let imageSize = image!.size
        
        if (height < imageSize.height) {
            scale = height / imageSize.height
        }
        
        return CGRect(x: 0, y: 0, width: imageSize.width * scale, height: imageSize.height * scale)
    }
}

extension UIImage {
    func resizeImage(scale: CGFloat) -> UIImage {
        let newSize = CGSizeMake(self.size.width*scale, self.size.height*scale)
        let rect = CGRectMake(0, 0, newSize.width, newSize.height)
        
        UIGraphicsBeginImageContext(newSize)
        self.drawInRect(rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
}
