//
//  RecordData.swift
//  SY漫画阅读器A版
//
//  Created by bluemobi on 16/4/14.
//  Copyright © 2016年 bluemobi. All rights reserved.
//

import UIKit

class RecordData: NSObject {
    var totalList:NSMutableArray?
    var resultList:NSMutableArray?
    var searchText:NSString!
    
    
    //构造方法
    override init() {
        resultList = NSMutableArray()
        super.init()
    }
    
    func updateData()->NSMutableArray {
        resultList!.removeAllObjects()
        for str in totalList! {
            if str .hasPrefix(searchText as String) || searchText .isEqualToString("") {
                resultList!.addObject(str)
            }
        }
        return resultList!
    }
   class func getCachesPath(fileName:NSString) -> NSString {
        let path:NSString = "\(NSHomeDirectory())/Library/Caches/"
    
        return path.stringByAppendingPathComponent(fileName as String)
    }
}
