//
//  RestDetail.swift
//  RestPot
//
//  Created by 松本拓真 on 2017/02/25.
//  Copyright © 2017年 TakumaMatsumoto. All rights reserved.
//

import Foundation

class RestDetail {
    
    var type: RestDetailTitle
    var title: String {
        return self.type.text
    }
    var detail: String
    
    init?(title: RestDetailTitle, detail: String?) {
        self.type = title
        if detail == nil { return nil }
        self.detail = detail!
    }
    
    var isCallNumber: Bool {
        return type == .callNumber
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
    
    var text: String {
        switch self {
        case .access: return LocalizedString.access
        case .callNumber: return LocalizedString.callNumber
        case .budget: return LocalizedString.budget
        case .lunch: return LocalizedString.lunch
        case .party: return LocalizedString.party
        case .openTime: return LocalizedString.openTime
        case .holiday: return LocalizedString.holiday
        case .address: return LocalizedString.address
        }
    }
}

extension RestDetail: TableData {
    
}
 
