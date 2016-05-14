//
//  ClassSearchModel.swift
//  ManHuaRe
//
//  Created by 孙宇 on 16/4/7.
//  Copyright © 2016年 孙宇. All rights reserved.
//

import UIKit
import Alamofire

class ClassSearchModel: NSObject {
    var result:Array<String> = []
    
    init(response:NSDictionary) {
        self.result = response.objectForKey("result") as! Array
        
    }
    
    
    class func classSearchNetwork(completionHandler: ManHuaValueResponse<ClassSearchModel> -> Void) -> Void {
        let USERMODEL_CATEGORY = "com.manHuaRe.category"
        let userDefault = NSUserDefaults.standardUserDefaults()
        if userDefault.objectForKey(USERMODEL_CATEGORY) == nil {
            let url = MANHUA_URL + "category"
            let parameters = ["key":MANHUA_KEY]
            Alamofire.request(.POST, url, parameters: parameters, encoding: .URL, headers: nil).responseJSON() { response in
                userDefault.setObject(response.result.value, forKey: USERMODEL_CATEGORY)
                //打印一下
                do {
                    let jsonData = try NSJSONSerialization.dataWithJSONObject(response.result.value!, options: .PrettyPrinted)
                    let jsonStr:String = String.init(data: jsonData, encoding: NSUTF8StringEncoding)!
                    print(jsonStr)
                }catch {
                }
                //转Model
                let model = ClassSearchModel(response: response.result.value as! NSDictionary)
                completionHandler(ManHuaValueResponse.init(value: model, success: response.result.isSuccess, message: response.result.value?.objectForKey("reason") as? String))
                
            }
        }else {
            let model = ClassSearchModel(response: userDefault.objectForKey(USERMODEL_CATEGORY) as! NSDictionary)
            completionHandler(ManHuaValueResponse.init(value: model, success: true, message: "Success"))
        }
        
        
    }
}
