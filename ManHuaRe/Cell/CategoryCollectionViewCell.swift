//
//  CategoryCollectionViewCell.swift
//  SY漫画阅读器A版
//
//  Created by bluemobi on 16/4/24.
//  Copyright © 2016年 bluemobi. All rights reserved.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    var _indexPath:NSIndexPath?
    var indexPath:NSIndexPath {
        set{
            _indexPath = newValue
            let colorArray:NSArray! = [UIColor(red: 252/255, green: 157/255, blue: 154/255, alpha: 1),UIColor(red: 249/255, green: 205/255, blue: 173/255, alpha: 1),UIColor(red: 200/255, green: 200/255, blue: 169/255, alpha: 1),UIColor(red: 131/255, green: 175/255, blue: 155/255, alpha: 1)]
            let color:UIColor = (colorArray[_indexPath!.row % 4] as? UIColor)!
            
            self.backgroundColor = color
        }
        get{
           return _indexPath!
        }
    }
    
    
}
