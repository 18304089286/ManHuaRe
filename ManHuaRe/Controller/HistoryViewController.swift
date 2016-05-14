//
//  HistoryViewController.swift
//  ManHuaRe
//
//  Created by 孙宇 on 16/4/26.
//  Copyright © 2016年 孙宇. All rights reserved.
//

import UIKit
import FMDB

class HistoryViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource,HistoryTableViewCellDelegate {

    let tableView: UITableView = UITableView()
    var db: FMDatabase?
    private var dataArray:NSMutableArray = []
    
//MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "历史记录"
        self.makeTableViewUI()
        self.openDB()
        
    }
    
//MARK: - UI
    func makeTableViewUI() {
        tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
        tableView.backgroundColor = .clearColor()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 93
        tableView.separatorStyle = .None
        self.view.addSubview(tableView)
    }
//MARK: - openDB
    func openDB() {
        db = FMDatabase(path: SQliteFILEURL.path)
        if !db!.open() {
            print("不能打开database")
            return
        }
        //查询历史记录
        do {
            let rs = try db?.executeQuery("select * from \(HISTORY_TABLE)", values: nil)
            while rs!.next() {
                let book = BookList(rs: rs!)
                self.dataArray.addObject(book)
            }
            self.tableView.reloadData()
        }catch let error as NSError {
            print("failed:\(error.localizedDescription)")
        }
    }
    

//MARK: - UITableViewDelegate, UITableViewDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier(NSStringFromClass(HistoryTableViewCell.self)) as? HistoryTableViewCell
        if cell == nil {
            cell = HistoryTableViewCell(style: .Default, reuseIdentifier: NSStringFromClass(HistoryTableViewCell.self)) 
            cell!.bind(dataArray[indexPath.row] as! BookList)
            cell?.delegate = self
        }
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let model = dataArray[indexPath.row]
        let manHuaDetailVC = ManHuaDetailViewController()
        manHuaDetailVC.bookModel = model as? BookList
        self.navigationController?.pushViewController(manHuaDetailVC, animated: true)
    }

//MARK: - HistoryTableViewCellDelegate
    func historyTableViewCellDelegateWithContinueLook(cell: HistoryTableViewCell) {
        print("续读")
        let indexPath = self.tableView.indexPathForCell(cell)
        let model = dataArray[indexPath!.row]
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT)
        flowLayout.scrollDirection = .Horizontal
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        
        let reviewVC = ReviewCollectionViewController(collectionViewLayout: flowLayout)
        reviewVC.bookModel = model as? BookList
        reviewVC.chapterIndex = indexPath?.row
        self.navigationController?.pushViewController(reviewVC, animated: true)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
