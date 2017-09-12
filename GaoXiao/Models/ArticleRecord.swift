//
//  ArticleRecord.swift
//  TTGXApp
//
//  Created by 汪红亮 on 2017/8/9.
//  Copyright © 2017年 rekuu. All rights reserved.
//

import UIKit

// 这个枚举包含所有图片的状态
enum ImageRecordState {
    case new, downloaded, filtered, failed
}

// 这个枚举包含所有列表的类型（静态、动态）
enum ImageType {
    case pic, gif, video, txt, ad
}

// 电影条目类
class ArticleRecord {
    var article:Article
    var url:String
    //图片类型
    var type = ImageType.ad
    //图片状态
    var state = ImageRecordState.new
    //默认初始图片
    //var image = UIImage(named: "IMG_1279.jpg")
    var image = UIImage(named: "default.png")
    var imageView = UIImageView()
    
    init(article:Article, url:String) {
        self.article = article
        self.url = url
        
        switch self.article.category_id {
        case nil:
            self.type = ImageType.ad
        case 52:
            self.type = ImageType.txt
        case 53:
            self.type = ImageType.pic
        case 54:
            self.type = ImageType.video
        case 55:
            self.type = ImageType.gif
        default:
            self.type = ImageType.ad
        }
    }
}
