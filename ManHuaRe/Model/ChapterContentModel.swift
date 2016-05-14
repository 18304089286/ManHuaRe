//
//  ChapterContentModel.swift
//  ManHuaRe
//
//  Created by 孙宇 on 16/4/13.
//  Copyright © 2016年 孙宇. All rights reserved.
//

import UIKit
import Alamofire

class ChapterContentModel: NSObject {
    var chapterId:Int?
    var comicName:String?
    var imageList:Array<ChapterImageModel> = []
    
    init(result:NSDictionary) {
        self.chapterId = result.objectForKey("chapterId")?.integerValue
        self.comicName = result.objectForKey("comicName") as? String
        let imageListArray = result.objectForKey("imageList") as! NSArray
        for imageDto in imageListArray {
            self.imageList.append(ChapterImageModel(imageDTO: imageDto as! NSDictionary))
        }
    }
    
    class func chapterContentNetwork(comicName:String, id:Int, completionHandler: ManHuaValueResponse<ChapterContentModel> -> Void) -> Void {
        let USERMODEL_CHAPTERCONTENT = "com.manHuaRe.chapterContent"
        let userDefault = NSUserDefaults.standardUserDefaults()
        if userDefault.objectForKey(USERMODEL_CHAPTERCONTENT) == nil {
            let url = MANHUA_URL + "chapterContent"
            let parameters = ["key":MANHUA_KEY,"comicName":comicName,"id":id]
            Alamofire.request(.POST, url, parameters: parameters as? [String : AnyObject], encoding: .URL, headers: nil).responseJSON() { response in
                userDefault.setObject(response.result.value, forKey: USERMODEL_CHAPTERCONTENT)
                //打印一下
                do {
                    let jsonData = try NSJSONSerialization.dataWithJSONObject(response.result.value!, options: .PrettyPrinted)
                    let jsonStr:String = String.init(data: jsonData, encoding: NSUTF8StringEncoding)!
                    print(jsonStr)
                }catch {
                }
                let model = ChapterContentModel(result: response.result.value?.objectForKey("result") as! NSDictionary)
                completionHandler(ManHuaValueResponse.init(value: model, success: response.result.isSuccess, message: response.result.value?.objectForKey("reason") as? String))
            }
        }else {
            let model = ChapterContentModel(result: userDefault.objectForKey(USERMODEL_CHAPTERCONTENT)?.objectForKey("result") as! NSDictionary)
            completionHandler(ManHuaValueResponse.init(value: model, success: true, message: "Success"))
        }
    }
}

class ChapterImageModel: NSObject {
    var id:Int?
    var imageUrl:String?
    
    init(imageDTO:NSDictionary) {
        self.id = imageDTO.objectForKey("id")?.integerValue
        self.imageUrl = imageDTO.objectForKey("imageUrl") as? String
    }
}
