//
//  Restaulant.swift
//  RestPot
//
//  Created by 松本拓真 on 2017/02/08.
//  Copyright © 2017年 TakumaMatsumoto. All rights reserved.
//

import Foundation
import SwiftyJSON

class Restaulant {
    
    var id: String?
    var name: String?
    var nameKana: String?
    var category: String?
    var url: String?
    var urlMobile: String?
    var couponURLPC: String?
    var couponURLMobile: String?
    var shopImageURL1: String?
    var shopImageURL2: String?
    var address: String?
    var tel: String?
    var telSub: String?
    var opentime: String?
    var holiday: String?
    var accessLine: String?
    var accessStation: String?
    var accessStationExit: String?
    var accessWalk: String?
    var accessNote: String?
    var budget: Int?
    var party: Int?
    var lunch: Int?
    
    init(_ json: JSON) {
        id = json["id"].string
        name = json["name"].string
        nameKana = json["name_kana"].string
        category = json["category"].string
        url = json["url"].string
        urlMobile = json["url_mobile"].string
        guard let couponURL = json["coupon_url"] as JSON? else { abort() }
        couponURLPC = couponURL["pc"].string
        couponURLMobile = couponURL["mobile"].string
        guard let imageURL = json["image_url"] as JSON? else { abort() }
        shopImageURL1 = imageURL["shop_image1"].string
        shopImageURL2 = imageURL["shop_image2"].string
        address = json["address"].string
        tel = json["tel"].string
        telSub = json["tel_sub"].string
        opentime = json["opentime"].string
        holiday = json["holiday"].string
        guard let access = json["access"] as JSON? else { abort() }
        accessLine = access["line"].string
        accessStation = access["station"].string
        accessStationExit = access["station_exit"].string
        accessWalk = access["walk"].string
        accessNote = access["note"].string
        budget = json["budget"].int
        party = json["party"].int
        lunch = json["lunch"].int
    }
    
}
