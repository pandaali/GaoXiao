//
//  MainViewController.swift
//  GaoXiao
//
//  Created by 汪红亮 on 2017/8/11.
//  Copyright © 2017年 rekuu. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //判断是否有新版本
        let checkMgr = CheckVersionMgr.shareInstance
        checkMgr.checkVersionWithSystemAlert()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
