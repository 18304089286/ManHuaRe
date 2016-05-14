//
//  ManHuaDetailViewController.swift
//  ManHuaRe
//
//  Created by 孙宇 on 16/4/14.
//  Copyright © 2016年 孙宇. All rights reserved.
//

import UIKit
import FMDB
import MJRefresh

class ManHuaDetailViewController: BaseViewController ,UIScrollViewDelegate, UICollectionViewDelegate,UICollectionViewDataSource{
    var bookModel:BookList?
    private let btn_tag = 500
    private var scrollView: UIScrollView?
    private var detailBtn: UIButton?
    private var menuBtn: UIButton?
    private var detailLabel: UILabel?
    private var collectionView:UICollectionView?
    private var dataArray:NSMutableArray = []
    var db: FMDatabase?
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.navigationItem.title = self.bookModel?.name
        self.makeHeaderUI()
        self.makeScrollViewUI()
        //加载数据库DB
        db = FMDatabase(path: SQliteFILEURL.path)
        self.openDB()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    
//MARK: - Network
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
                self.dataArray.addObject(chapter)
            }
        }catch let error as NSError {
            print("failed:\(error.localizedDescription)")
        }
        self.collectionView?.reloadData()
        db?.close()
        
        if self.dataArray.count == 0 {
            self.bookChapterListNetwork()
        }
    }
    
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
        ChapterListmodel.chapterListNetwork((self.bookModel?.name)!, skip: dataArray.count) { (response) in
            for chapter in response.value!.chapterList {
                do {
                    try self.db!.executeUpdate("insert into \(CHAPTER_TABLE) (comicName, name, id, chapterIndex) values (?, ?, ?, ?)", values: [chapter.comicName!,chapter.name!,chapter.id!,self.dataArray.count])
                } catch let error as NSError {
                    print("failed:\(error.localizedDescription)")
                }
                self.dataArray.addObject(chapter)
            }
            
            self.collectionView?.reloadData()
            
            self.db?.close()
            self.collectionView?.mj_footer.endRefreshing()
            //少于20条说明没有数据了，显示没有数据
            if response.value?.chapterList.count < 20 {
                self.collectionView?.mj_footer.endRefreshingWithNoMoreData()
            }
        }
        
    }
    
//MARK: - UI
    func makeHeaderUI() {
        let rect = CGRectMake(0, 0, SCREEN_WIDTH, 220)
        let headerView = DetailHeaderView(frame: rect)
        headerView.superVC = self
        headerView.bind(self.bookModel!)
        self.view.addSubview(headerView)
    }
    
