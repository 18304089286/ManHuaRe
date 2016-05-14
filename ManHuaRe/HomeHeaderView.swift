//
//  HomeHeaderView.swift
//  ManHuaRe
//
//  Created by 关作印 on 16/4/1.
//  Copyright © 2016年 孙宇. All rights reserved.
//

import UIKit


class HomeHeaderView: UICollectionReusableView {
    private var titleImageView : UIImageView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .blueColor()
        //标题图片
        self.titleImageView = UIImageView()
        self.addSubview(self.titleImageView!)
        self.titleImageView!.snp_makeConstraints (closure: { (make) -> Void in
            make.top.equalTo(self)
            make.bottom.equalTo(self)
            make.left.equalTo(self).offset(10)
            make.size.lessThanOrEqualTo(CGSizeMake(30, 30))
        })
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
