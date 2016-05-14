//
//  ManHuaImageCollectionViewCell.swift
//  ManHuaRe
//
//  Created by 孙宇 on 16/4/24.
//  Copyright © 2016年 孙宇. All rights reserved.
//

import UIKit

class ManHuaImageCollectionViewCell: UICollectionViewCell {

    private var countLabel: UILabel?//第几张Label
    private var contentImage: UIImageView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        countLabel = UILabel()
        countLabel?.textColor = .whiteColor()
        countLabel?.font = UIFont.init(name: "AmericanTypewriter-Bold", size: 60)
        countLabel?.text = "1/20"
        countLabel?.alpha = 0.5
        self.contentView.addSubview(countLabel!)
        countLabel?.snp_makeConstraints(closure: { (make) in
            make.center.equalTo(self.contentView)
            make.height.equalTo(60)
        })
        
        contentImage = UIImageView()
        self.contentView.addSubview(contentImage!)
        contentImage?.snp_makeConstraints(closure: { (make) in
            make.left.right.top.bottom.equalTo(self.contentView)
        })
        
    }
    
    func bind(model: ChapterImageModel ,currentNum:Int ,totalNum:Int) {
        if let imageUrlStr = model.imageUrl {
            contentImage?.kf_setImageWithURL(NSURL(string: imageUrlStr)!)
        }
        countLabel?.text = NSString.init(format: "%d/%d", currentNum,totalNum) as String
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
