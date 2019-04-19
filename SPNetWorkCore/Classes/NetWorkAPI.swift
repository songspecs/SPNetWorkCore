//
//  NetWorkAPI.swift
//  NetWorkCore
//
//  Created by 宋璞 on 2019/4/19.
//  Copyright © 2019 宋璞. All rights reserved.
//

import UIKit
import Alamofire
import RxSwift
import SPModelProtocol
import SwiftyJSON
import enum Result.Result

public protocol TargetType {
    var path: String { get }
    var method: HTTPMethod { get }
    var parameters: Parameters? { get}
}

public class NetWorkAPI {
    
    public var headers:HTTPHeaders = [
        "Accept": "application/json"
    ]
    var alamofireManager: Session?
    /// 单例模式
    public static var sharedInstance: NetWorkAPI {
        struct Static {
            static let instance : NetWorkAPI = NetWorkAPI(timeout: 15)
        }
        return Static.instance
    }
    
    init(timeout: TimeInterval) {
        let config = URLSessionConfiguration.default
        /// 设置请求超时时间
        config.timeoutIntervalForRequest = timeout
        let manager = Session(configuration: config)
        self.alamofireManager = manager
    }
    
    private let disponseBag = DisposeBag()
    
    
    /// 发起网络请求，返回数据转换成事件流传下去
    ///
    /// - Parameter target:
    /// - Returns: String-类型结果的数据流
    public func request(_ target: TargetType) -> Observable<String> {
        return Observable.create { [unowned self] observer -> Disposable in
            var baseurl: String = ""
            if target.path.hasPrefix("http") {
                baseurl = target.path
            } else {
                baseurl = UrlManager.sharedInstance.baseUrl + target.path
            }
            self.alamofireManager!.request(baseurl, method: target.method, parameters: target.parameters, encoding: URLEncoding.default, headers: self.headers).responseString(completionHandler: { (response) in
                switch response.result {
                case .success(let respos):
                    if NetWorkCore.isDebug == true {
                        if let httpUrl = response.response?.url {
                            if target.method == .post {
                                let showparam = "\(httpUrl.absoluteString)\(self.getShowParamUrl(param: target.parameters as [String : AnyObject]?))"
                                print("POST:: \n\(showparam)\n")
                            } else {
                                print("GET:: \n\(httpUrl.absoluteString)\n")
                            }
                        }
                    }
                    observer.onNext(respos)
                    observer.onCompleted()
                case .failure(let error):
                    print(String(describing: error))
                    if NetWorkCore.isDebug == true {
                        if target.method == .post {
                            let showparam = baseurl + "\(self.getShowParamUrl(param: target.parameters as [String : AnyObject]?))"
                            print("post:\n\(showparam)\n")
                        } else {
                            print("GET:: \n\(baseurl)\n")
                        }
                    }
                    observer.onError(error)
                }
            })
            return Disposables.create()
        }
    }

    
    /// 发起网络请求 将返回z数据转换成事件流传下去
    ///
    /// - Parameters:
    ///   - target:
    ///   - didResponseBlock: Result<String，MikerError>
    public func request(_ target: TargetType, didResponseBlock: @escaping ((_ responseData : Result<String, MikerError>) -> Void)) -> Void {
        var  baseurl:String = ""
        if target.path.hasPrefix("http") {
            baseurl = target.path
        }else{
            baseurl = UrlManager.sharedInstance.baseUrl + target.path;
        }
        self.alamofireManager!.request(baseurl,method: target.method , parameters: target.parameters,encoding: URLEncoding.default,headers:self.headers) .responseString { response in
            switch response.result {
            case.success(let repos):
                if NetWorkCore.isDebug == true {
                    if let httpUrl = response.response?.url{
                        if target.method == .post{
                            let showparam = "\(httpUrl.absoluteString)\(self.getShowParamUrl(param: target.parameters as [String : AnyObject]?))"
                            print("post:\n\(showparam)\n")
                        }else{
                            print("get:\n\(httpUrl.absoluteString)\n")
                        }
                    }
                    print(repos)
                }
                ///调用回调
                didResponseBlock(Result(repos))
            case.failure(let error):
                print(String(describing: error))
                if NetWorkCore.isDebug == true {
                    if target.method == .post{
                        let showparam = baseurl + self.getShowParamUrl(param: target.parameters as [String : AnyObject]?)
                        print("post:\n\(showparam)\n")
                    }else{
                        print("get:\n\(baseurl)\n")
                    }
                }
                ///调用回调
                didResponseBlock(Result.failure(MikerError(error: error as NSError)))
            }
        }
    }
    
    
    /// 发起网络请求并且 将返回的数据转换成事件流传下去
    ///
    /// - Parameters:
    ///   - target:
    ///   - didResponseBlock: 
    public func requestSwiftyJSONReg(_ target: TargetType, didResponseBlock:@escaping ((_ responsedata : Result<JSON,MikerError>) -> Void)) -> Void{
        self.request(target){ result in
            switch result{
            case .success(let data):
                if let dataFromString = data.data(using: String.Encoding.utf8, allowLossyConversion: false) {
                    do {
                        let json = try JSON(data: dataFromString)
                        guard let regObj = Reg(json: json) else {
                            return didResponseBlock(Result.failure(MikerError("client error code",code:101,message:"对象转换错误")))
                        }
                        if regObj.status == NetWorkCore.successCode{
                            ///调用回调
                            didResponseBlock(Result(regObj.data))
                        }else{
                            didResponseBlock(Result.failure(MikerError("server error code",code:regObj.status,message:regObj.message)))
                        }
                    } catch _ {
                        didResponseBlock(Result.failure( MikerError("client error code",code:100,message:"JSON转换错误")))
                    }
                }else{
                    didResponseBlock(Result.failure( MikerError("client error code",code:100,message:"JSON转换错误")))
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    /// 显示 post 请求的 参数
    ///
    /// - Parameter param: 请求参数
    /// - Returns: String值
    private func getShowParamUrl(param: [String: AnyObject]?) -> String {
        var relStr = ""
        var relArr: [String] = []
        if let param = param {
            for item in param {
                relArr.append(item.0 + "=" + String(describing: item.1))
            }
        }
        if relArr.count > 0 {
            relStr = "?" + relArr.joined(separator: "&")
        }
        return relStr
    }
}
