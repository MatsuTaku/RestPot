//
//  GurunaviRequest.swift
//  RestPot
//
//  Created by 松本拓真 on 2017/02/08.
//  Copyright © 2017年 TakumaMatsumoto. All rights reserved.
//

import Foundation
import Alamofire

class GurunaviRequest {
    static let keyid = "b8a9db8671d351cea9b91710d5788be4"
    let gurunaviURL = "https://api.gnavi.co.jp/RestSearchAPI/20150630/"
    
    func post(_ params: [String: Any], completionHandler: @escaping (DataResponse<Any>) -> Void) {
        print(params)
        Alamofire.request(gurunaviURL, method: .get, parameters: params).responseJSON(completionHandler: completionHandler)
    }
}
