//
//  ChapterListmodel.swift
//  ManHuaRe
//
//  Created by 孙宇 on 16/4/13.
//  Copyright © 2016年 孙宇. All rights reserved.
//

import UIKit
import Alamofire
import FMDB

class ChapterListmodel: NSObject {
    var comicName:String?//漫画名称
    var total:Int?
    var limit:Int?
    var chapterList:Array<ChapterDTOModel> = []
    
    init(result:NSDictionary) {
        self.comicName = result.objectForKey("comicName") as? String
        self.total = result.objectForKey("total")?.integerValue
        self.limit = result.objectForKey("limit")?.integerValue
        let chapterListArray = result.objectForKey("chapterList") as! NSArray
        for chapter in chapterListArray {
            self.chapterList.append(ChapterDTOModel(chapterDic: chapter as! NSDictionary,comicName: self.comicName))
        }
    }
    
    class func chapterListNetwork(comicName:String, skip:Int, completionHandler: ManHuaValueResponse<ChapterListmodel> -> Void) -> Void {
        let USERMODEL_CHAPTER = "com.manHuaRe.chapter"
        let userDefault = NSUserDefaults.standardUserDefaults()
        if userDefault.objectForKey(USERMODEL_CHAPTER) != nil {
            let url = MANHUA_URL + "chapter"
            var parameters:[String:AnyObject] = ["key":MANHUA_KEY,"comicName":comicName]
            if (skip > 0) {
                parameters["skip"] = skip
            }
            Alamofire.request(.POST, url, parameters: parameters, encoding: .URL, headers: nil).responseJSON() { response in
                userDefault.setObject(response.result.value, forKey: USERMODEL_CHAPTER)
                //打印一下
                do {
                    let jsonData = try NSJSONSerialization.dataWithJSONObject(response.result.value!, options: .PrettyPrinted)
                    let jsonStr:String = String.init(data: jsonData, encoding: NSUTF8StringEncoding)!
                    print(jsonStr)
                }catch {
                }
                
                let model = ChapterListmodel(result: response.result.value?.objectForKey("result") as! NSDictionary)
                completionHandler(ManHuaValueResponse.init(value: model, success: response.result.isSuccess, message: response.result.value?.objectForKey("reason") as? String))
            }
            
        }else {
            //打印一下
            do {
                let jsonData = try NSJSONSerialization.dataWithJSONObject(userDefault.objectForKey(USERMODEL_CHAPTER)?.objectForKey("result") as! NSDictionary, options: .PrettyPrinted)
                let jsonStr:String = String.init(data: jsonData, encoding: NSUTF8StringEncoding)!
                print(jsonStr)
            }catch {
            }
            let model = ChapterListmodel(result: userDefault.objectForKey(USERMODEL_CHAPTER)?.objectForKey("result") as! NSDictionary)
            completionHandler(ManHuaValueResponse.init(value: model, success: true, message: "Success"))
        }
    }
}

class ChapterDTOModel: NSObject {
    var name:String?//章节名
    var id:Int?//章节id
    var comicName:String?//书名
    
    init(chapterDic:NSDictionary,comicName:String?) {
        self.name = chapterDic.objectForKey("name") as? String
        self.id = chapterDic.objectForKey("id")?.integerValue
        self.comicName = comicName
    }
    init(rs:FMResultSet) {
        self.name = rs.stringForColumn("name")
        self.id = rs.longForColumn("id")
        self.comicName = rs.stringForColumn("comicName")
    }
}
