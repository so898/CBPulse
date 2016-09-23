//
//  ViewController.swift
//  CBPulse
//
//  Created by Bill Cheng on 16/6/4.
//  Copyright © 2016年 R3 Studio. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NewsCellDelegate, UIViewControllerPreviewingDelegate {
    fileprivate var mainArray : NSMutableArray = NSMutableArray()
    fileprivate var selectRow : Int = -1
    fileprivate var mainTable : UITableView = UITableView()
    fileprivate let refreshControl : UIRefreshControl  = UIRefreshControl()
    fileprivate var loadMore : Bool = false
    
    convenience init() {
        self.init(nibName: nil, bundle: nil)
        addNotification()
        title = "首页"
        view.backgroundColor = UIColor.white
        
        mainTable = UITableView()
        mainTable.frame = CGRect(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight)
        mainTable.backgroundColor = KLTheme.sharedInstance.tableBackgroundColor
        mainTable.delegate = self
        mainTable.dataSource = self
        mainTable.tableFooterView = UIView()
        mainTable.separatorStyle = UITableViewCellSeparatorStyle.none
        mainTable.addNotification()
        view.addSubview(mainTable)
        
        refreshControl.attributedTitle = NSAttributedString.init(string: "下拉刷新");
        refreshControl.tintColor = KLTheme.sharedInstance.detailTextColor;
        refreshControl.addTarget(self, action: #selector(pullToRefresh), for: UIControlEvents.valueChanged)
        mainTable.insertSubview(refreshControl, at: 0)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "改颜色", style: UIBarButtonItemStyle.plain, target: self, action: #selector(changeTheme))
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mainArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let news : CBNews = mainArray.object(at: (indexPath as NSIndexPath).row) as! CBNews
        return NewsCell.calHeight(news, showDetail: selectRow == (indexPath as NSIndexPath).row)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell : NewsCell? = tableView.dequeueReusableCell(withIdentifier: "NewCell") as? NewsCell
        if nil == cell{
            cell = NewsCell.init(style: UITableViewCellStyle.default, reuseIdentifier: "abc")
        }
        let news : CBNews = mainArray.object(at: (indexPath as NSIndexPath).row) as! CBNews
        cell?.setCBNews(news, showDetail: selectRow == (indexPath as NSIndexPath).row)
        cell?.delegate = self
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let cell : NewsCell = tableView.cellForRow(at: indexPath) as! NewsCell
        tableView.beginUpdates()
        if selectRow != -1 && selectRow != (indexPath as NSIndexPath).row {
            let selectedCell : NewsCell? = tableView.cellForRow(at: IndexPath.init(row: selectRow, section: 0)) as? NewsCell
            selectedCell?.setDetailViewable(false)
        }
        cell.setDetailViewable(selectRow == (indexPath as NSIndexPath).row ? false : true)
        selectRow = selectRow == (indexPath as NSIndexPath).row ? -1 : (indexPath as NSIndexPath).row
        tableView.endUpdates()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y + ScreenHeight > mainTable.contentSize.height && mainArray.count != 0 && mainTable.contentSize.height != 0 && !loadMore{
            loadMore = true
            let lastNews : CBNews = mainArray.lastObject as! CBNews
            ServerManager.sharedInstance.getNewsList(lastNews.sid, success: { (array) in
                let oldNum : Int = self.mainArray.count
                self.mainArray.addObjects(from: array as [AnyObject])
                var indexs : Array = Array<IndexPath>()
                for i in oldNum  ..< self.mainArray.count  {
                    indexs.append(IndexPath.init(row: i, section: 0))
                }
                self.mainTable.beginUpdates()
                self.mainTable.insertRows(at: indexs, with: UITableViewRowAnimation.fade)
                self.mainTable.endUpdates()
                self.loadMore = false
            }, fail: { (code, error) in
                self.loadMore = false
            })
        }
    }
    
    func openNewsDetail(_ news: CBNews) {
        let viewController : NewsDetailViewController = NewsDetailViewController()
        viewController.setNews(news.sid)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        // Check if already displaying a preview controller
        if let presented = presentedViewController {
            if presented is NewsDetailViewController {
                return nil
            }
        }
        
        let cellPostion :CGPoint = mainTable.convert(location, from: self.view)
        let path = mainTable.indexPathForRow(at: cellPostion)
        let news : CBNews = mainArray.object(at: (path! as NSIndexPath).row) as! CBNews
        
        let cell = mainTable.cellForRow(at: path!)
        previewingContext.sourceRect = self.view.convert((cell?.frame)!, from: mainTable)
        
        // Peek (shallow press)
        let detailViewcontroller = NewsDetailViewController()
        detailViewcontroller.setNews(news.sid)
        return detailViewcontroller
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        // Pop (deep press)
        show(viewControllerToCommit, sender: self)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if traitCollection.forceTouchCapability == .available {
            // force touch avaiable
            self.registerForPreviewing(with: self, sourceView: self.view)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
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
    
    override func viewDidDisappear(_ animated: Bool) {
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

