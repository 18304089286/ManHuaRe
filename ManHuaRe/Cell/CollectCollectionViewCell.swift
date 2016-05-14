//
//  CollectCollectionViewCell.swift
//  ManHuaRe
//
//  Created by 孙宇 on 16/4/26.
//  Copyright © 2016年 孙宇. All rights reserved.
//

import UIKit

class CollectCollectionViewCell: UICollectionViewCell {
    
    private var coverImage:UIImageView?
    private var titleLabel: UILabel?
    private var updateLabel: UILabel?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.backgroundColor = .whiteColor()
        
        coverImage = UIImageView()
        self.contentView.addSubview(coverImage!)
        coverImage?.snp_makeConstraints(closure: { (make) in
            make.left.top.right.equalTo(self.contentView)
            make.height.equalTo(120)
        })
        
        titleLabel = UILabel()
        titleLabel?.font = UIFont.boldSystemFontOfSize(13.0)
        titleLabel?.textColor = getColor("979797")
        titleLabel?.textAlignment = .Center
        self.contentView.addSubview(titleLabel!)
        titleLabel?.snp_makeConstraints(closure: { (make) in
            make.height.equalTo(13)
            make.left.right.equalTo(self.contentView)
            make.top.equalTo(coverImage!.snp_bottom).offset(5)
        })
        
        updateLabel = UILabel()
        updateLabel?.font = UIFont.systemFontOfSize(10)
        updateLabel?.textColor = getColor("e06b1e")
        updateLabel?.textAlignment = .Center
        self.contentView.addSubview(updateLabel!)
        updateLabel?.snp_makeConstraints(closure: { (make) in
            make.top.equalTo(titleLabel!.snp_bottom).offset(5)
            make.height.equalTo(10)
            make.left.right.equalTo(titleLabel!)
        })
        
    }
    
    func bind(model: BookList) {
        if let coverImg =  model.coverImg {
            coverImage?.kf_setImageWithURL(NSURL.init(string: coverImg)!, placeholderImage: nil)
        }
        if let title = model.name {
            titleLabel?.text = title
        }
        if let updateTime = model.lastUpdate {
            updateLabel?.text = "更新:" + updateTime
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
