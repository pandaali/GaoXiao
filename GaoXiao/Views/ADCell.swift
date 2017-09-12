//
//  ADCell.swift
//  GaoXiao
//
//  Created by 汪红亮 on 2017/9/11.
//  Copyright © 2017年 rekuu. All rights reserved.
//

import UIKit
import GoogleMobileAds

class ADCell: UITableViewCell{
    
    

    @IBOutlet weak var nativeExpressAdView: GADNativeExpressAdView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
