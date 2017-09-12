//
//  Utils.swift
//  TTGXApp
//
//  Created by 汪红亮 on 2017/7/20.
//  Copyright © 2017年 rekuu. All rights reserved.
//

import Foundation

extension String {
    //返回字数
    var count: Int {
        let string_NS = self as NSString
        return string_NS.length
    }
    
    //使用正则表达式替换
    func pregReplace(pattern: String, with: String,
                     options: NSRegularExpression.Options = []) -> String {
        let regex = try! NSRegularExpression(pattern: pattern, options: options)
        return regex.stringByReplacingMatches(in: self, options: [],
                                              range: NSMakeRange(0, self.count),
                                              withTemplate: with)
    }
    
    func pregCheck(str: String) {
        // 使用正则表达式一定要加try语句
        do {
            // - 1、创建规则
            let pattern = "[1-9][0-9]{4,14}"
            // - 2、创建正则表达式对象
            let regex = try NSRegularExpression(pattern: pattern, options: NSRegularExpression.Options.caseInsensitive)
            // - 3、开始匹配
            let res = regex.matches(in: str, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, str.characters.count))
            // 输出结果
            for checkingRes in res {
                print((str as NSString).substring(with: checkingRes.range))
            }
        }
        catch {
            print(error)
        }
    }
    
    func matches(pattern: String = "[0-9]{3}-[0-9]{3}-[0-9]{4}", limitation: Int = 32) -> [(rangeBegin: Int, rangeEnd: Int, extraction: String)] {
        
        // set up an empty result set
        var found = [(rangeBegin: Int, rangeEnd: Int, extraction: String)]()
        
        // prepare to compile the regular expression
        var reg = regex_t()
        let status = regcomp(&reg, pattern, REG_EXTENDED)
        if status != 0 {
            return found
        }//end if
        
        // allocate a buffer for the outcomes
        let m = UnsafeMutablePointer<regmatch_t>.allocate(capacity: limitation)
        
        // preform searching
        var nomatch:Int32 = 1
        
        // prepare pointers
        let me = strdup(self)
        var cursor = me
        let copy = strdup(self)
        let sz = Int(strlen(me!))
        
        // loop until all matches were found
        repeat {
            
            // perform the search
            nomatch = regexec(&reg, cursor, limitation, m, 0)
            
            // no match was found, jump out
            if nomatch != 0 {
                break
            }//end if
            
            
            // retrieve each matches from the pointer buffer
            for i in 0 ... limitation - 1 {
                
                // if reach the end, the position marker will be -1
                let p = m.advanced(by: i).pointee
                guard p.rm_so > -1 else {
                    break
                }//end guard
                
                // save the result into the duplicated string
                memset(copy!, 0, Int(sz))
                memcpy(copy!, cursor!.advanced(by: Int(p.rm_so)), Int(p.rm_eo) - Int(p.rm_so))
                
                // turn the pointer into string
                let extraction = String(cString: copy!)
                
                // append outcomes to return set
                found.append((Int(p.rm_so), Int(p.rm_eo), extraction))
            }//next i
            
            cursor = cursor!.advanced(by: Int(m.pointee.rm_eo))
            
            // loop until nothing further was found
        }while(nomatch == 0)
        
        // release temporary allocations
        free(copy)
        free(me)
        // release resources before checking outcomes
        regfree(&reg)
        // release the pointer buffer
        m.deallocate(capacity: limitation)
        return found
    }//end func
    
//    // 匹配字符串中所有的符合规则的字符串, 返回匹配到的NSTextCheckingResult数组
//    public func matchesInString(string: String, options: NSMatchingOptions, range: NSRange) -> [NSTextCheckingResult]
//    
//    // 按照规则匹配字符串, 返回匹配到的个数
//    public func numberOfMatchesInString(string: String, options: NSMatchingOptions, range: NSRange) -> Int
//    
//    // 按照规则匹配字符串, 返回第一个匹配到的字符串的NSTextCheckingResult
//    public func firstMatchInString(string: String, options: NSMatchingOptions, range: NSRange) -> NSTextCheckingResult?
//    
//    // 按照规则匹配字符串, 返回第一个匹配到的字符串的范围
//    public func rangeOfFirstMatchInString(string: String, options: NSMatchingOptions, range: NSRange) -> NSRange
    
    
}
