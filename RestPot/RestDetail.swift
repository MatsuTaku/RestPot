//
//  RestDetail.swift
//  RestPot
//
//  Created by 松本拓真 on 2017/02/25.
//  Copyright © 2017年 TakumaMatsumoto. All rights reserved.
//

import Foundation

class RestDetail {
    
    var title: String
    var detail: String
    var isCallNumber = false
    
    init?(title: RestDetailTitle, detail: String?) {
        self.title = title.get()
        if detail == nil { return nil }
        self.detail = detail!
        if title == .callNumber {
            isCallNumber = true
        }
    }
    
}

enum RestDetailTitle {
    case access
    case callNumber
    case budget
    case lunch
    case party
    case openTime
    case holiday
    case address
    
    func get() -> String {
        switch self {
        case .access: return NSLocalizedString("access", comment: "")
        case .callNumber: return NSLocalizedString("callNumber", comment: "Used to calling on phone app")
        case .budget: return NSLocalizedString("budget", comment: "")
        case .lunch: return NSLocalizedString("lunch", comment: "")
        case .party: return NSLocalizedString("party", comment: "")
        case .openTime: return NSLocalizedString("openTime", comment: "")
        case .holiday: return NSLocalizedString("holiday", comment: "")
        case .address: return NSLocalizedString("address", comment: "")
        }
    }
}
 
