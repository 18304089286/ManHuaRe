//
//  HistoryTableViewCell.swift
//  ManHuaRe
//
//  Created by 孙宇 on 16/4/26.
//  Copyright © 2016年 孙宇. All rights reserved.
//

import UIKit

protocol HistoryTableViewCellDelegate:NSObjectProtocol {
    func historyTableViewCellDelegateWithContinueLook(cell:HistoryTableViewCell)
}

class HistoryTableViewCell: UITableViewCell {

    private var coverImageView: UIImageView?
    private var nameLabel: UILabel?
    private var typeLabel: UILabel?
    private var areaLabel: UILabel?
    private var updateLabel: UILabel?
    private var continueLookBtn: UIButton?
    weak var delegate :HistoryTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = .clearColor()
        self.selectionStyle = .None
        
        //背景白色View
        let whiteBgView = UIView()
        whiteBgView.backgroundColor = .whiteColor()
        self.contentView.addSubview(whiteBgView)
        whiteBgView.snp_makeConstraints { (make) in
            make.top.equalTo(self.contentView).offset(5)
            make.left.equalTo(self.contentView).offset(5)
            make.right.equalTo(self.contentView).offset(-5)
            make.bottom.equalTo(self.contentView)
        }
        
        //漫画封面
        coverImageView = UIImageView()
        whiteBgView.addSubview(coverImageView!)
        coverImageView?.snp_makeConstraints(closure: { (make) in
            make.width.equalTo(60)
            make.top.left.equalTo(whiteBgView).offset(5)
            make.bottom.equalTo(whiteBgView).offset(-5)
        })
        
        
        self.nameLabel = UILabel()
        self.nameLabel!.font = UIFont(name: "Verdana-Bold", size: 14)
        self.nameLabel!.textColor = getColor("838383")
        whiteBgView.addSubview(self.nameLabel!)
        self.nameLabel!.snp_makeConstraints { (make) in
            make.top.equalTo(self.coverImageView!).offset(7)
            make.left.equalTo(self.coverImageView!.snp_right).offset(10)
            make.height.equalTo(15)
        }
        
        self.typeLabel = UILabel()
        self.typeLabel!.font = UIFont.systemFontOfSize(12)
        self.typeLabel!.textColor = getColor("b6b6b6")
        whiteBgView.addSubview(self.typeLabel!)
        self.typeLabel!.snp_makeConstraints { (make) in
            make.left.equalTo(self.nameLabel!)
            make.top.equalTo(self.nameLabel!.snp_bottom).offset(5)
            make.height.equalTo(12)
        }
        
        self.areaLabel = UILabel()
        self.areaLabel!.font = UIFont.systemFontOfSize(12)
        self.areaLabel!.textColor = getColor("b6b6b6")
        whiteBgView.addSubview(self.areaLabel!)
        self.areaLabel!.snp_makeConstraints { (make) in
            make.left.equalTo(self.typeLabel!)
            make.top.equalTo(self.typeLabel!.snp_bottom).offset(5)
            make.height.equalTo(12)
        }
        
        self.updateLabel = UILabel()
        self.updateLabel!.font = UIFont.systemFontOfSize(12)
        self.updateLabel!.textColor = getColor("CD2626")
        whiteBgView.addSubview(self.updateLabel!)
        self.updateLabel!.snp_makeConstraints { (make) in
            make.left.equalTo(self.areaLabel!)
            make.top.equalTo(self.areaLabel!.snp_bottom).offset(5)
            make.height.equalTo(12)
        }
        
        continueLookBtn = UIButton(type: .Custom)
        
        continueLookBtn?.setImage(UIImage(named: "read_btn"), forState: .Normal)
        continueLookBtn?.titleLabel?.font = UIFont.systemFontOfSize(10)
        continueLookBtn?.setTitleColor(getColor("b6b6b6"), forState: .Normal)
        continueLookBtn?.imageEdgeInsets = UIEdgeInsetsMake(-10, 10, 10, -10)
        continueLookBtn?.titleEdgeInsets = UIEdgeInsetsMake(20, -45, -20, 0)
        continueLookBtn?.addTarget(self, action: #selector(HistoryTableViewCell.continueClick), forControlEvents: .TouchUpInside)
        whiteBgView.addSubview(continueLookBtn!)
        continueLookBtn?.snp_makeConstraints(closure: { (make) in
            make.top.bottom.right.equalTo(whiteBgView)
            make.width.equalTo(65)
        })

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(model: BookList) {
        if let coverImg = model.coverImg {
            coverImageView?.kf_setImageWithURL(NSURL.init(string: coverImg)!, placeholderImage: nil)
        }
        if let name = model.name {
            self.nameLabel?.text = name
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
        if let historyChapterName = model.historyChapterName {
            let title = "续看" + historyChapterName
            continueLookBtn?.setTitle(title, forState: .Normal)
        }
    }
    
    func continueClick() {
        self.delegate?.historyTableViewCellDelegateWithContinueLook(self)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
