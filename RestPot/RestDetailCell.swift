//
//  RestDetailCell.swift
//  RestPot
//
//  Created by 松本拓真 on 2017/02/11.
//  Copyright © 2017年 TakumaMatsumoto. All rights reserved.
//

import UIKit
import SwiftyJSON

class RestDetailCell: UITableViewCell {
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var detail: UILabel!
    
    var restDetail: RestDetail?
    
    var isCallNumber = false

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupCell(withTitle title: String?, detail: String?) {
        
        self.title.text = title
        self.detail.text = detail
        if title == NSLocalizedString("電話番号", comment: "Used to calling on phone app") {
            isCallNumber = true
            self.detail.textColor = UIColor(red: 0, green: 0.5, blue: 1, alpha: 1)
        } else {
            isCallNumber = false
            self.detail.textColor = UIColor.darkText
        }
    }

}
