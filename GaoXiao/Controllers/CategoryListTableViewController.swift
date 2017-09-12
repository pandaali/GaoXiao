//
//  CategoryListViewController.swift
//  GaoXiao
//
//  Created by 汪红亮 on 2017/9/9.
//  Copyright © 2017年 rekuu. All rights reserved.
//

import UIKit
import WebKit
import MJRefresh

class CategoryListTableViewController: UITableViewController {
    
    var webView: WKWebView!
    
    var articleList: [ArticleRecord] = []
    let imageOperations = ImageOperations()
    var parentNav: UINavigationController?
    var categoryid:Int!
    
    let timeZone = TimeZone.init(identifier: "UTC")
    let formatter = DateFormatter()
    
    //加载视频播放器
    var player:CJVideoPlayer! = nil
    var _indexPath = IndexPath()
    var videoCell = VideoCell()
    
    //加载动态图片
    var imageView = UIImageView()
    var gifCell = GifCell()
    
    // 顶部刷新
    let header = MJRefreshNormalHeader()
    var refreshTime = Date()
    
    
    // 底部加载
    let footer = MJRefreshAutoNormalFooter()
    var pageIndex = 1
    var pageSize = 12
    var pageCount = 1
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //首次加载数据
        refreshTime = Date()
        loadMore()
        
        
        self.tableView!.delegate = self
        self.tableView!.dataSource = self
        
