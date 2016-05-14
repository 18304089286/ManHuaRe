//
//  BookListModel.swift
//  ManHuaRe
//
//  Created by 孙宇 on 16/4/12.
//  Copyright © 2016年 孙宇. All rights reserved.
//

import UIKit
import Alamofire
import FMDB

class BookListModel: NSObject {
    var total:Int?
    var limit:Int?
    var bookList:Array<BookList> = []
    
    init(response:NSDictionary) {
        self.total = response.objectForKey("total")?.integerValue
        self.limit = response.objectForKey("limit")?.integerValue
        let bookListArray:NSArray = response.objectForKey("bookList") as! NSArray
        for book in bookListArray {
            self.bookList.append(BookList(bookDic:book as! NSDictionary))
        }
    }
    
    /*
     *name:漫画名称
     *type:漫画类别
     *skip:跳过的数量
     *finish:0代表未完结,1代表已完结,默认所有
     */
    class func bookListNetwork(parametersDic:Dictionary<String,AnyObject>, completionHandler: ManHuaValueResponse<BookListModel> -> Void) -> Void {
        let USERMODEL_BOOK = "com.manHuaRe.book"
        let userDefault = NSUserDefaults.standardUserDefaults()
        if userDefault.objectForKey(USERMODEL_BOOK) == nil {
            let url = MANHUA_URL + "book"
            var parameters = parametersDic
            parameters["key"] = MANHUA_KEY
//            if (name != nil) {
//                parameters["name"] = name
//            }
//            if (type != nil) {
//                parameters["type"] = type
//            }
//            if (skip != nil) {
//                parameters["skip"] = skip
//            }
//            if (finish != nil) {
//                parameters["finish"] = finish
//            }
            Alamofire.request(.POST, url, parameters: parameters, encoding: .URL, headers: nil).responseJSON() { response in
                userDefault.setObject(response.result.value, forKey: USERMODEL_BOOK)
                //打印一下
                do {
                    let jsonData = try NSJSONSerialization.dataWithJSONObject(response.result.value!, options: .PrettyPrinted)
                    let jsonStr:String = String.init(data: jsonData, encoding: NSUTF8StringEncoding)!
                    print(jsonStr)
                }catch {
                }
                //转Model
                let model = BookListModel(response: (response.result.value)?.objectForKey("result") as! NSDictionary )
                completionHandler(ManHuaValueResponse.init(value: model, success: response.result.isSuccess, message: response.result.value?.objectForKey("reason") as? String))
            }
        }else {
            //打印一下
            do {
                let jsonData = try NSJSONSerialization.dataWithJSONObject(userDefault.objectForKey(USERMODEL_BOOK)?.objectForKey("result") as! NSDictionary, options: .PrettyPrinted)
                let jsonStr:String = String.init(data: jsonData, encoding: NSUTF8StringEncoding)!
                print(jsonStr)
            }catch {
            }
            let model = BookListModel(response: userDefault.objectForKey(USERMODEL_BOOK)?.objectForKey("result") as! NSDictionary)
            completionHandler(ManHuaValueResponse.init(value: model, success: true, message: "Success"))
        }
    }
}

class BookList:NSObject {
    
    var name:String?//漫画名称
    var type:String?//漫画类型
    var area:String?//国漫
    var des:String?//介绍
    var finish:Bool?//是否更新完
    var lastUpdate:String?//最新更新时间20150508
    var coverImg:String? //封面
    var historyChapterName:String?//历史记录章节名
    
    init(bookDic:NSDictionary) {
        self.name = bookDic.objectForKey("name") as? String
        self.type = bookDic.objectForKey("type") as? String
        self.area = bookDic.objectForKey("area") as? String
        self.des = bookDic.objectForKey("des") as? String
        self.finish = bookDic.objectForKey("finish")?.boolValue
        let updateTime = bookDic.objectForKey("lastUpdate")?.integerValue
        //时间换算
        let dateFormatter:NSDateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        let dateStr:String = String.init(format: "%d", updateTime!)
        let date = dateFormatter.dateFromString(dateStr)
        dateFormatter.dateFormat = "yyyy.MM.dd"
        self.lastUpdate = dateFormatter.stringFromDate((date)!)
        
        self.coverImg = bookDic.objectForKey("coverImg") as? String
    }
    
    init(rs:FMResultSet) {
        self.name = rs.stringForColumn("name")
        self.type = rs.stringForColumn("type")
        self.area = rs.stringForColumn("area")
        self.des = rs.stringForColumn("des")
        self.finish = rs.boolForColumn("finish")
        self.lastUpdate = rs.stringForColumn("lastUpdate")
        self.coverImg = rs.stringForColumn("coverImg")
        self.historyChapterName = rs.stringForColumn("chapterName")
    }
}
