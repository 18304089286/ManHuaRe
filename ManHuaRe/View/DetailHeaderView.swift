//
//  DetailCollectionReusableView.swift
//  ManHuaRe
//
//  Created by 孙宇 on 16/4/15.
//  Copyright © 2016年 孙宇. All rights reserved.
//

import UIKit
import FXBlurView
import FMDB

class DetailHeaderView: UIView {
    var superVC: ManHuaDetailViewController?//获取VC，好调用返回事件
    
    private var topBackgroudImageView: UIImageView?
    private var blurView: FXBlurView?
    private var coverImageView: UIImageView?
    private var nameLabel: UILabel?
    private var typeLabel: UILabel?
    private var areaLabel: UILabel?
    private var updateLabel: UILabel?
    private var readBtn: UIButton?
    private var rightCollectionBtn: UIButton?
    private var db:FMDatabase?
    private var model:BookList?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = COMMON_GRAY_COLOR
        
        self.topBackgroudImageView = UIImageView()
        self.addSubview(self.topBackgroudImageView!)
        self.topBackgroudImageView?.snp_makeConstraints(closure: { (make) in
            make.top.equalTo(self).offset(-300)
            make.left.right.equalTo(self)
            make.bottom.equalTo(self)
        })
        
        self.blurView = FXBlurView()
        self.blurView?.underlyingView = self.topBackgroudImageView!
        self.blurView?.dynamic = false
        self.blurView?.tintColor = .blackColor()
        self.topBackgroudImageView?.addSubview(blurView!)
        self.blurView?.snp_makeConstraints(closure: { (make) in
            make.top.left.right.bottom.equalTo(self.topBackgroudImageView!)
        })
        
        self.coverImageView = UIImageView()
        self.coverImageView?.layer.shadowOffset = CGSizeMake(4, 4)//添加阴影效果
        self.coverImageView?.layer.shadowColor = UIColor.blackColor().CGColor
        self.coverImageView?.layer.shadowRadius = 4
        self.coverImageView?.layer.shadowOpacity = 0.8
        self.topBackgroudImageView?.addSubview(self.coverImageView!)
        self.coverImageView!.snp_makeConstraints { (make) in
            make.bottom.equalTo(self.topBackgroudImageView!).offset(-10)
            make.width.equalTo(120)
            make.height.equalTo(150)
            make.left.equalTo(self.topBackgroudImageView!).offset(15)
        }
        
