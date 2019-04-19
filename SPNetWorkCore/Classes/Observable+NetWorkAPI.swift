//
//  Observable+NetWorkAPI.swift
//  NetWorkCore
//
//  Created by 宋璞 on 2019/4/19.
//  Copyright © 2019 宋璞. All rights reserved.
//

import UIKit
import Result
import RxSwift
import SwiftyJSON
import SPModelProtocol


extension ObservableType where E: TargetType {
    
    
    /// 将 TargetType 类型数据流 转换成网络请求  并解析成 json 格式的事件流
    /// 该方法适配所有的返回格式是json类型的请求，不受Reg 的影响
    ///
    /// - Returns: JSON格式的数据流
    public func emeRequestApiForJson() -> Observable<Result<JSON, MikerError>> {
        return flatMapLatest({ (response) -> Observable<Result<JSON, MikerError>> in
            return NetWorkAPI.sharedInstance.request(response)
                .observeOn(MainScheduler.instance)
                .do(onError: { (str) in
                    UrlManager.sharedInstance.getNext()
                }).retry(UrlManager.sharedInstance.retryNum)
                .mapSwiftyJSON()
                .map({ Result.success($0)})
                .catchError({ error in
                    if error is MikerError {
                        return Observable.just(Result.failure(error as! MikerError))
                    } else {
                        let error = error as NSError
                        return Observable.just(Result.failure(MikerError(error.domain, code: error.code, message: error.localizedDescription)))
                    }
                })
        })
    }
    public func emeRequestApiForJson(_ activityIndicator: ActivityIndicator) -> Observable<Result<JSON,MikerError>> {
        return flatMapLatest { response -> Observable<Result<JSON,MikerError>> in
            return  NetWorkAPI.sharedInstance.request(response)
                .observeOn(MainScheduler.instance)
                .do(onError: { str in
                    UrlManager.sharedInstance.getNext()
                })
                .retry(UrlManager.sharedInstance.retryNum)
                .mapSwiftyJSON()
                .trackActivity(activityIndicator)
                .map{Result.success($0)}
                .catchError{ error in
                    if error is MikerError{
                        return Observable.just(Result.failure(error as! MikerError))
                    }else{
                        let errir  = error as NSError
                        return Observable.just(Result.failure(MikerError(errir.domain,code:errir.code,message: errir.localizedDescription)))
                    }
            }
        }
    }
    
    
    /// 将TargetType 类型数据流转换成网络请求  并将解析成json格式的对象的事件流
    /// 返回结果必须是   Reg 类型d格式
    ///
    /// - Returns: JSON格式数据流
    public func emRequestApiForRegJson() -> Observable<Result<JSON, MikerError>> {
        return flatMapLatest({ (response) -> Observable<Result<JSON, MikerError>> in
            return NetWorkAPI.sharedInstance.request(response)
                .observeOn(MainScheduler.instance)
                .do(onError: { (str) in
                    UrlManager.sharedInstance.getNext()
                }).retry(UrlManager.sharedInstance.retryNum)
                .mapSwiftyJSONReg()
                .map({ Result.success($0)})
                .catchError({ error in
                    if error is MikerError {
                        return Observable.just(Result.failure(error as! MikerError))
                    } else {
                        let error = error as NSError
                        return Observable.just(Result.failure(MikerError(error.domain, code: error.code, message: error.localizedDescription)))
                    }
                })
        })
    }
    public func emRequestApiForRegJson(_ activityIndicator: ActivityIndicator) -> Observable<Result<JSON, MikerError>> {
        return flatMapLatest({ (response) -> Observable<Result<JSON, MikerError>> in
            return NetWorkAPI.sharedInstance.request(response)
                .observeOn(MainScheduler.instance)
                .do(onError: { (str) in
                    UrlManager.sharedInstance.getNext()
                }).retry(UrlManager.sharedInstance.retryNum)
                .mapSwiftyJSONReg()
                .trackActivity(activityIndicator)
                .map({ Result.success($0)})
                .catchError({ error in
                    if error is MikerError {
                        return Observable.just(Result.failure(error as! MikerError))
                    } else {
                        let error = error as NSError
                        return Observable.just(Result.failure(MikerError(error.domain, code: error.code, message: error.localizedDescription)))
                    }
                })
        })
    }
    
    /// 将 TargetType 类型数据流 转换成网络请求  并解析成 model 格式的事件流
    ///
    ///
    /// - Returns: model对象格式数据流
    public func emeRequestApiForObj<T: ModelProtocol>(_ type: T.Type) -> Observable<Result<T, MikerError>> {
        return flatMapLatest({ (response) -> Observable<Result<T, MikerError>> in
            return NetWorkAPI.sharedInstance.request(response)
                .observeOn(MainScheduler.instance)
                .do(onError: { (str) in
                    UrlManager.sharedInstance.getNext()
                }).retry(UrlManager.sharedInstance.retryNum)
                .mapSwiftyObject(type)
                .map{Result.success($0)}
                .catchError({ error in
                    if error is MikerError {
                        return Observable.just(Result.failure(error as! MikerError))
                    } else {
                        let error = error as NSError
                        return Observable.just(Result.failure(MikerError(error.domain, code: error.code, message: error.localizedDescription)))
                    }
                })
        })
    }
    public func emeRequestApiForObj<T: ModelProtocol>(_ type: T.Type, activityIndicator: ActivityIndicator) -> Observable<Result<T, MikerError>> {
        return flatMapLatest({ (response) -> Observable<Result<T, MikerError>> in
            return NetWorkAPI.sharedInstance.request(response)
                .observeOn(MainScheduler.instance)
                .do(onError: { (str) in
                    UrlManager.sharedInstance.getNext()
                }).retry(UrlManager.sharedInstance.retryNum)
                .mapSwiftyObject(type)
                .trackActivity(activityIndicator)
                .map{Result.success($0)}
                .catchError({ error in
                    if error is MikerError {
                        return Observable.just(Result.failure(error as! MikerError))
                    } else {
                        let error = error as NSError
                        return Observable.just(Result.failure(MikerError(error.domain, code: error.code, message: error.localizedDescription)))
                    }
                })
        })
    }
    
