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
    
    func showIndicator() {
        SVProgressHUD.show()
    }
    
    func showIndicator(with status: String) {
        SVProgressHUD.show(withStatus: status)
    }
    
    func hideIndicator() {
        SVProgressHUD.dismiss()
    }
    
}
