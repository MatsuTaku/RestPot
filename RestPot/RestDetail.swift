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
    var isCallNumber: Bool = false
    
    init?(title: RestDetailTitle, detail: String?) {
        self.title = title.text
        if detail == nil { return nil }
        self.detail = detail!
        isCallNumber = title == .callNumber
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
        case .access: return "access".localized
        case .callNumber: return "callNumber".localized
        case .budget: return "budget".localized
        case .lunch: return "lunch".localized
        case .party: return "party".localized
        case .openTime: return "openTime".localized
        case .holiday: return "holiday".localized
        case .address: return "address".localized
        }
    }
}

extension RestDetail: TableData {
    
}
 
