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
    
    let url = "https://api.gnavi.co.jp/RestSearchAPI/20150630/"
    var request: DataRequest?
    
    func post(_ params: GurunaviRequestParams, completionHandler: @escaping (GurunaviResponseParams) -> Void) {
        request = Alamofire.request(url, method: .get, parameters: params.params)
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
    
    var range: Int {
        get {
            return params["range"] as! Int
        }
        set {
            params["range"] = newValue
        }
    }
    
    var offsetPage: Int {
        get {
            return params["offset_page"] as! Int
        }
        set {
            params["offset_page"] = newValue
        }
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
        let jsonRest = json["rest"]
        if let rest = Restaulant(jsonRest) {
            rests = [rest]
        } else {
            rests = jsonRest.flatMap {(_, json) in Restaulant(json)}
        }
        // For some reason, JSON.int return nil value
        totalHitCount = formatInt(from: json["total_hit_count"].string)
        pageOffset = formatInt(from: json["page_offset"].string)
        hitPerPage = formatInt(from: json["hit_per_page"].string)
    }
    
    func formatInt(from string: String?) -> Int? {
        return string != nil ? Int(string!) : nil
    }
    
}
