//
//  ViewController.swift
//  CBPulse
//
//  Created by Bill Cheng on 16/6/4.
//  Copyright © 2016年 R3 Studio. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NewsCellDelegate {
    private var mainArray : NSMutableArray = NSMutableArray()
    private var selectRow : Int = -1
    private var mainTable : UITableView = UITableView()
    private let refreshControl : UIRefreshControl  = UIRefreshControl()
    private var loadMore : Bool = false
    
    convenience init() {
        self.init(nibName: nil, bundle: nil)
        addNotification()
        title = "首页"
        view.backgroundColor = UIColor.whiteColor()
        
        mainTable = UITableView()
        mainTable.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight)
        mainTable.backgroundColor = KLTheme.sharedInstance.tableBackgroundColor
        mainTable.delegate = self
        mainTable.dataSource = self
        mainTable.tableFooterView = UIView()
        mainTable.separatorStyle = UITableViewCellSeparatorStyle.None
        mainTable.addNotification()
        view.addSubview(mainTable)
        
        refreshControl.attributedTitle = NSAttributedString.init(string: "下拉刷新");
        refreshControl.tintColor = KLTheme.sharedInstance.detailTextColor;
        refreshControl.addTarget(self, action: #selector(pullToRefresh), forControlEvents: UIControlEvents.ValueChanged)
        mainTable.insertSubview(refreshControl, atIndex: 0)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "改颜色", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(changeTheme))
    }
    
    @objc func pullToRefresh(){
        refreshControl.attributedTitle = NSAttributedString.init(string: "刷新中");
        ServerManager.sharedInstance.getNewsList(nil, success: { (array) in
            self.mainArray = array as! NSMutableArray
            self.mainTable.reloadData()
            self.refreshControl.endRefreshing();
            self.refreshControl.attributedTitle = NSAttributedString.init(string: "下拉刷新");
        }, fail: { (code, error) in
            print(code)
        })
    }
    
    @objc func changeTheme() {
        KLTheme.sharedInstance.changeType()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mainArray.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let news : CBNews = mainArray.objectAtIndex(indexPath.row) as! CBNews
        return NewsCell.calHeight(news, showDetail: selectRow == indexPath.row)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell : NewsCell? = tableView.dequeueReusableCellWithIdentifier("NewCell") as? NewsCell
        if nil == cell{
            cell = NewsCell.init(style: UITableViewCellStyle.Default, reuseIdentifier: "abc")
        }
        let news : CBNews = mainArray.objectAtIndex(indexPath.row) as! CBNews
        cell?.setCBNews(news, showDetail: selectRow == indexPath.row)
        cell?.delegate = self
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let cell : NewsCell = tableView.cellForRowAtIndexPath(indexPath) as! NewsCell
        tableView.beginUpdates()
        if selectRow != -1 && selectRow != indexPath.row {
            let selectedCell : NewsCell? = tableView.cellForRowAtIndexPath(NSIndexPath.init(forRow: selectRow, inSection: 0)) as? NewsCell
            selectedCell?.setDetailViewable(false)
        }
        cell.setDetailViewable(selectRow == indexPath.row ? false : true)
        selectRow = selectRow == indexPath.row ? -1 : indexPath.row
        tableView.endUpdates()
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if scrollView.contentOffset.y + ScreenHeight > mainTable.contentSize.height && mainArray.count != 0 && mainTable.contentSize.height != 0 && !loadMore{
            loadMore = true
            let lastNews : CBNews = mainArray.lastObject as! CBNews
            ServerManager.sharedInstance.getNewsList(lastNews.sid, success: { (array) in
                let oldNum : Int = self.mainArray.count
                self.mainArray.addObjectsFromArray(array as [AnyObject])
                var indexs : Array = Array<NSIndexPath>()
                for i in oldNum  ..< self.mainArray.count  {
                    indexs.append(NSIndexPath.init(forRow: i, inSection: 0))
                }
                self.mainTable.beginUpdates()
                self.mainTable.insertRowsAtIndexPaths(indexs, withRowAnimation: UITableViewRowAnimation.Fade)
                self.mainTable.endUpdates()
                self.loadMore = false
            }, fail: { (code, error) in
                self.loadMore = false
            })
        }
    }
    
    func openNewsDetail(news: CBNews) {        
        let viewController : NewsDetailViewController = NewsDetailViewController()
        viewController.setNews(news.sid)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if (mainArray.count == 0){
            ServerManager.sharedInstance.getNewsList(nil, success: { (array) in
                self.mainArray = array as! NSMutableArray
                self.mainTable.reloadData()
                }, fail: { (code, error) in
                    print(code)
            })
        }
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

