//
//  ImgCell.swift
//  TTGXApp
//
//  Created by 汪红亮 on 2017/7/20.
//  Copyright © 2017年 rekuu. All rights reserved.
//

import UIKit

class ImgCell: UITableViewCell {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgContent: UIImageView!
    
    //内容图片的宽高比约束
    internal var aspectConstraint : NSLayoutConstraint? {
        didSet {
            if oldValue != nil {
                imgContent.removeConstraint(oldValue!)
            }
            if aspectConstraint != nil {
                imgContent.addConstraint(aspectConstraint!)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        //清除内容图片的宽高比约束
        aspectConstraint = nil
    }
    
    func SetImageRect() -> Void {
        let image = self.imgContent.image
        
        if image != nil{
            //计算原始图片的宽高比
            let aspect = (image?.size.width)! / (image?.size.height)!
            //设置imageView宽高比约束
            aspectConstraint = NSLayoutConstraint(item: imgContent,
                                              attribute: .width, relatedBy: .equal,
                                              toItem: imgContent, attribute: .height,
                                              multiplier: aspect, constant: 0.0)
        }
        
    }
    
    
    //加载内容图片（并设置高度约束）
    func loadImage(urlString: String) {
        //定义NSURL对象
        let url = URL(string: urlString)
        let data = try? Data(contentsOf: url!)
        //从网络获取数据流,再通过数据流初始化图片
        if let imageData = data, let image = UIImage(data: imageData) {
            
            // 加载本地图片处理方法
            //    func loadImage(name: String) {
            //        if let image = UIImage(named: name) {
            
            //计算原始图片的宽高比
            let aspect = image.size.width / image.size.height
            //设置imageView宽高比约束
            aspectConstraint = NSLayoutConstraint(item: imgContent,
                                                  attribute: .width, relatedBy: .equal,
                                                  toItem: imgContent, attribute: .height,
                                                  multiplier: aspect, constant: 0.0)
            //加载图片
            imgContent.image = image
        }else{
            //去除imageView里的图片和宽高比约束
            aspectConstraint = nil
            imgContent.image = nil
        }
    }
 


    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
