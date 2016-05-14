//
//  SearchViewController
//
//
//  Created by bluemobi on 16/4/13.
//  Copyright © 2016年 bluemobi. All rights reserved.
//

import UIKit
class SearchViewController: BaseViewController,UITextFieldDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
 
    private var totalRecordArray:NSMutableArray!
    private let categoryData:[String] = ["动作","搞笑"]
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var collectionView: UICollectionView!
    
     //MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        totalRecordArray = getHistoryList()
        let screening:UIButton = UIButton(type: .System) as UIButton
        screening.frame = CGRectMake(0, 0, 60, 30)
        screening.setTitle("搜索", forState: UIControlState.Normal)
        screening.setTitleColor(getColor("87ceea"), forState: UIControlState.Normal)
        screening.addTarget(self, action: #selector(SearchViewController.searchButtonClick(_:)), forControlEvents: .TouchUpInside)
        searchTextField.rightView = screening
        searchTextField.rightViewMode = .WhileEditing
        searchTextField.returnKeyType = .Search
        searchTextField.placeholder = "请输入搜索信息"
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: buttonClick
    func searchButtonClick(button:UIButton){
        self.addHistoryRecodr()
    }
    @IBAction func deleteRecordButtonClick(sender: AnyObject) {
        totalRecordArray.removeAllObjects()
        let path:String = RecordData.getCachesPath("historySearch.plist") as String
        //判断是否可以删除
        if NSFileManager.defaultManager().fileExistsAtPath(path) {
             try! NSFileManager.defaultManager().removeItemAtPath(path)
        }
        totalRecordArray = getHistoryList()
        collectionView.reloadData()
    }
    
     //MARK: customMethods
    
    //获取记录数组
    func getHistoryList() -> NSMutableArray{
        let path = RecordData.getCachesPath("historySearch.plist") as String
        let array:NSMutableArray
        if NSMutableArray(contentsOfFile: path) != nil{
            array =  NSMutableArray(contentsOfFile: path)!

        }else{
             array =  NSMutableArray()
        }

        return array
    }
    
    //添加历史记录
    func addHistoryRecodr() {
        let path = RecordData.getCachesPath("historySearch.plist") as String
        var array:NSMutableArray = NSMutableArray()
        array = getHistoryList()
        
        //        let contains:Bool = array.contains { (element) -> Bool in
        //            if element .isEqualToString(searchTextField.text!){
        //                return false
        //            }else{
        //               return true
        //            }
        //        }
        //判断插入元素是否已经存在
        var contains:Bool = false
        for str in array as NSMutableArray {
            if str .isEqualToString(searchTextField.text!) {
                contains = true
            }
        }
        
        if !contains || array.count == 0{
            array.addObject(searchTextField.text!)
            array .writeToFile(path, atomically: false)
        }
        totalRecordArray = getHistoryList()
        searchTextField.text = ""
        collectionView.reloadData()

    }
    //MARK: UICollectionViewDataSource
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int{
        return 2
    }
    
    internal func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        if section == 0 {
            return totalRecordArray.count
        }
        return categoryData.count
        
    }
    
    internal func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView{
        if kind == UICollectionElementKindSectionHeader {
            let headerView: HistoryRecordHeaderCollectionReusableView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "HistoryRecordHeaderCollectionReusableView", forIndexPath: indexPath) as! HistoryRecordHeaderCollectionReusableView
            if indexPath.section == 0 {
                headerView.titleLabel.text = "历史记录"
            }else{
               headerView.titleLabel.text = "类别"
            }
    
            return headerView
        }else{
            let headerView: UICollectionReusableView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "deleteReusavleView", forIndexPath: indexPath)
            return headerView
        }
    }
    
    internal func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell{
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("HistoryRecordCollectionViewCell", forIndexPath: indexPath) as! HistoryRecordCollectionViewCell
            //        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(NSStringFromClass(HistoryRecordCollectionViewCell), forIndexPath: indexPath) as! HistoryRecordCollectionViewCell
            cell.titleLabel!.text = totalRecordArray[indexPath.row] as? String
            cell.indexPath = indexPath
            return cell
        }else{
            let cell  = collectionView.dequeueReusableCellWithReuseIdentifier("CategoryCollectionViewCell", forIndexPath: indexPath) as! CategoryCollectionViewCell
            cell.titleLabel.text = categoryData[indexPath.row]
            cell.indexPath = indexPath
            return cell
        }
      
    }
    
    
    //MARK: UICollectionViewDelegate
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize{
        if indexPath.section == 0 {
        let statusLabelText: NSString = (totalRecordArray[indexPath.row] as? String)!
        let statusLabelSize :CGSize = statusLabelText.sizeWithAttributes([NSFontAttributeName:UIFont.boldSystemFontOfSize(17)]) as CGSize
        return CGSizeMake(statusLabelSize.width + 10, statusLabelSize.height + 6)
        }
        return CGSize(width: SCREEN_WIDTH, height: 110)
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 0 {
            if  totalRecordArray.count == 0{
                return CGSize(width: 0, height: 0)
            }
            return CGSize(width: 50, height: 50)
        }
        return CGSize(width:50, height:50)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if section == 0 {
            if  totalRecordArray.count == 0{
                return CGSize(width: 0, height: 0)
            }
            return CGSize(width: 50, height: 50)
        }
        return CGSize(width: 0, height: 0)

    }
    
    //MARK: UITextFieldDelegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.addHistoryRecodr()
        return true
    }
    
}

