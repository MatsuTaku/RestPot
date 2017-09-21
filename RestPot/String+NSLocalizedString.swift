//
//  String+NSLocalizedString.swift
//  RestPot
//
//  Created by 松本拓真 on 2017/08/11.
//  Copyright © 2017年 TakumaMatsumoto. All rights reserved.
//

import Foundation

extension String {
    
    var localized: String {
        return NSLocalizedString(self, comment: self)
    }
    
    func localized(tableName: String?, bundle: Bundle, value: String, comment: String) -> String {
        return NSLocalizedString(self, tableName: tableName, bundle: bundle, value: value, comment: comment)
    }
    
}