        //返回按钮
        let leftBtn = UIButton(type: .Custom)
        leftBtn.setImage(UIImage(named: "leftArrow"), forState: .Normal)
        leftBtn.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5)
        leftBtn.addTarget(self.superVC, action: #selector(ManHuaDetailViewController.leftBtnClick), forControlEvents: .TouchUpInside)
        self.addSubview(leftBtn)
        leftBtn.snp_makeConstraints { (make) in
            make.top.equalTo(self).offset(25)
            make.left.equalTo(self).offset(10)
            make.width.height.equalTo(30)
        }
        
        //收藏按钮
        rightCollectionBtn = UIButton(type: .Custom)
        rightCollectionBtn?.setImage(UIImage(named: "collection_unselect"), forState: .Normal)
        rightCollectionBtn?.setImage(UIImage(named: "collection_select"), forState: .Selected)
        rightCollectionBtn?.addTarget(self, action: #selector(DetailHeaderView.rightCollectionBtnClick(_:)), forControlEvents: .TouchUpInside)
        self.addSubview(rightCollectionBtn!)
        rightCollectionBtn?.snp_makeConstraints(closure: { (make) in
            make.top.equalTo(leftBtn)
            make.right.equalTo(self).offset(-10)
            make.width.height.equalTo(30)
        })

        
        //名字
        nameLabel = UILabel()
        nameLabel?.font = UIFont(name: "Verdana-Bold", size: 14)
        nameLabel?.textColor = .whiteColor()
        self.topBackgroudImageView!.addSubview(nameLabel!)
        nameLabel?.snp_makeConstraints(closure: { (make) in
            make.top.equalTo(self.coverImageView!).offset(10)
            make.height.equalTo(14)
            make.left.equalTo(self.coverImageView!.snp_right).offset(10)
        })
        
        self.typeLabel = UILabel()
        self.typeLabel!.font = UIFont.systemFontOfSize(12)
        self.typeLabel!.textColor = .whiteColor()
        self.topBackgroudImageView!.addSubview(self.typeLabel!)
        self.typeLabel!.snp_makeConstraints { (make) in
            make.left.equalTo(self.nameLabel!)
            make.top.equalTo(self.nameLabel!.snp_bottom).offset(10)
            make.height.equalTo(12)
        }
        
        self.areaLabel = UILabel()
        self.areaLabel!.font = UIFont.systemFontOfSize(12)
        self.areaLabel!.textColor = .whiteColor()
        self.topBackgroudImageView!.addSubview(self.areaLabel!)
        self.areaLabel!.snp_makeConstraints { (make) in
            make.left.equalTo(self.typeLabel!)
            make.top.equalTo(self.typeLabel!.snp_bottom).offset(10)
            make.height.equalTo(12)
        }
        
        updateLabel = UILabel()
        updateLabel?.font = UIFont.systemFontOfSize(12)
        updateLabel!.textColor = getColor("CD2626")
        self.topBackgroudImageView?.addSubview(updateLabel!)
        updateLabel!.snp_makeConstraints { (make) in
            make.left.equalTo(areaLabel!)
            make.top.equalTo(areaLabel!.snp_bottom).offset(10)
            make.height.equalTo(12)
        }
        
        readBtn = UIButton(type: .Custom)
        readBtn?.backgroundColor = getColor("87CEEB")
        readBtn?.setImage(UIImage(named: "read_btn"), forState: .Normal)
        readBtn?.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10)
        readBtn?.setTitle("开始阅读", forState: .Normal)
        self.topBackgroudImageView?.addSubview(readBtn!)
        
        readBtn?.snp_makeConstraints(closure: { (make) in
            make.top.equalTo(updateLabel!.snp_bottom).offset(16)
            make.bottom.equalTo(self.coverImageView!).offset(-8)
            make.left.equalTo(updateLabel!).offset(10)
            make.right.equalTo(self.topBackgroudImageView!).offset(-30)
        })
        
        //加载数据库DB
        db = FMDatabase(path: SQliteFILEURL.path)
    }
    
    func bind(model:BookList) {
        self.model = model
        if let coverImg = model.coverImg {
            self.topBackgroudImageView?.kf_setImageWithURL(NSURL.init(string: coverImg)!, placeholderImage: nil)
            self.coverImageView?.kf_setImageWithURL(NSURL.init(string: coverImg)!, placeholderImage: nil)
        }
        if let name = model.name {
            nameLabel?.text = name
        }
        
        if let type = model.type {
            self.typeLabel?.text = "类型：" + type
        }
        
        if let area = model.area {
            self.areaLabel?.text = area
        }
        
        if let lastUpdate = model.lastUpdate {
            let textStr = "最近更新：" + lastUpdate
            let attributedStr = NSMutableAttributedString(string: textStr)
            attributedStr.addAttribute(NSForegroundColorAttributeName, value: UIColor.whiteColor(), range: NSRange.init(location: 0, length: 5))
            self.updateLabel?.attributedText = attributedStr
        }
    
        if !db!.open() {
            print("不能打开database")
            return
        }
        do {
            let rs = try db?.executeQuery("select name from \(COLLECTION_TABLE_NAME) where name = ?", values: [model.name!])
            while rs!.next() {
                let name = rs?.stringForColumn("name")
                if name == model.name {
                    rightCollectionBtn?.selected = true
                }
            }
        }catch let error as NSError {
            print("failed:\(error.localizedDescription)")
        }
        
        db?.close()
    }
    
    //收藏方法
    func rightCollectionBtnClick(sender:UIButton) {
        if !db!.open() {
            print("不能打开database")
            return
        }
        //创建表
        do {
            try db!.executeUpdate("create table \(COLLECTION_TABLE_NAME)(name text, type text, area text, des text, finish integer, lastUpdate text, coverImg text)", values: nil)
        } catch let error as NSError {
            print("failed:\(error.localizedDescription)")
        }
        
        if !sender.selected {//收藏
            //收藏添加数据
            do {
                try db!.executeUpdate("insert into \(COLLECTION_TABLE_NAME) (name, type, area, des, finish, lastUpdate, coverImg) values (?, ?, ?, ?, ?, ?, ?)", values: [model!.name!, model!.type!, model!.area!, model!.des!, model!.finish!, model!.lastUpdate!, model!.coverImg!])
            } catch let error as NSError {
                print("failed:\(error.localizedDescription)")
            }
        }else {//取消收藏
            do {
                try db!.executeUpdate("delete from \(COLLECTION_TABLE_NAME) where name = ?", values: [model!.name!])
            }catch let error as NSError {
                print("failed:\(error.localizedDescription)")
            }
        }
        sender.selected = !sender.selected
        db?.close()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
