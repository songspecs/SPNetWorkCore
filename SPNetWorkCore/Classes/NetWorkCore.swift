//
//  NetWorkCore.swift
//  NetWorkCore
//
//  Created by 宋璞 on 2019/4/19.
//  Copyright © 2019 宋璞. All rights reserved.
//

import UIKit

public  class NetWorkCore {
    /// 网络访问基础库
    public static var baseUrl:[String] = ["https://cnodejs.org/api/v1"]
    /// 表示是否是debug模式，debug 打印返回数据
    public static var isDebug:Bool = true
    /// 返回数据 状态解析key
    public static var statusKey:String = "status"
    /// 用于返回数据解析的key
    public static var dataKey:String = "data"
    /// 用于返回数据解析的key
    public static var messageKey:String = "msg"
    /// 表示返回成功的状态码
    public static var successCode:Int = 0
}

/// 基础地址管理
public class UrlManager {
    
    public static var sharedInstance : UrlManager {
        struct Static {
            static let instance : UrlManager = UrlManager()
        }
        return Static.instance
    }
    /// 重试次数
    public var repeatNum:Int = 2
    /// retry的次数 即轮训两遍数组中的地址
    public var retryNum:Int{
        get{
            return self.repeatNum*self.urlArr.count
        }
    }
    /// 地址数组
    private var urlArr:[String] = NetWorkCore.baseUrl
    /// 当前数组位置
    private var index:Int = 0
    /// 基础地址
    public var baseUrl:String{
        get{
            if self.urlArr.count > 0 {
                return self.urlArr[self.index%self.urlArr.count]
            }else{
                return ""
            }
        }
    }
    func getNext() {
        if self.index < self.urlArr.count * self.repeatNum {
            self.index = self.index + 1
        }else{
            self.index = 0
        }
    }
}
