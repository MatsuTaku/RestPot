//
//  UITableViewCell+Identifier.swift
//  RestPot
//
//  Created by 松本拓真 on 2017/08/11.
//  Copyright © 2017年 TakumaMatsumoto. All rights reserved.
//

import Foundation
import UIKit

extension UITableViewCell {
    
    var identifier: String {
        return String(describing: self)
    }
    
}
