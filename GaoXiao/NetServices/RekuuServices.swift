//
//  RekuuServices.swift
//  tucaoba
//
//  Created by 汪红亮 on 2017/7/18.
//  Copyright © 2017年 rekuu. All rights reserved.
//

import Foundation
import Moya

enum RekuuServices{
    case getCategory(parentid:Int, channelName:String)
    case getArticle(channelid:Int, categoryid:Int, pagesize:Int, pageindex:Int, strwhere:String, filedorder:String)
    case getArticleNew(channelid:Int, categoryid:Int, top:Int, strwhere:String, filedorder:String)
    case getArticleCount(channelid:Int, categoryid:Int, pagesize:Int, pageindex:Int, strwhere:String, filedorder:String)
}
    
extension RekuuServices:TargetType{
    var baseURL:URL{
        let baseUrl = "https://www.rekuu.com/api/app"//"http://192.168.2.134/api/app"//
        return URL(string:baseUrl)!
    }
    
    var path:String{
        switch self {
        case .getCategory(_,_):
            return "/category/GetCategoryByChannelName"
        case .getArticle(_, _, _, _, _, _):
            return "/article/GetArticle"
        case .getArticleNew(_, _, _, _, _):
            return "/article/GetArticleNew"
        case .getArticleCount(_, _, _, _, _, _):
            return "/article/GetArticleCount"
        }
    }
    
    var method: Moya.Method{
        switch self {
        case .getCategory, .getArticle, .getArticleNew, .getArticleCount:
            return .get
        }
    }
    
    var parameters:[String:Any]?{
        switch self {
        case .getCategory(let parentid, let channelName):
            return ["parentid":parentid, "channelName":channelName]
        case .getArticle(let channelid, let categoryid, let pagesize, let pageindex, let strwhere, let filedorder):
            return ["channelid":channelid, "categoryid":categoryid, "pagesize":pagesize, "pageindex":pageindex, "strwhere":strwhere, "filedorder":filedorder]
        case .getArticleNew(let channelid, let categoryid, let top, let strwhere, let filedorder):
            return ["channelid":channelid, "categoryid":categoryid, "top":top, "strwhere":strwhere, "filedorder":filedorder]
        case .getArticleCount(let channelid, let categoryid, let pagesize, let pageindex, let strwhere, let filedorder):
            return ["channelid":channelid, "categoryid":categoryid, "pagesize":pagesize, "pageindex":pageindex, "strwhere":strwhere, "filedorder":filedorder]
        }
    }
    
    var parameterEncoding: ParameterEncoding{
        switch self {
        case .getCategory, .getArticle, .getArticleNew, .getArticleCount:
            return URLEncoding.default
        }
    }
    
    var sampleData:Data{
        switch self {
        case .getCategory, .getArticle, .getArticleNew, .getArticleCount:
            return "默认数据".utf8Encoded
        }
    }
    
    var task:Task{
        switch self {
        case .getCategory, .getArticle, .getArticleNew, .getArticleCount:
            return .request        }
    }
}

// MARK: - Helpers
private extension String {
    var urlEscaped: String {
        return self.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }
    
    var utf8Encoded: Data {
        return self.data(using: .utf8)!
    }
}
