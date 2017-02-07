//
//  GurunaviRequest.swift
//  RestPot
//
//  Created by 松本拓真 on 2017/02/08.
//  Copyright © 2017年 TakumaMatsumoto. All rights reserved.
//

import Foundation

class GurunaviRequest {
    let session: URLSession = URLSession.shared
    let gurunaviUrl = URL(string: "https://api.gnavi.co.jp/RestSearchAPI/20150630/")
    static let keyid = "b8a9db8671d351cea9b91710d5788be4"
    
    func get(_ params: [String: Any], completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        var request: URLRequest = URLRequest(url: gurunaviUrl!)
        
        request.httpMethod = "GET"
        request.httpBody = try! JSONSerialization.data(withJSONObject: params, options: [])
        session.dataTask(with: request, completionHandler: completionHandler).resume()
    }
}
