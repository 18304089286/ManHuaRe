//
//  HomeViewController.swift
//  ManHuaRe
//
//  Created by 孙宇 on 16/3/29.
//  Copyright © 2016年 孙宇. All rights reserved.
//

import UIKit
import SnapKit

class HomeViewController: BaseViewController,FlowingMenuDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    private let PresentSegueName = "PresentMenuSegue"
    private let DismissSegueName = "DismissMenuSegue"
    var menu: MenuViewController?
    
    var collectionView: UICollectionView?
    var dataArray = []
    @IBOutlet var flowingMenuTransitionManager: FlowingMenuTransitionManager!
    
    
//MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        //侧边栏
        flowingMenuTransitionManager.setInteractivePresentationView(self.view)
        flowingMenuTransitionManager.delegate = self
        
        self.navigationItem.title = "首页"
        self.makeCollectionViewUI()
        //获取首页数据
//        self.homeDataNetwork()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Network
    func homeDataNetwork() {
        ClassSearchModel.classSearchNetwork { (model) in
            self.dataArray = (model.value?.result)!
        }
        
    }
    
    
    
//MARK: - UICollectionView,UICollectionViewDelegate,UICollectionViewDataSource
    func makeCollectionViewUI() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
        
        self.collectionView = UICollectionView(frame: CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT), collectionViewLayout: flowLayout)
        self.collectionView?.backgroundColor = .clearColor()
        self.collectionView?.delegate = self
        self.collectionView?.dataSource = self
        self.view.addSubview(self.collectionView!)
        self.collectionView?.registerClass(BannerHeaderView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: NSStringFromClass(BannerHeaderView.self))
    }

    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        let bannerHeaderView = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: NSStringFromClass(BannerHeaderView.self), forIndexPath: indexPath) as! BannerHeaderView
        
        return bannerHeaderView
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSizeMake(SCREEN_WIDTH, 1505 / HEIGHT_5S * SCREEN_HEIGHT)
    }
    
//MARK: - Click

    
    
     //MARK: - Navigation

     //In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == PresentSegueName {
            let vc                   = segue.destinationViewController
            vc.transitioningDelegate = flowingMenuTransitionManager
            
            flowingMenuTransitionManager.setInteractiveDismissView(vc.view)
            
            menu = vc as? MenuViewController
            menu!.homeVC = self
        }
    }
 
    @IBAction func unwindToMainViewController(sender: UIStoryboardSegue) {
    }
    // MARK: - Managing the Status Bar
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    // MARK: - FlowingMenu Delegate Methods
    
    func colorOfElasticShapeInFlowingMenu(flowingMenu: FlowingMenuTransitionManager) -> UIColor? {
        return .whiteColor()
    }
    
    func flowingMenuNeedsPresentMenu(flowingMenu: FlowingMenuTransitionManager) {
        performSegueWithIdentifier(PresentSegueName, sender: self)
    }
    
    func flowingMenuNeedsDismissMenu(flowingMenu: FlowingMenuTransitionManager) {
        menu?.performSegueWithIdentifier(DismissSegueName, sender: self)
    }
}
