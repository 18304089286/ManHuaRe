//
//  ManHuaRe+Config.swift
//  ManHuaRe
//
//  Created by 孙宇 on 16/3/29.
//  Copyright © 2016年 孙宇. All rights reserved.
//

import UIKit

let SCREEN_WIDTH = UIScreen.mainScreen().bounds.size.width;
let SCREEN_HEIGHT = UIScreen.mainScreen().bounds.size.height;
let WIDTH_5S:CGFloat = 320.0;
let HEIGHT_5S:CGFloat = 568.0;

let COMMON_GRAY_COLOR:UIColor = getColor("f5f5f5")
let COMMON_BGCOLOR:UIColor = getColor("faf9f9")
let COMMON_BLACK_TEXTCOLOR:UIColor = getColor("7e7d7d")
let COMMON_GRAY_TEXTCOLOR:UIColor = getColor("b6b6b6")


//用户代理，使用这个切换是获取 m站点 还是www站数据
let USER_AGENT = "Mozilla/5.0 (iPhone; CPU iPhone OS 8_0 like Mac OS X) AppleWebKit/600.1.3 (KHTML, like Gecko) Version/8.0 Mobile/12A4345d Safari/600.1.4";

let MOBILE_CLIENT_HEADERS = ["user-agent":USER_AGENT]


//颜色
func getColor(hexColor:NSString) -> UIColor{
    var red:CUnsignedInt = 0
    var green:CUnsignedInt = 0
    var blue:CUnsignedInt = 0
    var range:NSRange = NSRange.init()
    range.length = 2
    
    range.location = 0
    NSScanner(string: hexColor.substringWithRange(range)).scanHexInt(&red)
    range.location = 2
    NSScanner(string: hexColor.substringWithRange(range)).scanHexInt(&green)
    range.location = 4
    NSScanner(string: hexColor.substringWithRange(range)).scanHexInt(&blue)
    
    return UIColor(red: CGFloat(red)/255.0, green: CGFloat(green)/255.0, blue: CGFloat( blue)/255.0, alpha: 1)
}

let MANHUA_URL = "http://japi.juhe.cn/comic/"
let MANHUA_KEY = "4768e5b05857995235da0432bc41b53d"

//数据库路径
private let documents = try! NSFileManager.defaultManager().URLForDirectory(.DocumentDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: false)
let SQliteFILEURL = documents.URLByAppendingPathComponent("manHuaSqlite.sqlite")
let COLLECTION_TABLE_NAME = "collectionTable"
let CHAPTER_TABLE = "chapterTable"
let HISTORY_TABLE = "historyTable"
var screen_light : CGFloat = UIScreen.mainScreen().brightness
var app_light : CGFloat = UIScreen.mainScreen().brightness

