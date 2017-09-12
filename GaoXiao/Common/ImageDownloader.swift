//
//  ImageDownloader.swift
//  TTGXApp
//
//  Created by 汪红亮 on 2017/7/28.
//  Copyright © 2017年 rekuu. All rights reserved.
//

import Foundation
import AVFoundation

//图片下载操作任务
class ImageDownloader: Operation {
    //电影条目对象
    let articleRecord: ArticleRecord
    
    init(articleRecord: ArticleRecord) {
        self.articleRecord = articleRecord
    }
    
    //在子类中重载Operation的main方法来执行实际的任务。
    override func main() {
        //在开始执行前检查撤消状态。任务在试图执行繁重的工作前应该检查它是否已经被撤消。
        if self.isCancelled {
            return
        }
        
        //如果有数据，创建一个图片对象并加入记录，然后更改状态。如果没有数据，将记录标记为失败并设置失败图片。
        
        switch self.articleRecord.type {
            case .gif:
                //下载图片。
                let imageData = try? Data(contentsOf: URL(string: self.articleRecord.url)!)
                
                //再一次检查撤销状态。
                if self.isCancelled {
                    return
                }
                
                if imageData != nil {
                    self.articleRecord.image = UIImage(data: imageData!)
                    self.articleRecord.state = .downloaded
                }
                else
                {
                    self.articleRecord.state = .failed
                    //self.articleRecord.image = UIImage(named: "failed")
                }
            case .pic:
                //下载图片。
                let imageData = try? Data(contentsOf: URL(string: self.articleRecord.url)!)
                
                //再一次检查撤销状态。
                if self.isCancelled {
                    return
                }
                
                if imageData != nil {
                    self.articleRecord.image = UIImage(data: imageData!)
                    self.articleRecord.state = .downloaded
                }
                else
                {
                    self.articleRecord.state = .failed
                    //self.articleRecord.image = UIImage(named: "failed")
                }
            case .video:
                //下载图片。
                let url = URL(string: self.articleRecord.url)
                let image:UIImage = getVideoImage(videoUrl: url!)
                
                //再一次检查撤销状态。
                if self.isCancelled {
                    return
                }
                
                self.articleRecord.image = image
                self.articleRecord.state = .downloaded
            
            case .txt:
                
                break
            case .ad:
                break
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

}
