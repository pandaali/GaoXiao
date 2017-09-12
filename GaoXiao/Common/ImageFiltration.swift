//
//  ImageFiltration.swift
//  TTGXApp
//
//  Created by 汪红亮 on 2017/7/28.
//  Copyright © 2017年 rekuu. All rights reserved.
//

import CoreImage

//滤镜处理任务
class ImageFiltration: Operation {
    //电影条目对象
    let articleRecord: ArticleRecord
    
    init(articleRecord: ArticleRecord) {
        self.articleRecord = articleRecord
    }
    
    //在子类中重载Operation的main方法来执行实际的任务。
    override func main () {
        if self.isCancelled {
            return
        }
        
        if self.articleRecord.state != .downloaded {
            return
        }
        
        /*
        if let filteredImage = self.applySepiaFilter(self.articleRecord.image!) {
            self.articleRecord.image = filteredImage
            self.articleRecord.state = .filtered
        }
        */
    }
    
    //给图片添加棕褐色滤镜
    func applySepiaFilter(_ image:UIImage) -> UIImage? {
        let inputImage = CIImage(data:UIImagePNGRepresentation(image)!)
        
        if self.isCancelled {
            return nil
        }
        let context = CIContext(options:nil)
        let filter = CIFilter(name:"CISepiaTone")
        filter?.setValue(inputImage, forKey: kCIInputImageKey)
        filter?.setValue(0.8, forKey: "inputIntensity")
        let outputImage = filter?.outputImage
        
        if self.isCancelled {
            return nil
        }
        
        let outImage = context.createCGImage(outputImage!, from: outputImage!.extent)
        let returnImage = UIImage(cgImage: outImage!)
        return returnImage
    }
}
