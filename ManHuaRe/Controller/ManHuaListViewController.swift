//
//  ManHuaListViewController.swift
//  ManHuaRe
//
//  Created by 孙宇 on 16/4/14.
//  Copyright © 2016年 孙宇. All rights reserved.
//
/// 漫画列表
import UIKit

class ManHuaListViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource {
    let tableView:UITableView = UITableView()
    var dataArray = []//数据源
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.makeTableView()
        self.bookListNetwork()
    }
//连接网络
    func bookListNetwork() {
        BookListModel.bookListNetwork(["name":"斗破苍穹"]) { (response) in
            if response.success {
                self.dataArray = (response.value?.bookList)!
                self.tableView.reloadData()
            }
        }
    }
//创建TableView
    func makeTableView() {
        self.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.backgroundColor = getColor("ededed")
        self.tableView.rowHeight = 95
        self.tableView.separatorStyle = .None
        self.view.addSubview(self.tableView)
    }
    
//MARK: - UITableViewDelegate,UITableViewDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier(NSStringFromClass(ManHuaListTableViewCell.self)) as? ManHuaListTableViewCell
        
        if cell == nil {
            cell = ManHuaListTableViewCell(style: .Default, reuseIdentifier: NSStringFromClass(ManHuaListTableViewCell.self))
        }
        cell!.bind(self.dataArray[indexPath.row] as! BookList)
        
        return cell!;
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let manHuaDetailVC = ManHuaDetailViewController()
        manHuaDetailVC.bookModel = self.dataArray[indexPath.row] as? BookList
        self.navigationController?.pushViewController(manHuaDetailVC, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
