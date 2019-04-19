//
//  Observable+SwiftyJSON.swift
//  NetWorkCore
//
//  Created by 宋璞 on 2019/4/19.
//  Copyright © 2019 宋璞. All rights reserved.
//

import UIKit
import RxSwift
import SwiftyJSON
import SPModelProtocol

// MARK: - 扩展ObservableType 转换String为JSON ⚡️
public extension ObservableType where E == String {
    
    
    /// 最基础的SwiftJSON解析的封装
    ///
    /// - Returns: 返回JSON 对象
    func mapSwiftyJSON() -> Observable<JSON> {
        return flatMap { response -> Observable<JSON> in
            if let dataFromString = response.data(using: .utf8, allowLossyConversion: false) {
                do {
                    let json = try JSON(data: dataFromString)
                    return Observable.just(json)
                } catch _ {
                    throw MikerError("clienterrorcode",code:100,message:"JSON转换错误")
                }
            } else {
                throw MikerError("clienterrorcode",code:100,message:"JSON转换错误")
            }
        }
    }
    
    
    /// 该方法主要是针对特殊返回的数据进行解析的，一般分两部
    /// 该方法为第一步
    ///
    /// - Returns: 返回JSON 对象
    func mapSwiftyJSONReg() -> Observable<JSON> {
        return flatMap({ (response) -> Observable<JSON> in
            if let dataFromString = response.data(using: .utf8, allowLossyConversion: false) {
                let json = try JSON(data: dataFromString)
                guard let regObj = Reg(json: json) else {
                    throw MikerError("client error code",code:101,message:"对象转换错误")
                }
                if regObj.status == NetWorkCore.successCode {
                    return Observable.just(regObj.data)
                } else {
                    throw MikerError("server error code",code:regObj.status,message:regObj.message)
                }
            } else {
                throw MikerError("client error code",code:100,message:"JSON转换错误")
            }
        })
    }
    
    
    /// 一次性解析成 model对象
    ///
    /// - Parameter type:
    /// - Returns: 返回model对象
    func mapSwiftyObject<T: ModelProtocol>(_ type: T.Type) -> Observable<T> {
        return flatMap({ (response) -> Observable<T> in
            if let dataFromString = response.data(using: .utf8, allowLossyConversion: false) {
                let json = try JSON(data: dataFromString)
                guard let regObj = Reg(json: json) else {
                    throw MikerError("client error code",code:101,message:"对象转换错误")
                }
                if regObj.status == NetWorkCore.successCode {
                    guard let mappedObject = T(json: regObj.data) else {
                        throw MikerError("client error code",code:101,message:"对象转换错误")
                    }
                    return Observable.just(mappedObject)
                } else {
                    throw MikerError("server error code",code:regObj.status,message:regObj.message)
                }
            } else {
                throw MikerError("client error code",code:100,message:"JSON转换错误")
            }
        })
    }
    
    
    /// 一次性解析成 model 数组对象
    ///
    /// - Parameter type:
    /// - Returns: 数组对象
    func mapSwiftyArray<T: ModelProtocol>(_ type: T.Type) -> Observable<[T]> {
        return flatMap({ (response) -> Observable<[T]> in
            if let dataFromString = response.data(using: .utf8, allowLossyConversion: false) {
                let json = try JSON(data: dataFromString)
                guard let regObj = Reg(json: json) else {
                    throw MikerError("client error code",code:101,message:"对象转换错误")
                }
                if regObj.status == NetWorkCore.successCode {
                    let mappedObjectArray = regObj.data.arrayValue.compactMap { T(json: $0)}
                    return Observable.just(mappedObjectArray)
                } else {
                    throw MikerError("server error code",code:regObj.status,message:regObj.message)
                }
            } else {
                throw MikerError("client error code",code:100,message:"JSON转换错误")
            }
        })
    }
    
    
}


// MARK: - 扩展ObservableType 转换Sting为对象
public extension ObservableType where E == JSON {
    
    /// 解析JSON 到 model 对象
    /// 这块需要对应上面的mapSwiftyJSONReg第一步 ， 该方法是 第二步
    ///
    /// - Parameter type:
    /// - Returns: model 对象
    func mapSwiftyObjectModel<T: ModelProtocol>(_ type: T.Type) -> Observable<T> {
        return flatMap({ (response) -> Observable<T> in
            guard let mappedObject = T(json: response) else {
                throw MikerError("client error code",code:101,message:"对象转换错误")
            }
            return Observable.just(mappedObject)
        })
    }
    
    
    /// 解析JSON 到 model的数组对象
    /// 这块需要对应上面的mapSwiftyJSONReg第一步 ， 该方法是 第二步
    ///
    /// - Parameter type:
    /// - Returns: model数组 对象
    func mapSwiftyArrayModel<T: ModelProtocol>(_ type: T.Type) -> Observable<[T]> {
        return flatMap({ (response) -> Observable<[T]> in
            let mappedObjectArray = response.arrayValue.compactMap { T(json: $0)}
            return Observable.just(mappedObjectArray)
        })
    }
    
}