//底部用ScrollView实现
    func makeScrollViewUI() {
        
        //两个按钮的View
        let btnView = UIView()
        btnView.frame = CGRectMake(0, 220, SCREEN_WIDTH, 40)
        btnView.backgroundColor = .clearColor()
        self.view.addSubview(btnView)
        
        //详情按钮
        detailBtn = UIButton(type: .Custom)
        detailBtn?.backgroundColor = .clearColor()
        detailBtn?.frame = CGRectMake(0, 0, SCREEN_WIDTH / 2.0, btnView.frame.height)
        detailBtn?.setTitle("详情", forState: .Normal)
        detailBtn?.setTitle("- 详情 -", forState: .Selected)
        detailBtn?.setTitleColor(getColor("7e7d7d"), forState: .Normal)
        detailBtn?.setTitleColor(getColor("fcbba2"), forState: .Selected)
        detailBtn?.titleLabel?.font = UIFont.systemFontOfSize(15)
        detailBtn?.tag = btn_tag + 0
        detailBtn?.addTarget(self, action: #selector(ManHuaDetailViewController.titleClick(_:)), forControlEvents: .TouchUpInside)
        btnView.addSubview(detailBtn!)
        
        //目录按钮
        menuBtn = UIButton(type: .Custom)
        menuBtn?.backgroundColor = .clearColor()
        menuBtn?.frame = CGRectMake(SCREEN_WIDTH / 2.0, 0, SCREEN_WIDTH / 2.0, (detailBtn?.frame.height)!)
        menuBtn?.setTitle("目录", forState: .Normal)
        menuBtn?.setTitle("- 目录 -", forState: .Selected)
        menuBtn?.setTitleColor(getColor("7e7d7d"), forState: .Normal)
        menuBtn?.setTitleColor(getColor("fcbba2"), forState: .Selected)
        menuBtn?.titleLabel?.font = UIFont.systemFontOfSize(15)
        menuBtn?.tag = btn_tag + 1
        menuBtn?.selected = true
        menuBtn?.addTarget(self, action: #selector(ManHuaDetailViewController.titleClick(_:)), forControlEvents: .TouchUpInside)
        btnView.addSubview(menuBtn!)
        
        let lineView = UIView()
        lineView.frame = CGRectMake(0, btnView.frame.height - 0.5, SCREEN_WIDTH * 2.0, 0.5)
        lineView.backgroundColor = COMMON_GRAY_COLOR
        btnView.addSubview(lineView)
        
        scrollView = UIScrollView(frame: CGRectMake(0, 260, SCREEN_WIDTH, SCREEN_HEIGHT - 260))
        scrollView?.backgroundColor = .clearColor()
        scrollView?.contentSize = CGSizeMake(SCREEN_WIDTH * 2.0, (scrollView?.frame.height)!)
        scrollView?.contentOffset = CGPointMake(SCREEN_WIDTH, 0)
        scrollView?.pagingEnabled = true
        scrollView?.showsHorizontalScrollIndicator = false
        scrollView?.showsVerticalScrollIndicator = false
        scrollView?.delegate = self
        self.view.addSubview(scrollView!)
        
        //作品介绍
        let introduceLabel = UILabel()
        introduceLabel.frame = CGRectMake(30, 5, SCREEN_WIDTH - 60, 20)
        introduceLabel.font = UIFont.systemFontOfSize(12)
        introduceLabel.textColor = COMMON_GRAY_TEXTCOLOR
        introduceLabel.text = "作品介绍"
        scrollView?.addSubview(introduceLabel)
        
        //介绍正文
        detailLabel = UILabel()
        detailLabel?.textColor = COMMON_BLACK_TEXTCOLOR
        detailLabel?.font = UIFont.systemFontOfSize(13)
        detailLabel?.text = bookModel?.des
        detailLabel?.numberOfLines = 0
        scrollView?.addSubview(detailLabel!)
        detailLabel?.snp_makeConstraints(closure: { (make) in
            make.top.equalTo(introduceLabel.snp_bottom)
            make.left.right.equalTo(introduceLabel)
        })
        
        //章节collectionView
        let flowLayout =  UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSizeMake((SCREEN_WIDTH - 10 - 10 - 15 - 15) / 3.0, 35)
        flowLayout.minimumLineSpacing = 10
        flowLayout.minimumInteritemSpacing = 15
        flowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10)
        collectionView = UICollectionView(frame: CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, scrollView!.frame.height), collectionViewLayout: flowLayout)
        collectionView?.backgroundColor = .clearColor()
        collectionView?.delegate = self
        collectionView?.dataSource = self
        scrollView?.addSubview(collectionView!)
        collectionView?.registerClass(ChapterCollectionViewCell.self, forCellWithReuseIdentifier: NSStringFromClass(ChapterCollectionViewCell.self))
        collectionView?.mj_footer = MJRefreshAutoNormalFooter.init(refreshingBlock: { 
            self.bookChapterListNetwork()
        })
    }
    
//MARK: - Click 
    func leftBtnClick() {
       self.navigationController?.popViewControllerAnimated(true)
    }
    

    
    func titleClick(sender: UIButton)  {
        switch sender.tag - btn_tag {
        case 0://详情按钮
            detailBtn?.selected = true
            menuBtn?.selected = false
            scrollView?.setContentOffset(CGPointMake(0, 0), animated: true)
            
        case 1://目录按钮
            detailBtn?.selected = false
            menuBtn?.selected = true
            scrollView?.setContentOffset(CGPointMake(SCREEN_WIDTH, 0), animated: true)
        default:
            print("noting")
        }
        
    }
    
//MARK: - UICollectionViewDelegate,UICollectionViewDataSource
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArray.count
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(NSStringFromClass(ChapterCollectionViewCell.self), forIndexPath: indexPath) as! ChapterCollectionViewCell
        let model = self.dataArray[indexPath.row] as? ChapterDTOModel
        cell.bind(model)
        return cell
    }

    //跳转
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT)
        flowLayout.scrollDirection = .Horizontal
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        
        let reviewVC = ReviewCollectionViewController(collectionViewLayout: flowLayout)
        reviewVC.chapterIndex = indexPath.row
        reviewVC.bookModel = self.bookModel
        self.navigationController?.pushViewController(reviewVC, animated: true)
    }

//MARK: - UIScrollViewDelegate
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        //实现手动滑scrollview按钮变亮
        if scrollView == self.scrollView{
            if scrollView.contentOffset.x == 0 {
                detailBtn?.selected = true
                menuBtn?.selected = false
            }else {
                detailBtn?.selected = false
                menuBtn?.selected = true
            }
        }
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
