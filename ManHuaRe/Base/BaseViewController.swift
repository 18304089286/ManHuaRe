//
//  BaseViewController.swift
//  ManHuaRe
//
//  Created by 孙宇 on 16/3/29.
//  Copyright © 2016年 孙宇. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = COMMON_BGCOLOR

        self.navigationController?.navigationBar.tintColor = getColor("2e2d33")
        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName:UIFont.boldSystemFontOfSize(18.0),NSForegroundColorAttributeName:getColor("2e2d33")]
//        let backItem = UIBarButtonItem()
//        backItem.title = ""
//        self.navigationItem.backBarButtonItem = backItem
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