    /// 将 TargetType 类型数据流 转换成网络请求  并解析成 数组对象 格式的事件流
    ///
    ///
    /// - Returns: model-数组 对象格式数据流
    public func emeRequestApiForArray<T: ModelProtocol>(_ type: T.Type) -> Observable<Result<[T], MikerError>> {
        return flatMapLatest({ (response) -> Observable<Result<[T], MikerError>> in
            return NetWorkAPI.sharedInstance.request(response)
                .observeOn(MainScheduler.instance)
                .do(onError: { (str) in
                    UrlManager.sharedInstance.getNext()
                }).retry(UrlManager.sharedInstance.retryNum)
                .mapSwiftyArray(type)
                .map{Result.success($0)}
                .catchError({ error in
                    if error is MikerError {
                        return Observable.just(Result.failure(error as! MikerError))
                    } else {
                        let error = error as NSError
                        return Observable.just(Result.failure(MikerError(error.domain, code: error.code, message: error.localizedDescription)))
                    }
                })
        })
    }
    public func emeRequestApiForArray<T: ModelProtocol>(_ type: T.Type, activityIndicator: ActivityIndicator) -> Observable<Result<[T], MikerError>> {
        return flatMapLatest({ (response) -> Observable<Result<[T], MikerError>> in
            return NetWorkAPI.sharedInstance.request(response)
                .observeOn(MainScheduler.instance)
                .do(onError: { (str) in
                    UrlManager.sharedInstance.getNext()
                }).retry(UrlManager.sharedInstance.retryNum)
                .mapSwiftyArray(type)
                .map{Result.success($0)}
                .trackActivity(activityIndicator)
                .catchError({ error in
                    if error is MikerError {
                        return Observable.just(Result.failure(error as! MikerError))
                    } else {
                        let error = error as NSError
                        return Observable.just(Result.failure(MikerError(error.domain, code: error.code, message: error.localizedDescription)))
                    }
                })
        })
    }
}


extension ObservableType where E == Result<JSON, MikerError> {
    
    
    /// 将 json 转换成model 主要通过外部 reg_block来确定怎么解析
    ///
    /// - Parameters:
    ///   - type:
    ///   - reg_block:
    /// - Returns:
    public func parsingObjectModel<T: ModelProtocol>(_ type: T.Type, reg_block: @escaping ((_ json: JSON) -> Any)) -> Observable<Result<T, MikerError>> {
        return flatMap({ (response) -> Observable<Result<T, MikerError>> in
            switch response {
            case .success(let result):
                /// 需要外部专门解析，热庵后将剩余的json实例化为 model
                let regObj = reg_block(result)
                if let regModel = regObj as? JSON {
                    guard let mappedObject = T(json: regModel) else {
                        return Observable.just(Result.failure(MikerError("client error code", code: 101, message: "对象转换错误")))
                    }
                    return Observable.just(Result.success(mappedObject))
                } else if let error = regObj as? MikerError {
                    return Observable.just(Result.failure(error))
                } else {
                    return Observable.just(Result.failure(MikerError("client error code",code:101,message:"对象转换错误")))
                }
            case .failure(let error):
                return Observable.just(Result.failure(error))
            }
        })
    }
    
    
    /// 将 json 转换成  [model] 主要通过外部 reg_block来确定怎么解析
    ///
    /// - Parameters:
    ///   - type:
    ///   - reg_block:
    /// - Returns:
    public func parsingObjectArray<T: ModelProtocol>(_ type: T.Type, reg_block: @escaping ((_ json: JSON) -> Any)) -> Observable<Result<[T], MikerError>> {
        return flatMap({ (response) -> Observable<Result<[T], MikerError>> in
            switch response {
            case .success(let result):
                ///需要外部专门解析然后将剩余的json实例化为model
                let regObj = reg_block(result)
                if let regList = regObj as? JSON {
                    let mappedObjectsArray = regList.arrayValue.compactMap({ T(json: $0) })
                    return Observable.just(Result.success(mappedObjectsArray))
                } else if let error = regObj as? MikerError {
                    return Observable.just(Result.failure(error))
                } else {
                    return Observable.just(Result.failure(MikerError("client error code",code:101,message:"对象转换错误")))
                }
            case .failure(let error):
                return Observable.just(Result.failure(error))
            }
        })
    }
}
