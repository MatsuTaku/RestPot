//
//  UIViewController+showAlertView.swift
//  RestPot
//
//  Created by 松本拓真 on 2017/02/25.
//  Copyright © 2017年 TakumaMatsumoto. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    func showAlert(withTitle title: String, button: String = NSLocalizedString("OK", comment: "")) {
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        let ok = UIAlertAction(title: button, style: .default, handler: nil)
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
    
}
