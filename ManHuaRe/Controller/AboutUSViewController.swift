//
//  AboutUSViewController.swift
//  ManHuaRe
//
//  Created by 孙宇 on 16/5/14.
//  Copyright © 2016年 孙宇. All rights reserved.
//

import UIKit

class AboutUSViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "关于我们"
        
        let logoImageView = UIImageView(frame: CGRectMake(SCREEN_WIDTH / 2 - 50, 70 + 64, 100, 100))
        logoImageView.image = UIImage.init(named: "navigationBg")
        self.view .addSubview(logoImageView)
        
        
        let appNameLabel = UILabel(frame: CGRectMake(logoImageView.center.x - 100,CGRectGetMaxY(logoImageView.frame) + 8,200,20))
        appNameLabel.textAlignment = .Center
        appNameLabel.textColor = getColor("666666")
        appNameLabel.font = UIFont(name:"Zapfino", size: 17)
        appNameLabel.text = NSBundle.mainBundle().infoDictionary!["CFBundleDisplayName"] as?String

        self.view.addSubview(appNameLabel)
        
        
        let versonLabel = UILabel(frame: CGRectMake(logoImageView.center.x - 100,CGRectGetMaxY(appNameLabel.frame) + 8,200,20))
        
        versonLabel.textAlignment = .Center;
        versonLabel.textColor = UIColor.orangeColor()
        versonLabel.text = "v " + (NSBundle.mainBundle().infoDictionary!["CFBundleShortVersionString"] as?String)!
;
        versonLabel.font = UIFont.boldSystemFontOfSize(12)
        self.view .addSubview(versonLabel)
        
        let subordinateLabel = UILabel(frame: CGRectMake(0, SCREEN_HEIGHT - 60,SCREEN_WIDTH ,20))
        subordinateLabel.textColor = getColor("666666")
        subordinateLabel.text = "沈阳大学科技工程学院(12级)机自4班 孙宇"
        subordinateLabel.textAlignment = .Center
        subordinateLabel.font = UIFont.systemFontOfSize(14)
        self.view.addSubview(subordinateLabel)
        
        
        let contactLabel = UILabel(frame: CGRectMake(0, CGRectGetMaxY(subordinateLabel.frame) + 5,SCREEN_WIDTH ,20))
        contactLabel.textAlignment = .Center
        contactLabel.textColor = getColor("666666")
        contactLabel.font = UIFont.systemFontOfSize(13)
        contactLabel.text = "联系方式：dbssunyu@2008.sina.com"
        self.view.addSubview(contactLabel)
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
