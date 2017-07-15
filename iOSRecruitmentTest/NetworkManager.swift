//
//  NetworkManager.swift
//  iOSRecruitmentTest
//
//  Created by Developer on 14.07.17.
//  Copyright © 2017 Snowdog. All rights reserved.
//

import Alamofire
import AlamofireObjectMapper


class NetworkManager {
    static func getItems(successCallback: @escaping ((_ resp: [ItemModelResponse]?) -> Void), errorCallback: @escaping ((_ error: Error) -> Void)) {
        
        Alamofire.request(Constants.url_address + "items", method: .get, parameters: nil, headers: nil).responseArray(completionHandler: { (response: DataResponse<[ItemModelResponse]>) in
            if let error = response.error {
                errorCallback(error)
            } else {
                successCallback(response.result.value)
            }
        })
    }
}