        //下拉刷新相关设置
        header.setRefreshingTarget(self, refreshingAction: #selector(self.loadNew))
        self.tableView!.mj_header = header
        
        //上刷新相关设置
        footer.setRefreshingTarget(self, refreshingAction: #selector(self.loadMore))
        //是否自动加载（默认为true，即表格滑到底部就自动加载）
        footer.isAutomaticallyRefresh = false
        
        self.tableView!.mj_footer = footer
        
        //设置表格预估高度和自动高度
        tableView.estimatedRowHeight = 200
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    //加载最新数据
    func loadNew() -> Void {
        
        formatter.locale = Locale.current
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let strtime = formatter.string(from: refreshTime)
        
        //请求最新数据
        Article.getArticleNew(categoryid: categoryid, top:10, refreshtime: strtime){ (contents) in
            if contents != nil{
                //网络请求是异步线程，需要加到主线程
                OperationQueue.main.addOperation {
                    
                    //更新刷新时间
                    self.refreshTime = Date()
                    
                    for item in contents!.articles!{
                        self.articleList.insert(ArticleRecord(article: item, url: ""), at: 0)
                    }
                    //重现加载表格数据
                    self.tableView.reloadData()
                    //结束刷新
                    self.tableView!.mj_header.endRefreshing()
                }
            }else{
                print("网络错误")
            }
            //重现加载表格数据
            self.tableView!.reloadData()
            //结束刷新
            self.tableView!.mj_header.endRefreshing()
        }
    }
    
    //加载更多数据
    func loadMore(){
        //判断是否到达最后一页
        if(self.pageIndex > self.pageCount){
            //结束刷新状态
            self.tableView!.mj_footer.endRefreshing()
            
            return
        }
        else{
            
            Article.getArticle(categoryid: categoryid, pagesize:pageSize, pageindex: pageIndex){ (contents) in
                if contents != nil{
                    //网络请求是异步线程，需要加到主线程
                    OperationQueue.main.addOperation {
                        
                        //设置页数
                        self.pageCount = contents!.pageCount
                        
                        for item in contents!.articles{
                            self.articleList.append(ArticleRecord(article: item, url: ""))
                        }
                        //重现加载表格数据
                        self.tableView.reloadData()
                        //结束刷新
                        self.tableView!.mj_footer.endRefreshing()
                    }
                }
                else{
                    print("网络错误")
                }
            }
            //当前页码+1
            pageIndex+=1
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.articleList.count
        
        //return newsList.count;
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //获取当前行所对应的记录。
        let articleRecord = self.articleList[indexPath.row] as ArticleRecord
        let article = articleRecord.article
        
        
        switch categoryid {
        case 52:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TextCell", for: indexPath) as! TextCell
            cell.lblTitle.text = article.title
            cell.lblText.text = article.content.pregReplace(pattern: "<[^>]*>", with:"")
            
            cell.lblComment.text = article.add_time!
            
            return cell
            
        case 53:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ImgCell", for: indexPath) as! ImgCell
            
            
            //let outcome = article.content.matches(pattern: "(https?|ftp|mms)://([A-z0-9]+[_-]?[A-z0-9]+.)*[A-z0-9]+-?[A-z0-9]+.[A-z]{2,}(/.[A-z])*/?")
            //if outcome.count == 0{
            //没有匹配到
            //}else{
            //    articleRecord.url = outcome.first!.extraction
            //}
            
            articleRecord.url = article.zhaiyao
            //cell.loadImage(urlString: articleRecord.url)
            
            cell.lblTitle.text = article.title
            cell.imgContent.image = articleRecord.image
            
            cell.SetImageRect()
            
            //检查图片状态。然后开始执行任务
            switch (articleRecord.state){
            case .filtered: break
            case .failed:
                cell.textLabel?.text = "Failed to load"
            case .new, .downloaded:
                //只有停止拖动的时候才加载
                //if (!tableView.isDragging && !tableView.isDecelerating) {
                self.startOperationsForMovieRecord(articleRecord, indexPath: indexPath)
                //}
            }
            
            
            
            return cell
            
        case 54:
            let cell = tableView.dequeueReusableCell(withIdentifier: "VideoCell", for: indexPath) as! VideoCell
            
            articleRecord.type = .video
            articleRecord.url = article.zhaiyao
            //设置默认图片
            cell.imgVideo.image = articleRecord.image
            cell.mp4_url = article.zhaiyao
            cell.lblTitle.text = article.title
            cell.SetImageRect();
            
            //cell.loadImage(urlString: article.zhaiyao)
            
            //检查图片状态。然后开始执行任务
            switch (articleRecord.state){
            case .filtered:
                break
            case .failed:
                break
            case .new, .downloaded:
                //只有停止拖动的时候才加载
                //if (!tableView.isDragging && !tableView.isDecelerating) {
                self.startOperationsForMovieRecord(articleRecord, indexPath: indexPath)
                //}
            }
            
            
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(self.showVideoPlayer(sender:)))
            
            cell.player.addGestureRecognizer(tap)
            cell.player.isUserInteractionEnabled = true
            cell.player.tag = indexPath.row+100
            
            
            return cell
            
        case 55:
            let cell = tableView.dequeueReusableCell(withIdentifier: "GifCell", for: indexPath) as! GifCell
            
            
            articleRecord.url = article.zhaiyao
            
            //设置
            articleRecord.type = .gif
            cell.lblTitle.text = article.title
            cell.gifContent.image = articleRecord.image
            cell.gifUrl = articleRecord.url
            
            
            //cell.loadImage(urlString: articleRecord.url)
            
            
            cell.SetImageRect();
            
            //检查图片状态。然后开始执行任务
            switch (articleRecord.state){
            case .filtered:
                break
            case .failed:
                break
            case .new, .downloaded:
                //只有停止拖动的时候才加载
                //if (!tableView.isDragging && !tableView.isDecelerating) {
                self.startOperationsForMovieRecord(articleRecord, indexPath: indexPath)
                //}
            }
            
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(self.showGifImage(sender:)))
            
            cell.btnLoadGif.addGestureRecognizer(tap)
            cell.btnLoadGif.isUserInteractionEnabled = true
            cell.btnLoadGif.tag = indexPath.row+100
            
            
            return cell
            
        default:
            return UITableViewCell()
        }
    }
    
    //显示视频播放器
    func showVideoPlayer(sender:UITapGestureRecognizer) -> Void {
        if player != nil{
            player.destroy()
        }
        
        let tapView = sender.view
        _indexPath = IndexPath(row: tapView!.tag - 100, section: 0)
        videoCell = tableView.cellForRow(at: _indexPath) as! VideoCell
        
        player = CJVideoPlayer()
        player.videoUrl = videoCell.mp4_url
        player.palyerBindTableView(self.tableView, at: _indexPath)
        player.frame = videoCell.imgVideo.bounds// tapView!.bounds
        player.frame.origin.x += 5
        player.frame.origin.y += 58
        player.isSupportSmallWindowPlaying(false)
        player.accessibilityNavigationStyle = UIAccessibilityNavigationStyle(rawValue: accessibilityNavigationStyle.hashValue)!
        
        videoCell.contentView.addSubview(player)
        player.completedPlayingBlock = {(player) -> (Void) in
            player?.destroy()
        }
    }
    
    //显示Gif
    func showGifImage(sender:UITapGestureRecognizer) -> Void {
        
        
        let tapView = sender.view
        _indexPath = IndexPath(row: tapView!.tag - 100, section: 0)
        gifCell = tableView.cellForRow(at: _indexPath) as! GifCell
        
        if imageView.image != nil{
            imageView.image = nil
            imageView.removeFromSuperview()
        }
        
        //定义NSURL对象
        let url = URL(string: gifCell.gifUrl)
        let data = try? Data(contentsOf: url!)
        //从网络获取数据流,再通过数据流初始化图片
        if let imageData = data, let image = UIImage.gif(data: imageData){
            imageView.image = image
            imageView.frame = gifCell.gifContent.bounds// tapView!.bounds
            imageView.frame.origin.x += 10
            imageView.frame.origin.y += 60
            
            gifCell.contentView.addSubview(imageView)
        }
        
    }
    
    
    //图片任务
    func startOperationsForMovieRecord(_ articleRecord: ArticleRecord, indexPath: IndexPath){
        switch (articleRecord.state) {
        case .new:
            //判断是否为图片列
            if articleRecord.url == ""{
                break
            }
            startDownloadForRecord(articleRecord, indexPath: indexPath)
        case .downloaded:
            break
        //startFiltrationForRecord(articleRecord, indexPath: indexPath)
        default:
            NSLog("do nothing")
        }
    }
    
    //执行图片下载任务
    func startDownloadForRecord(_ articleRecord: ArticleRecord, indexPath: IndexPath){
        //判断队列中是否已有该图片任务
        if let _ = imageOperations.downloadsInProgress[indexPath] {
            return
        }
        
        //创建一个下载任务
        let downloader = ImageDownloader(articleRecord: articleRecord)
        //任务完成后重新加载对应的单元格
        downloader.completionBlock = {
            if downloader.isCancelled {
                return
            }
            DispatchQueue.main.async(execute: {
                self.imageOperations.downloadsInProgress.removeValue(forKey: indexPath)
                self.tableView.reloadRows(at: [indexPath], with: .fade)
            })
        }
        //记录当前下载任务
        imageOperations.downloadsInProgress[indexPath] = downloader
        //将任务添加到队列中
        imageOperations.downloadQueue.addOperation(downloader)
    }
    
    //执行图片滤镜任务
    func startFiltrationForRecord(_ articleRecord: ArticleRecord, indexPath: IndexPath){
        if let _ = imageOperations.filtrationsInProgress[indexPath]{
            return
        }
        
        let filterer = ImageFiltration(articleRecord: articleRecord)
        filterer.completionBlock = {
            if filterer.isCancelled {
                return
            }
            DispatchQueue.main.async(execute: {
                self.imageOperations.filtrationsInProgress.removeValue(forKey: indexPath)
                self.tableView.reloadRows(at: [indexPath], with: .fade)
            })
        }
        imageOperations.filtrationsInProgress[indexPath] = filterer
        imageOperations.filtrationQueue.addOperation(filterer)
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.isEqual(self.tableView) {
            if player != nil {
                player.isSupportSmallWindowPlaying(false)
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        if player != nil {
            player.destroy()
        }
        
        //只有停止拖动的时候才加载
        if (!tableView.isDragging && !tableView.isDecelerating) {
            if self.imageView.isAnimating{
                self.imageView.removeFromSuperview()
            }
        }
        
    }
    
    //视图开始滚动
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        /*//一旦用户开始滚动屏幕，你将挂起所有任务并留意用户想要看哪些行。
         if scrollView.isEqual(self.tableView) {
         if player != nil {
         suspendAllOperations()
         }
         }*/
    }
    
    //视图停止拖动
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView,
                                           willDecelerate decelerate: Bool) {
        /*//如果减速（decelerate）是 false ，表示用户停止拖拽tableview。
         //此时你要继续执行之前挂起的任务，撤销不在屏幕中的cell的任务并开始在屏幕中的cell的任务。
         if scrollView.isEqual(self.tableView) {
         if player != nil {
         if !decelerate {
         loadImagesForOnscreenCells()
         resumeAllOperations()
         }
         }
         }*/
        
    }
    
    //视图停止减速
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        /*//这个代理方法告诉你tableview停止滚动，执行操作同上
         if scrollView.isEqual(self.tableView) {
         if player != nil {
         loadImagesForOnscreenCells()
         resumeAllOperations()
         }
         }*/
    }
    
