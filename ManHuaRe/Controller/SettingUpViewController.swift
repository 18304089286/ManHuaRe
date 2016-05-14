//
//  SettingUpViewController.swift
//  ManHuaRe
//
//  Created by 孙宇 on 16/5/14.
//  Copyright © 2016年 孙宇. All rights reserved.
//

import UIKit

class WelcomeScrollView: UIScrollView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let array=["引导1","引导2","引导3"]
        
        self.contentSize=CGSizeMake(frame.size.width * CGFloat(Float( array.count)),frame.size.height);
        self.showsHorizontalScrollIndicator = false;
        self.showsVerticalScrollIndicator = true;
        //关闭反弹
        self.bounces = false;
        //分页
        self.pagingEnabled = true;
        //设置引导页
        for  i in 0..<array.count{
            let imageView = UIImageView(frame:CGRectMake(frame.size.width * CGFloat(Float(i)), 0, frame.size.width, frame.size.height))
            imageView.userInteractionEnabled = true;
            imageView.image = UIImage.init(named: array[i])
            self.addSubview(imageView)
            if (i==array.count-1) {
                
                let button = UIButton()
                button.frame = CGRectMake((frame.size.width-250)/2, frame.size.height-250,250 ,200);
                
                imageView.addSubview(button);
            }
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class SettingBtn: UIButton {
    
    
     func centerImageAndTitle(spacing:CGFloat)
    {
    // get the size of the elements here for readability
    let imageSize = self.imageView!.frame.size;
    let titleSize = self.titleLabel!.frame.size;
    
    // get the height they will take up as a unit
    let totalHeight = (imageSize.height + titleSize.height + spacing);
    
    // raise the image and push it right to center it
    self.imageEdgeInsets = UIEdgeInsetsMake(-(totalHeight - imageSize.height), 0.0, 0.0, -titleSize.width);
    
    // lower the text and push it left to center it
    self.titleEdgeInsets = UIEdgeInsetsMake(0.0, -imageSize.width, -(totalHeight - titleSize.height),0.0);
    }
    
    
    override func layoutSubviews() {
    super.layoutSubviews();
    
    // Center image
    var center = self.imageView!.center;
    center.x = self.frame.size.width/2;
    center.y = self.imageView!.frame.size.height/2;
    self.imageView!.center = center;
    
    //Center text
    var newFrame = self.titleLabel!.frame;
    newFrame.origin.x = 0;
    newFrame.origin.y = self.imageView!.frame.size.height + 5;
    newFrame.size.width = self.frame.size.width;
    
    self.titleLabel!.frame = newFrame;
    self.titleLabel!.textAlignment = .Center;
    }

}

class SettingUpViewController: BaseViewController {

    var welcomeScrollView = WelcomeScrollView()

    
    //MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "设置"
        
        let array : NSArray = [["image":"btn_search","title":"关于我们"],
                               ["image":"btn_search","title":"清理缓存"],
                               ["image":"btn_search","title":"欢迎页"],
                               ["image":"btn_search","title":"关灯"],
                               ["image":"btn_search","title":"关灯"],
                               ["image":"btn_search","title":"关灯"],
                               ["image":"btn_search","title":"关灯"]]
        
        let whidthAndHeight : CGFloat = 80.0
        
        
        for index in 0..<array.count {
            
            let btn = SettingBtn(frame: CGRectMake(SCREEN_WIDTH * 0.25 * CGFloat(Float (index + 1 - index / 3 * 3)) - 40, CGFloat(Float (index / 3)) * (whidthAndHeight + 10) + 94 , whidthAndHeight ,whidthAndHeight))
            let dic = array[index]
            
            btn.titleLabel?.font = UIFont.systemFontOfSize(12)
            btn.setTitleColor(getColor("666666"), forState: .Normal)
            btn.setTitle(dic.objectForKey("title") as? String, forState: .Normal)
            btn.setImage(UIImage.init(named: (dic.objectForKey("image") as? String)!) , forState: .Normal)
            btn .addTarget(self, action:#selector(SettingUpViewController.settingClick(_:)), forControlEvents: .TouchUpInside)
            btn .centerImageAndTitle(6.0)
            self.view.bringSubviewToFront(btn)
            self.view.addSubview(btn);
            
            
            if index % 3 == 0 {
                btn.frame = CGRectOffset(btn.frame, -20, 0)
            }else if index % 3 == 2{
                btn.frame = CGRectOffset(btn.frame, 20, 0)
            }
            
            btn.tag = index + 300;
            if btn.tag == 303 {
                btn.setTitle("开灯", forState: .Selected)
            }
           
        }
        
        
        //欢迎页
        welcomeScrollView = WelcomeScrollView(frame: self.view.frame)
        self.view.bringSubviewToFront(welcomeScrollView)
        welcomeScrollView.hidden = true
        self.view.addSubview(welcomeScrollView)
        
        
        
      
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - action
    
    func settingClick(sender:UIButton) {
        
        switch sender.tag {
        case 300:
            let aboutUsVC = AboutUSViewController()
            self.navigationController?.pushViewController(aboutUsVC, animated: true)
        case 302:
            welcomeScrollView.hidden = false
        case 303:
            
            sender.selected = !sender.selected
            if sender.selected//关灯
            {
                screen_light = UIScreen.mainScreen().brightness
                UIScreen.mainScreen().brightness = 0.1;
                app_light = 0.1;

            }else{
                UIScreen.mainScreen().brightness = screen_light;
                app_light = screen_light;

            }
            
        default: break
            
        }
        
    }
    

}
