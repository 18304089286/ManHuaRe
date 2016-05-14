//
//  HomeModel.swift
//  ManHuaRe
//
//  Created by 孙宇 on 16/3/30.
//  Copyright © 2016年 孙宇. All rights reserved.
//

import UIKit
import Alamofire
import Ji

class HomeModel: NSObject {
  
    /**
     获取首页数据
     
     - parameter completionHandler:
     */
    class func getHomeNetwork(completionHandler: ManHuaValueResponse<NSMutableDictionary> -> Void) -> Void {
        let url = MANHUA_URL
    
        Alamofire.request(.GET, url, parameters: nil, encoding: .URL, headers: MOBILE_CLIENT_HEADERS).responseJiHtml{ (response) -> Void in
            let homeDataDic:NSMutableDictionary = [:]
            if let jiHtml = response.result.value {
                //获取轮播图数据
                var bannerDataArray:[BannerModel] = []
                if let bannerImgArray = jiHtml.xPath("//body/div[@class='main_visual']/div[@class='main_image']/ul/*") {
                    for bannerImgData in bannerImgArray {
                        let banner = BannerModel(bannerNode: bannerImgData)
                        bannerDataArray.append(banner)
                    }
                    homeDataDic["banner"] = bannerDataArray
                }
                //section类
                if let sectionArray = jiHtml.xPath("//body/div[@class='imgBox']") {
                    var dicSectionArray :Array<HomeSectionModel> = []
                    for sectionNode in sectionArray {
                        let sectionModel = HomeSectionModel(sectionNode: sectionNode)
                        dicSectionArray.append(sectionModel)
                    }
                    homeDataDic["content"] = dicSectionArray
                }
            }
            let t = ManHuaValueResponse(value: homeDataDic, success:response.result.isSuccess)
            completionHandler(t)
        }
        
    }

}

//轮播图类
class BannerModel: NSObject {
    //图片url
    var bannerImgUrl: String?
    //漫画链接，相当于ID
    var bannerDetailId: String?
    
    init(bannerNode:JiNode) {
        super.init()

        self.bannerImgUrl = bannerNode.xPath("./a/img").first?["src"]
        self.bannerDetailId = bannerNode.xPath("./a").first?["href"]
    }
    
}

//分组Model
class HomeSectionModel: NSObject {
    //section名字
    var sectionName: String?
    //名字前的图片地址
    var sectionImgUrl: String?
    //一组漫画Array
    var manHuaArray: Array<HomeRowModel> = []
    
    init(sectionNode:JiNode) {
        super.init()
        
        self.sectionName = sectionNode.xPath("./div[@class='Sub_H2']/span[@class='Title']").first?.content
        self.sectionImgUrl = MANHUA_URL + (sectionNode.xPath("./div[@class='Sub_H2']/span[@class='icon']/img").first?["src"])!
        if let sectionManHuaArray:Array = sectionNode.xPath("./ul/*") {
            for manHua in sectionManHuaArray {
                let rowModel = HomeRowModel(rowNode: manHua)
                self.manHuaArray.append(rowModel)
            }
        }
        
    }
}

//一组里每一个Model
class HomeRowModel: NSObject {
    //漫画图片
    var imgUrl: String?
    //漫画名字
    var manHuaTitle: String?
    //漫画作者
    var manHuaAuthor: String?
    //漫画链接，相当于ID
    var manHuaUrlId: String?
    //专题的名字
    var manHuaTopic: String?
    
    init(rowNode:JiNode) {
        super.init()
        self.imgUrl = rowNode.xPath("./a[@class='ImgA']/img").first?["src"]
        self.manHuaTitle = rowNode.xPath("./a[@class='txtA']").first?.content
        self.manHuaAuthor = rowNode.xPath("./span[@class='info']").first?.content
        self.manHuaUrlId = rowNode.xPath("./a[@class='ImgA']").first?["href"]
        self.manHuaTopic = rowNode.xPath("./a[@class='txtA hei']").first?.content
        
    }
}
