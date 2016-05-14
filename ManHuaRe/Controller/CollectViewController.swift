//
//  CollectViewController.swift
//  ManHuaRe
//
//  Created by 孙宇 on 16/4/26.
//  Copyright © 2016年 孙宇. All rights reserved.
//

import UIKit
import FMDB

class CollectViewController: BaseViewController ,UICollectionViewDelegate, UICollectionViewDataSource{
    
    var collectionView :UICollectionView?
    private var dataArray:NSMutableArray = []
    var db: FMDatabase?
    
//MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "收藏夹"
        self.makeCollectionViewUI()
        //加载数据库DB
        db = FMDatabase(path: SQliteFILEURL.path)
        self.makeDBData()
    }

    func makeDBData() {
        if !db!.open() {
            print("不能打开database")
            return
        }
        do {
            let rs = try db?.executeQuery("select * from \(COLLECTION_TABLE_NAME)", values: nil)
            while rs!.next() {
                let book = BookList(rs: rs!)
                dataArray.addObject(book)
            }
            
        }catch let error as NSError {
            print("failed:\(error.localizedDescription)")
        }
        self.collectionView?.reloadData()
        db?.close()
    }
    
//MARK: - UI
    
    func makeCollectionViewUI() {
        //间隔
        let lineSpace = (SCREEN_WIDTH - 90 * 3) / 4.0
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSizeMake(90, 160)
        flowLayout.minimumLineSpacing = lineSpace
        flowLayout.minimumInteritemSpacing = lineSpace
        flowLayout.sectionInset = UIEdgeInsetsMake(lineSpace, lineSpace, lineSpace, lineSpace)
        
        collectionView = UICollectionView(frame: CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT), collectionViewLayout: flowLayout)
        collectionView?.backgroundColor = .clearColor()
        collectionView?.delegate = self
        collectionView?.dataSource = self
        collectionView?.registerClass(CollectCollectionViewCell.self, forCellWithReuseIdentifier: NSStringFromClass(CollectCollectionViewCell.self))
        
        self.view.addSubview(collectionView!)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//MARK: - UICollectionViewDelegate, UICollectionViewDataSource
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView .dequeueReusableCellWithReuseIdentifier(NSStringFromClass(CollectCollectionViewCell.self), forIndexPath: indexPath) as! CollectCollectionViewCell
        cell.bind(self.dataArray[indexPath.row] as! BookList)
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let model = self.dataArray[indexPath.row] as! BookList
        let manHuaDetailVC = ManHuaDetailViewController()
        manHuaDetailVC.bookModel = model
        self.navigationController?.pushViewController(manHuaDetailVC, animated: true)
    }

}