    //暂停所有队列
    func suspendAllOperations () {
        imageOperations.downloadQueue.isSuspended = true
        imageOperations.filtrationQueue.isSuspended = true
    }
    
    //恢复运行所有队列
    func resumeAllOperations () {
        imageOperations.downloadQueue.isSuspended = false
        imageOperations.filtrationQueue.isSuspended = false
    }
    
    //加载可见区域的单元格图片
    func loadImagesForOnscreenCells () {
        //开始将tableview可见行的index path放入数组中。
        if let pathsArray = self.tableView.indexPathsForVisibleRows {
            //通过组合所有下载队列和滤镜队列中的任务来创建一个包含所有等待任务的集合
            let allMovieOperations = NSMutableSet()
            for key in imageOperations.downloadsInProgress.keys{
                allMovieOperations.add(key)
            }
            for key in imageOperations.filtrationsInProgress.keys{
                allMovieOperations.add(key)
            }
            
            //构建一个需要撤销的任务的集合。从所有任务中除掉可见行的index path，
            //剩下的就是屏幕外的行所代表的任务。
            let toBeCancelled = allMovieOperations.mutableCopy() as! NSMutableSet
            let visiblePaths = NSSet(array: pathsArray)
            toBeCancelled.minus(visiblePaths as Set<NSObject>)
            
            //创建一个需要执行的任务的集合。从所有可见index path的集合中除去那些已经在等待队列中的。
            let toBeStarted = visiblePaths.mutableCopy() as! NSMutableSet
            toBeStarted.minus(allMovieOperations as Set<NSObject>)
            
            // 遍历需要撤销的任务，撤消它们，然后从 movieOperations 中去掉它们
            for indexPath in toBeCancelled {
                let indexPath = indexPath as! IndexPath
                if let imageDownload = imageOperations.downloadsInProgress[indexPath] {
                    imageDownload.cancel()
                }
                imageOperations.downloadsInProgress.removeValue(forKey: indexPath)
                if let imageFiltration = imageOperations.filtrationsInProgress[indexPath] {
                    imageFiltration.cancel()
                }
                imageOperations.filtrationsInProgress.removeValue(forKey: indexPath)
            }
            
            // 遍历需要开始的任务，调用 startOperationsForPhotoRecord
            for indexPath in toBeStarted {
                let indexPath = indexPath as! IndexPath
                let recordToProcess = self.articleList[indexPath.row]
                startOperationsForMovieRecord(recordToProcess, indexPath: indexPath)
            }
        }
    }
    
    
}
