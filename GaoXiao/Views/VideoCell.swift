//
//  VideoCell.swift
//  TTGXApp
//
//  Created by 汪红亮 on 2017/7/21.
//  Copyright © 2017年 rekuu. All rights reserved.
//

import UIKit
import AVFoundation
import MobileCoreServices

class VideoCell: UITableViewCell {

    @IBOutlet weak var imgVideo: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var player: UIImageView!
    
    var mp4_url:String!
    
    //内容图片的宽高比约束
    internal var aspectConstraint : NSLayoutConstraint? {
        didSet {
            if oldValue != nil {
                imgVideo.removeConstraint(oldValue!)
            }
            if aspectConstraint != nil {
                imgVideo.addConstraint(aspectConstraint!)
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
        let image = imgVideo.image
        
        if image != nil{
            //计算原始图片的宽高比
            let aspect = (image?.size.width)! / (image?.size.height)!
            //设置imageView宽高比约束
            aspectConstraint = NSLayoutConstraint(item: imgVideo,
                                                  attribute: .width, relatedBy: .equal,
                                                  toItem: imgVideo, attribute: .height,
                                                  multiplier: aspect, constant: 0.0)
        }
    }
    
    //加载内容图片（并设置高度约束）
    func loadImage(urlString: String) {
        
        if let url = URL(string: urlString), let image:UIImage = getVideoImage(videoUrl: url){
            
            // 加载本地图片处理方法
            //    func loadImage(name: String) {
            //        if let image = UIImage(named: name) {
            
            //计算原始图片的宽高比
            let aspect = image.size.width / image.size.height
            //设置imageView宽高比约束
            aspectConstraint = NSLayoutConstraint(item: imgVideo,
                                                  attribute: .width, relatedBy: .equal,
                                                  toItem: imgVideo, attribute: .height,
                                                  multiplier: aspect, constant: 0.0)
            //加载图片
            imgVideo.image = image
        }else{
            //去除imageView里的图片和宽高比约束
            aspectConstraint = nil
            imgVideo.image = nil
        }
    }
    
    private func getVideoImage(videoUrl: URL) -> UIImage {
        
        let avAsset = AVAsset.init(url: videoUrl)
        let generator = AVAssetImageGenerator.init(asset: avAsset)
        generator.appliesPreferredTrackTransform = true
        let time: CMTime = CMTimeMakeWithSeconds(0.0, 600) // 取第0秒， 一秒600帧
        var actualTime: CMTime = CMTimeMake(0, 0)
        let cgImage: CGImage = try! generator.copyCGImage(at: time, actualTime: &actualTime)
        
        return UIImage.init(cgImage: cgImage)
    }


    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
