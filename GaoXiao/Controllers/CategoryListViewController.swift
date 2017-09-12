//
//  HotLastViewController.swift
//  GaoXiao
//
//  Created by 汪红亮 on 2017/9/9.
//  Copyright © 2017年 rekuu. All rights reserved.
//

import UIKit
import PageMenu

class CategoryListViewController: UIViewController {
    
    var pageMenu:CAPSPageMenu!
    var controllers: [UIViewController] = []
    
    func showMenu() {
        Category.getCategory{ (categories) in
            
            self.controllers = categories!.map{
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "sbid_TTGXList") as! CategoryListTableViewController
                vc.title = $0._title
                vc.categoryid = $0._id
                vc.parentNav = self.navigationController
                return vc
            }
            
            let param : [CAPSPageMenuOption] = [
                .menuItemSeparatorWidth(4.3),
                .scrollMenuBackgroundColor(UIColor.white),
                .viewBackgroundColor(UIColor(red: 247.0/255.0, green: 247.0/255.0, blue: 247.0/255.0, alpha: 1.0)),
                .bottomMenuHairlineColor(UIColor(red: 20.0/255.0, green: 20.0/255.0, blue: 20.0/255.0, alpha: 0.1)),
                //.selectionIndicatorColor(UIColor(red: 18.0/255.0, green: 150.0/255.0, blue: 225.0/255.0, alpha: 1.0)),
                .selectionIndicatorColor(UIColor.orange),
                .menuMargin(20.0),
                .menuHeight(44.0),
                //.selectedMenuItemLabelColor(UIColor(red: 18.0/255.0, green: 150.0/255.0, blue: 225.0/255.0, alpha: 1.0)),
                .selectedMenuItemLabelColor(UIColor.orange),
                .unselectedMenuItemLabelColor(UIColor(red: 40.0/255.0, green: 40.0/255.0, blue: 40.0/255.0, alpha: 1.0)),
                .menuItemFont(UIFont(name: "HelveticaNeue-Medium", size: 14.0)!),
                .useMenuLikeSegmentedControl(false),
                .menuItemSeparatorRoundEdges(true),
                .selectionIndicatorHeight(2.0),
                .menuItemSeparatorPercentageHeight(0.1)
            ]
            
            //20:顶部状态栏的高度；44:标题的高度；
            let titleHeight:CGFloat = 0//
            let topHeight:CGFloat = 20//
            let frame = CGRect(x:0, y:topHeight + titleHeight, width: self.view.frame.width, height: self.view.frame.height - topHeight - titleHeight)
            
            self.pageMenu = CAPSPageMenu(viewControllers: self.controllers, frame: frame, pageMenuOptions: param)
            
            self.view.addSubview(self.pageMenu.view)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //设置导航的标题为空
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        showMenu()
        
        //判断是否有新版本
        let checkMgr = CheckVersionMgr.shareInstance
        checkMgr.checkVersionWithSystemAlert()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
