//
//  Category.swift
//  tucaoba
//
//  Created by 汪红亮 on 2017/7/18.
//  Copyright © 2017年 rekuu. All rights reserved.
//

import Foundation
import ObjectMapper
import Moya

struct Category:Mappable {
    
    var _id: Int!
    var _channel_id: Int!
    var _parent_id:Int!
    var _title: String!
    var _sort_id:Int!
    var _site_id:Int!
    var _call_index:String?
    var _class_layer:Int!
    var _link_url:String?
    var _img_url:String?
    var _content:String?
    var _seo_title:String?
    var _seo_keywords:String?
    var _seo_description:String?
    var _is_lock:Int!
    var _category_specs:String?
    
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        _id    <- map["_id"]
        _channel_id         <- map["_channel_id"]
        _parent_id         <- map["_parent_id"]
        _title         <- map["_title"]
        _sort_id         <- map["_sort_id"]
        _site_id         <- map["_site_id"]
        _call_index         <- map["_call_index"]
        _class_layer         <- map["_class_layer"]
        _link_url         <- map["_link_url"]
        _img_url         <- map["_img_url"]
        _content         <- map["_content"]
        _seo_title         <- map["_seo_title"]
        _seo_keywords         <- map["_seo_keywords"]
        _seo_description         <- map["_seo_description"]
        _is_lock         <- map["_is_lock"]
        _category_specs         <- map["_category_specs"]
    }
}

extension Category{
    //获取笑太太搞笑分类
    static func getCategory(completion: @escaping ([Category]?) -> Void) {
        
        let provider = MoyaProvider<RekuuServices>()
        provider.request(.getCategory(parentid:0, channelName:"ttgaoxiao")) { (result) in
            switch result{
            case let .success(moyaResponse):
                
                /*   JSON对象处理方法
                //let json = try! moyaResponse.mapJSON() as! [String:Any]
                //if let jsonResponse = CategoryList(JSON: json){
                    
                //    completion(jsonResponse.clist)
                    
                //}
                */
                
                /*   JSON数组处理方法*/
                let json = try? moyaResponse.mapJSON() as! [[String:Any]]
                
                let categries = Mapper<Category>().mapArray(JSONArray: json!)
                
                completion(categries)
                
            case .failure:
                print("网络错误")
                completion(nil)
            }
        }
    }
    
}
