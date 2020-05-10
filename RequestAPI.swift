//
//  XDTRequestAPI.swift
//  XiaoDengTa
//
//  Created by 刘志康 on 2020/4/10.
//  Copyright © 2020 ------------. All rights reserved.
//

import Foundation
import Moya
import SwiftyJSON

public enum RequestAPI {
    case login(String, String) //登录接口
}

extension  RequestAPI: TargetType{
    static let serverUrl = xdt_developmentEnv() ? TestEnvironmentVC.currentServerUrl() : Config.produceEnvironmentUrl
  
    
    public var baseURL: URL {
        return URL.init(string: XDTRequestAPI.serverUrl)!;
    }
    
    public var path: String {
        
        switch self {
        case .login:
            return ""

        }
    }
    
    //请求接口时使用的方法
    public var method: Moya.Method {
        switch self {
        case .login:
            return .post
        default : return .post
        }
    }
    
     //请求接口时对应的请求参数
    public var task: Task {
        
        var params:[String : Any] = [:]

        switch self {
            case.login(let phone,let smsCode):
                params["channel"] = "iphone"
                params["deviceType"] = "ios"
                break;
            case .smscode(let phone):
                params["tel"] = phone
                break;
            case .postMessageList(let dicParams):
                params = dicParams
                break;
           case .loadModuleList(let version):
                break;
        case .postMessageList22(let str):
            params["tel"] = str
        }
        return .requestParameters(parameters: params, encoding: URLEncoding.default)
    }
    
    //header信息
    public var headers: [String : String]? {
        var header: [String:String] = [:]
        let token = CommonValue.getLoginToken().stringForKey(key: "accessToken")
        if token.count > 0 {
            header["Authorization"] = token
            header["deviceId"] = HDeviceIdentifier.deviceIdentifier()
            header["osVersion"] = XDT_SystemVersion
            header["appVersionCode"] = getVersionControl()
            header["osType"] = "IOS"
            header["appVersion"] = getAppVersion()
            header["deviceType"] = DeviceManager.modelName()

        }
        return header
    }
    //用于单元测试
    public var sampleData: Data {
        switch self {
        case .login:
            return "{\"id\": \"1\", \"first_name\": \"Harry\", \"last_name\": \"Potter\"}".data(using: String.Encoding.utf8)!
        default:
            return Data()
        }
    }

    public static func XDTRequestAPIProvider(timeInterval:TimeInterval  = 15) -> MoyaProvider<XDTRequestAPI> {
    return MoyaProvider<XDTRequestAPI>(
        requestClosure: { (endPoint, closure) in
            do {
                var urlRequest = try endPoint.urlRequest()
                urlRequest.timeoutInterval = timeInterval;
                closure(.success(urlRequest))
            } catch MoyaError.requestMapping(let url) {
                closure(.failure(MoyaError.requestMapping(url)))
            } catch MoyaError.parameterEncoding(let error) {
                closure(.failure(MoyaError.parameterEncoding(error)))
            } catch {
                closure(.failure(MoyaError.underlying(error, nil)))
            }
    })
}
}
