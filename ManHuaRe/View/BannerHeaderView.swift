//
//  BannerHeaderView.swift
//  ManHuaRe
//
//  Created by 孙宇 on 16/3/29.
//  Copyright © 2016年 孙宇. All rights reserved.
//

import UIKit
import SnapKit
import SDCycleScrollView


class BannerHeaderView: UICollectionReusableView {

    private var bannerView : SDCycleScrollView?

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .cyanColor()
        //轮播图
        self.bannerView = SDCycleScrollView()
        self.bannerView!.pageControlStyle = SDCycleScrollViewPageContolStyleAnimated
        self.addSubview(self.bannerView!)

        self.bannerView!.snp_makeConstraints(closure: { (make) -> Void in
            make.top.equalTo(self)
            make.bottom.equalTo(self).offset(-25)
            make.left.right.equalTo(self)
        })
        
        let sectionHeaderView = UIView()
        sectionHeaderView
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
