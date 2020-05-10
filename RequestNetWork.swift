//
//  XDTRequestNetWork.swift
//  XiaoDengTa
//
//  Created by 刘志康 on 2020/4/10.
//  Copyright © 2020 -----------------. All rights reserved.
//

import Foundation
import Moya
import SwiftyJSON


struct RequestNetWork {
    
    public static func request(provider: MoyaProvider<XDTRequestAPI>,
                        target: XDTRequestAPI,
                        success successCallback: @escaping (JSON) -> Void,
                        error errorCallback: @escaping (Int) -> Void,
                        failure failureCallback: @escaping (MoyaError) -> Void) {
        provider.request(target) { result in
            switch result {
            case let .success(response):
                do {
                    let json = try JSON(response.filterSuccessfulStatusCodes().mapJSON())
                    successCallback(json)
                }
                catch let error {
                    errorCallback((error as! MoyaError).response!.statusCode)
                }
            case let .failure(error):
                failureCallback(error)
            }
        }
    }
}
