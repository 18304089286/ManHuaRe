//
//  ReviewCollectionViewController.swift
//  ManHuaRe
//
//  Created by 孙宇 on 16/4/24.
//  Copyright © 2016年 孙宇. All rights reserved.
//

import UIKit
import FMDB

private let reuseIdentifier = "Cell"

class ReviewCollectionViewController: UICollectionViewController {
    var bookModel:BookList?//书详情
    var chapterIndex: Int?
    private var dataArray = []//漫画数组
    private var chapterArray:NSMutableArray = []//章节数组
    private var isFinalChapterNetwork = false//是否是最后一页章节
    private var historyPage = 0//历史第几页
    var db: FMDatabase?

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
//        self.navigationController?.hidesBarsOnSwipe = true
        self.navigationController?.hidesBarsOnTap = true
        UIApplication.sharedApplication().setStatusBarHidden(true, withAnimation: .Fade)
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW,
            Int64(0.8 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) {
                self.navigationController?.setNavigationBarHidden(true, animated: true)
                
        }
        
    }
    
    override func viewWillDisappear(animated: Bool) {
//        self.navigationController?.hidesBarsOnSwipe = false
        self.navigationController?.hidesBarsOnTap = false
        UIApplication.sharedApplication().setStatusBarHidden(false, withAnimation: .Slide)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.translucent = false
        self.collectionView!.registerClass(ManHuaImageCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        self.collectionView?.pagingEnabled = true
        db = FMDatabase(path: SQliteFILEURL.path)
        self.openDB()
        self.openHistoryDB()
        
        self.getImageUrlNetwork()
        
        // Do any additional setup after loading the view.
    }
    
//MARK: - OpenDB
    func openDB() {
        if !db!.open() {
            print("不能打开database")
            return
        }
        
        //查询
        do {
            let rs = try db?.executeQuery("select * from \(CHAPTER_TABLE) where comicName = ?", values: [bookModel!.name!])
            while rs!.next() {
                let chapter = ChapterDTOModel(rs: rs!)
                self.chapterArray.addObject(chapter)
            }
        }catch let error as NSError {
            print("failed:\(error.localizedDescription)")
        }
        
        db?.close()
        
    }
    
    //查询有没有历史记录
    func openHistoryDB() {
        if !db!.open() {
            print("不能打开database")
            return
        }
        //创建表
        do {
            try db!.executeUpdate("create table \(HISTORY_TABLE)(name text, type text, area text, des text, finish integer, lastUpdate text, coverImg text, chapterIndex integer, pageIndex integer, chapterName text)", values: nil)
        } catch let error as NSError {
            print("failed:\(error.localizedDescription)")
        }
        
        do {
            let rs = try db?.executeQuery("select * from \(HISTORY_TABLE) where name = ?", values: [bookModel!.name!])
            if !rs!.next() {
                //如果没有数据就创建一个
                do {
                    let chapter = self.chapterArray[chapterIndex!] as! ChapterDTOModel;
                    try db!.executeUpdate("insert into \(HISTORY_TABLE) (name, type, area, des, finish, lastUpdate, coverImg, chapterIndex, pageIndex, chapterName) values (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)", values: [bookModel!.name!, bookModel!.type!, bookModel!.area!, bookModel!.des!, bookModel!.finish!, bookModel!.lastUpdate!, bookModel!.coverImg!, chapterIndex!, 0, chapter.name!])
                } catch let error as NSError {
                    print("failed:\(error.localizedDescription)")
                }
            }else {
                //如果有历史记录 直接跳到历史记录那一页
        
                historyPage = rs!.longForColumn("pageIndex")
            }
        }catch let error as NSError {
            print("failed:\(error.localizedDescription)")
        }
    }
    
//MARK: - Network
    func getImageUrlNetwork() {
        let chapterModel = self.chapterArray[chapterIndex!] as! ChapterDTOModel
        ChapterContentModel.chapterContentNetwork(chapterModel.comicName!, id: chapterModel.id!) { (response) in
            self.dataArray = (response.value?.imageList)!
            self.collectionView!.reloadData()
            if self.historyPage != 0 {
                self.collectionView?.scrollToItemAtIndexPath(NSIndexPath.init(forRow: self.historyPage
                    , inSection: 0), atScrollPosition: .Left, animated: false)
//                self.historyPage = 0
            }else {
                self.collectionView?.scrollToItemAtIndexPath(NSIndexPath.init(forRow: 0, inSection: 0), atScrollPosition: .Left, animated: false)
            }
        }
    }
    
    //没有章节时获取下面章节
    func bookChapterListNetwork() {
        
        if !db!.open() {
            print("不能打开database")
            return
        }
        //创建表
        do {
            try db!.executeUpdate("create table \(CHAPTER_TABLE)(comicName text, name text, id integer, chapterIndex integer)", values: nil)
        } catch let error as NSError {
            print("failed:\(error.localizedDescription)")
        }
        ChapterListmodel.chapterListNetwork((self.bookModel?.name)!, skip: chapterArray.count) { (response) in
            for chapter in response.value!.chapterList {
                do {
                    try self.db!.executeUpdate("insert into \(CHAPTER_TABLE) (comicName, name, id, chapterIndex) values (?, ?, ?, ?)", values: [chapter.comicName!,chapter.name!,chapter.id!,self.dataArray.count])
                } catch let error as NSError {
                    print("failed:\(error.localizedDescription)")
                }
                self.chapterArray.addObject(chapter)
            }
            
            self.db?.close()
            //少于20条说明没有数据了，显示没有数据
            if response.value?.chapterList.count < 20 {
                self.isFinalChapterNetwork = true
            }
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return dataArray.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as!ManHuaImageCollectionViewCell
        let model = dataArray[indexPath.row] as! ChapterImageModel
        cell.bind(model, currentNum: indexPath.row + 1, totalNum: dataArray.count)
//        let title = NSString.init(format: "%d/%d", indexPath.row + 1, dataArray.count) as String
//        self.navigationItem.title = title
        // Configure the cell
    
        return cell
    }

    //更新页号
    override func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        let row = self.collectionView?.indexPathForItemAtPoint(CGPointMake(scrollView.contentOffset.x, 0))!.row
        let title = NSString.init(format: "%d/%d", row! + 1, dataArray.count) as String
        self.navigationItem.title = title
        //修改数据库
        if !db!.open() {
            print("不能打开database")
            return
        }

        do {
            try db!.executeUpdate("UPDATE \(HISTORY_TABLE) SET chapterIndex = ? , pageIndex = ? WHERE name = ?", values: [chapterIndex!, row!, bookModel!.name!])
        } catch let error as NSError {
            print("failed:\(error.localizedDescription)")
        }
        db?.close()
        
    }

}
