//
//  MenuViewController.swift
//  ManHuaRe
//
//  Created by 孙宇 on 16/4/25.
//  Copyright © 2016年 孙宇. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {

    private let PresentSegueName = "PresentMenuSegue"
    private let DismissSegueName = "DismissMenuSegue"
    var homeVC: UIViewController?
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = COMMON_BGCOLOR
        
        navigationBar.tintColor = getColor("2e2d33")
        navigationBar.titleTextAttributes = [NSFontAttributeName:UIFont.boldSystemFontOfSize(18.0),NSForegroundColorAttributeName:getColor("2e2d33")]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Managing the Status Bar
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }

    //MARK: - Click
    @IBAction func collectionClick(sender: UIButton) {
        self.performSegueWithIdentifier(DismissSegueName, sender: self)
        let collecVC = CollectViewController()
        homeVC?.navigationController?.pushViewController(collecVC, animated: true)
        
    }
    @IBAction func histroyClick(sender: UIButton) {
        self.performSegueWithIdentifier(DismissSegueName, sender: self)
        let historyVC = HistoryViewController()
        homeVC?.navigationController?.pushViewController(historyVC, animated: true)
    }
    @IBAction func optionClick(sender: UIButton) {
        self.performSegueWithIdentifier(DismissSegueName, sender: self)
        let optionVC = SettingUpViewController()
        homeVC?.navigationController?.pushViewController(optionVC, animated: true)
    }
}
