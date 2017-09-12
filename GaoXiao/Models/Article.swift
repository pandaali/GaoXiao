//
//  Article.swift
//  TTGXApp
//
//  Created by 汪红亮 on 2017/7/19.
//  Copyright © 2017年 rekuu. All rights reserved.
//

import Foundation
import ObjectMapper
import Moya

struct  ArticleList:Mappable{
    var recordCount:Int!
    var pageCount:Int!
    var articles:[Article]!
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        recordCount    <- map["_recordCount"]
        pageCount    <- map["_pageCount"]
        articles    <- map["_articles"]
    }
}

struct Article:Mappable {
    
    var id: Int!
    var channel_id:Int!
    var category_id:Int!
    var title:String!
    var content:String!
    var add_time:String!
    var user_name:String!
    var is_msg:Bool!
    var zhaiyao:String!
    
    init?(map: Map) {
        
    }
    
    init() {
        
    }
    
    mutating func mapping(map: Map) {
        id    <- map["id"]
        channel_id    <- map["channel_id"]
        category_id    <- map["category_id"]
        title    <- map["title"]
        content    <- map["content"]
        add_time    <- (map["createtime"])
        user_name    <- map["user_name"]
        is_msg    <- map["is_msg"]
        zhaiyao    <- map["zhaiyao"]
    }
}

extension Article{
    
    //根据条件获取段子分类下的列表
    static func getArticle(categoryid:Int,pagesize:Int, pageindex:Int, completion: @escaping (ArticleList?) -> Void) {
        
        let provider = MoyaProvider<RekuuServices>()
        provider.request(.getArticle(channelid:7, categoryid:categoryid, pagesize:pagesize, pageindex:pageindex, strwhere:"id > 0", filedorder:"NEWID()")) { (result) in
            switch result{
            case let .success(moyaResponse):
                
                //JSON对象处理方法
                 let json = try! moyaResponse.mapString()
                 
                 if let list = Mapper<ArticleList>().map(JSONString: json){
                 
                     completion(list)
                 
                 }
 
                /*   JSON数组处理方法*/
                //let json = try? moyaResponse.mapJSON() as! [[String:Any]]
                //let articles = Mapper<Article>().mapArray(JSONArray: json!)
                
                //completion(articles)
                
            case .failure:
                print("网络错误")
                completion(nil)
            }
        }
    }
    
    //根据条件获取最新的内容列表
    static func getArticleNew(categoryid:Int,top:Int, refreshtime:String, completion: @escaping (ArticleList?) -> Void) {
        
        let provider = MoyaProvider<RekuuServices>()
        provider.request(.getArticleNew(channelid:7, categoryid:categoryid, top:top, strwhere:"id > 0", filedorder:"NEWID()")) { (result) in
            switch result{
            case let .success(moyaResponse):
                
                /*   JSON数组处理方法*/
                /*let json = try? moyaResponse.mapJSON() as! [[String:Any]]
                let articles = Mapper<Article>().mapArray(JSONArray: json!)
                
                completion(articles)*/
                
                //JSON对象处理方法
                let json = try! moyaResponse.mapString()
                
                if let list = Mapper<ArticleList>().map(JSONString: json){
                    
                    completion(list)
                    
                }
                
            case .failure:
                print("网络错误")
                completion(nil)
            }
        }
    }
}
