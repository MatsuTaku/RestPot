//
//  AppIconWhiteImageView.swift
//  RestPot
//
//  Created by 松本拓真 on 2017/02/12.
//  Copyright © 2017年 TakumaMatsumoto. All rights reserved.
//

import UIKit

class AppIconWhiteImageView: UIImageView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
     */
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initSelf()
    }
    
    func initSelf() {
        self.image = #imageLiteral(resourceName: "appIconWhite")
        self.contentMode = .scaleAspectFit
    }
    
    static func setNavigationTitle(to navigationItem: UINavigationItem) {
        navigationItem.titleView = AppIconWhiteImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
    }
    
}
