//
//  ImageOperations.swift
//  TTGXApp
//
//  Created by 汪红亮 on 2017/7/28.
//  Copyright © 2017年 rekuu. All rights reserved.
//

import Foundation

//队列管理类，追踪每个操作的状态
class ImageOperations {
    //追踪进行中的和等待中的下载操作
    lazy var downloadsInProgress = [IndexPath:Operation]()
    //图片下载队列
    lazy var downloadQueue:OperationQueue = {
        var queue = OperationQueue()
        queue.name = "Image Download queue"
        queue.maxConcurrentOperationCount = 1
        return queue
    }()
    
    //追踪进行中的和等待中的滤镜操作
    lazy var filtrationsInProgress = [IndexPath:Operation]()
    //图片处理队列
    lazy var filtrationQueue:OperationQueue = {
        var queue = OperationQueue()
        queue.name = "Image Filtration queue"
        queue.maxConcurrentOperationCount = 1
        return queue
    }()
}
