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
    fileprivate var mainText : UITextView = UITextView()
    
    fileprivate var attributedString = NSMutableAttributedString()
    
    convenience init() {
        self.init(nibName: nil, bundle: nil)
        addNotification()
        title = "详细"
        view.backgroundColor = KLTheme.sharedInstance.detailTextBackgroundColor
        
        mainText.frame = CGRect(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight)
        mainText.textColor = KLTheme.sharedInstance.detailTextColor
        mainText.backgroundColor = KLTheme.sharedInstance.textBackgroundColor
        mainText.font = UIFont.systemFont(ofSize: 16)
        mainText.isEditable = false
        mainText.delegate = self
        mainText.addNotification()
        view.addSubview(mainText)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "改颜色", style: UIBarButtonItemStyle.plain, target: self, action: #selector(changeTheme))
    }
    
    @objc func changeTheme() {
        KLTheme.sharedInstance.changeType()
    }
    
    func setNews(_ sid: Int){
        ServerManager.sharedInstance.getNewsDetail(sid, success: { (detail) in
            
            DispatchQueue(label: "NewTextQueue", attributes: []).async(execute: {
                // Perform long running process
                let titleParagraphStyle : NSMutableParagraphStyle = NSMutableParagraphStyle();
                titleParagraphStyle.alignment = NSTextAlignment.center
                titleParagraphStyle.lineBreakMode = NSLineBreakMode.byWordWrapping
                titleParagraphStyle.lineSpacing = 5
                titleParagraphStyle.firstLineHeadIndent = 10
                titleParagraphStyle.headIndent = 10
                titleParagraphStyle.tailIndent = -10
                
                let titleString = NSAttributedString.init(string: detail.title + "\n\n", attributes: [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 20), NSParagraphStyleAttributeName:titleParagraphStyle])
                self.attributedString.append(titleString)
                
                let bodyContent = detail.hometext + "\n" + detail.bodytext
//                print(bodyContent)
                var bodyString : NSMutableAttributedString = NSMutableAttributedString()
                do {
                    let bodyParagraphStyle : NSMutableParagraphStyle = NSMutableParagraphStyle();
                    bodyParagraphStyle.lineBreakMode = NSLineBreakMode.byWordWrapping
                    bodyParagraphStyle.lineSpacing = 10
                    bodyParagraphStyle.firstLineHeadIndent = 10
                    bodyParagraphStyle.headIndent = 10
                    bodyParagraphStyle.tailIndent = -10
                    
                    bodyString = try NSMutableAttributedString(data: bodyContent.data(using: String.Encoding.utf8)!, options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute: String.Encoding.utf8.rawValue], documentAttributes: nil)
                    bodyString.addAttributes([NSFontAttributeName: UIFont.boldSystemFont(ofSize: 15), NSParagraphStyleAttributeName: bodyParagraphStyle], range: NSMakeRange(0, bodyString.length))
                } catch let error as NSError {
                    print(error.localizedDescription)
                }
//                print(bodyString)
                bodyString.beginEditing()
                bodyString.enumerateAttribute(NSAttachmentAttributeName, in: NSMakeRange(0, bodyString.length), options: NSAttributedString.EnumerationOptions(rawValue: 0)) { (value, range, stop) -> Void in
                    if let attachement = value as? NSTextAttachment {
                        let image = attachement.image(forBounds: attachement.bounds, textContainer: NSTextContainer(), characterIndex: range.location)
                        if image!.size.width > ScreenWidth-30 {
                            let newImage = image!.resizeImage((ScreenWidth - 30)/image!.size.width)
                            let newAttribut = NSTextAttachment()
                            newAttribut.image = newImage
                            bodyString.addAttribute(NSAttachmentAttributeName, value: newAttribut, range: range)
                        }
                    }
                }
                bodyString.endEditing()

                self.attributedString.append(bodyString)
                DispatchQueue.main.async(execute: {
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
    
    override func attachmentBounds(for textContainer: NSTextContainer?, proposedLineFragment lineFrag: CGRect, glyphPosition position: CGPoint, characterIndex charIndex: Int) -> CGRect {
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
    func resizeImage(_ scale: CGFloat) -> UIImage {
        let newSize = CGSize(width: self.size.width*scale, height: self.size.height*scale)
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        UIGraphicsBeginImageContext(newSize)
        self.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
}
