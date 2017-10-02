//
//  UIViewController+SVProgressHUD.swift
//  RestPot
//
//  Created by 松本拓真 on 2017/02/25.
//  Copyright © 2017年 TakumaMatsumoto. All rights reserved.
//

import Foundation
import SVProgressHUD

extension UIViewController {
    
    func showHUD() {
        SVProgressHUD.show()
    }
    
    func showHUD(withStatus status: String) {
        SVProgressHUD.show(withStatus: status)
    }
    
    func hideHUD() {
        SVProgressHUD.dismiss()
    }
    
}
