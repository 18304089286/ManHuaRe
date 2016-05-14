//
//  ManHuaListTableViewCell.swift
//  ManHuaRe
//
//  Created by 孙宇 on 16/4/14.
//  Copyright © 2016年 孙宇. All rights reserved.
//

import UIKit
import Kingfisher

class ManHuaListTableViewCell: UITableViewCell {
    var coverImageView: UIImageView?
    var nameLabel: UILabel?
    var finishLabel: UILabel?
    var typeLabel: UILabel?
    var areaLabel: UILabel?
    var updateLabel: UILabel?
    var lineView: UIView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .None
        
        self.coverImageView = UIImageView()
        self.contentView.addSubview(self.coverImageView!)
        self.coverImageView!.snp_makeConstraints { (make) in
            make.top.equalTo(self.contentView).offset(8)
            make.bottom.equalTo(self.contentView).offset(-8)
            make.left.equalTo(self.contentView).offset(12)
            make.width.equalTo(60)
        }
        
        self.nameLabel = UILabel()
        self.nameLabel!.font = UIFont(name: "Verdana-Bold", size: 14)
        self.nameLabel!.textColor = getColor("838383")
        self.contentView.addSubview(self.nameLabel!)
        self.nameLabel!.snp_makeConstraints { (make) in
            make.top.equalTo(self.coverImageView!).offset(7)
            make.left.equalTo(self.coverImageView!.snp_right).offset(10)
            make.height.equalTo(15)
        }
        
        self.finishLabel = UILabel()
        self.finishLabel!.font = UIFont.systemFontOfSize(10)
        self.finishLabel!.textColor = UIColor.whiteColor()
        self.finishLabel!.text = "  未完结  "
        self.finishLabel!.backgroundColor = getColor("3CB371")
        self.finishLabel!.layer.cornerRadius = 7
        self.finishLabel!.layer.masksToBounds = true
        self.contentView.addSubview(self.finishLabel!)
        self.finishLabel!.snp_makeConstraints { (make) in
            make.centerY.equalTo(self.nameLabel!)
            make.left.equalTo(self.nameLabel!.snp_right).offset(5)
            make.height.equalTo(14)
        }
        
        self.typeLabel = UILabel()
        self.typeLabel!.font = UIFont.systemFontOfSize(12)
        self.typeLabel!.textColor = getColor("b6b6b6")
        self.contentView.addSubview(self.typeLabel!)
        self.typeLabel!.snp_makeConstraints { (make) in
            make.left.equalTo(self.nameLabel!)
            make.top.equalTo(self.nameLabel!.snp_bottom).offset(5)
            make.height.equalTo(12)
        }
        
        self.areaLabel = UILabel()
        self.areaLabel!.font = UIFont.systemFontOfSize(12)
        self.areaLabel!.textColor = getColor("b6b6b6")
        self.contentView.addSubview(self.areaLabel!)
        self.areaLabel!.snp_makeConstraints { (make) in
            make.left.equalTo(self.typeLabel!)
            make.top.equalTo(self.typeLabel!.snp_bottom).offset(5)
            make.height.equalTo(12)
        }
        
        self.updateLabel = UILabel()
        self.updateLabel!.font = UIFont.systemFontOfSize(12)
        self.updateLabel!.textColor = getColor("CD2626")
        self.contentView.addSubview(self.updateLabel!)
        self.updateLabel!.snp_makeConstraints { (make) in
            make.left.equalTo(self.areaLabel!)
            make.top.equalTo(self.areaLabel!.snp_bottom).offset(5)
            make.height.equalTo(12)
        }
        
        self.lineView = UIView()
        self.lineView!.backgroundColor = getColor("ededed")
        self.contentView.addSubview(self.lineView!)
        self.lineView!.snp_makeConstraints(closure: { (make) in
            make.left.equalTo(self.updateLabel!)
            make.bottom.equalTo(self.contentView)
            make.height.equalTo(1)
            make.right.equalTo(self.contentView)
        })
    }
    
    //填充数据
    func bind(model: BookList) {
        if let coverImg = model.coverImg {
            self.coverImageView?.kf_setImageWithURL(NSURL.init(string: coverImg)!, placeholderImage: nil)
        }
        if let name = model.name {
            self.nameLabel?.text = name
        }
        if let finish = model.finish{
            if finish {
                self.finishLabel?.text = "  已完结  "
                self.finishLabel?.backgroundColor = getColor("CD3700")
            }else {
                self.finishLabel?.text = "  未完结  "
                self.finishLabel?.backgroundColor = getColor("3CB371")
            }
        }
        if let type = model.type {
            self.typeLabel?.text = "类型：" + type
        }
        if let area = model.area {
            self.areaLabel?.text = area
        }
        if let lastUpdate = model.lastUpdate {
            let textStr = "最近更新：" + lastUpdate
            
            let attributedStr = NSMutableAttributedString(string: textStr)
            attributedStr.addAttribute(NSForegroundColorAttributeName, value: getColor("b6b6b6"), range: NSRange.init(location: 0, length: 5))
            self.updateLabel?.attributedText = attributedStr
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
