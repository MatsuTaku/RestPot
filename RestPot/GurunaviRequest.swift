//
//  GurunaviRequest.swift
//  RestPot
//
//  Created by 松本拓真 on 2017/02/08.
//  Copyright © 2017年 TakumaMatsumoto. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class GurunaviRequest {
    static let keyid = "b8a9db8671d351cea9b91710d5788be4"
    let gurunaviURL = "https://api.gnavi.co.jp/RestSearchAPI/20150630/"
    var request: DataRequest?
    
    func post(_ params: GurunaviRequestParams, completionHandler: @escaping (GurunaviResponseParams) -> Void) {
        print(params)
        request = Alamofire.request(gurunaviURL, method: .get, parameters: params.params)
            .responseJSON { response in
                switch response.result {
                case .success:
                    if let data = response.data {
                        completionHandler(GurunaviResponseParams(withData: data))
                    }
                    break
                case .failure(let error):
                    print(error)
                    break
                }
        }
    }
    
    func cancel() {
        request?.cancel()
    }
}

class GurunaviRequestParams {
    
    private let keyid = "b8a9db8671d351cea9b91710d5788be4"
    private let format = "json"
    
    var params: [String: Any] = [:]
    
    init() {
        params["keyid"] = keyid
        params["format"] = format
    }
    
    func location(latitude: Double, longitude: Double) {
        params["latitude"] = latitude
        params["longitude"] = longitude
    }
    
    func range(_ range: Int) {
        params["range"] = range
    }
    
    func offsetPage(_ page: Int) {
        params["offset_page"] = page
    }
    
}

class GurunaviResponseParams {
    
    var totalHitCount: Int?
    var hitPerPage: Int?
    var pageOffset: Int?
    var rests: [Restaulant]?
    
    init(withData data: Data) {
        let json = JSON(data)
        print(json)
        rests = json["rest"].map { (_, json) in Restaulant(json) }
        // For some reason, JSON.int return nil value
        totalHitCount = formatInt(fromString: json["total_hit_count"].string)
        pageOffset = formatInt(fromString: json["page_offset"].string)
        hitPerPage = formatInt(fromString: json["hit_per_page"].string)
    }
    
    private func formatInt(fromString string: String?) -> Int? {
        if string == nil {
            return nil
        } else {
            return Int(string!)
        }
    }
    
}
