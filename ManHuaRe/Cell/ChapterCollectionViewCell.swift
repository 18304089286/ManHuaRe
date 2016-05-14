//
//  ChapterCollectionViewCell.swift
//  ManHuaRe
//
//  Created by 孙宇 on 16/4/24.
//  Copyright © 2016年 孙宇. All rights reserved.
//

import UIKit

class ChapterCollectionViewCell: UICollectionViewCell {
    private var titleLabel: UILabel?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        titleLabel = UILabel()
        titleLabel?.layer.borderColor = getColor("efeeee").CGColor
        titleLabel?.layer.borderWidth = 1
        titleLabel?.backgroundColor = .whiteColor()
        titleLabel?.textColor = COMMON_BLACK_TEXTCOLOR
        titleLabel?.font = UIFont.systemFontOfSize(12)
        titleLabel?.textAlignment = .Center
        self.contentView.addSubview(titleLabel!)
        titleLabel!.snp_makeConstraints { (make) in
            make.top.left.bottom.right.equalTo(self.contentView)
        }
    }
    
    func bind(model: ChapterDTOModel?) {
        if let name = model?.name {
            titleLabel?.text = name
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
