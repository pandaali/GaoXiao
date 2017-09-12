//
//  TextCell.swift
//  TTGXApp
//
//  Created by 汪红亮 on 2017/7/19.
//  Copyright © 2017年 rekuu. All rights reserved.
//

import UIKit

class TextCell: UITableViewCell {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblText: UILabel!
    @IBOutlet weak var lblComment: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
