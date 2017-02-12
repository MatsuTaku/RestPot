//
//  RestListViewCell.swift
//  RestPot
//
//  Created by 松本拓真 on 2017/02/08.
//  Copyright © 2017年 TakumaMatsumoto. All rights reserved.
//

import UIKit
import AlamofireImage

class RestListViewCell: UITableViewCell {
    
    @IBOutlet weak var thumbnailBack: UIImageView!
    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var category: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var access: UILabel!
    @IBOutlet weak var profile: UILabel!
    @IBOutlet weak var profileMarginTop: NSLayoutConstraint!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupCell(_ rest: Restaulant) {
        
        if let str = rest.shopImageURL1 {
            thumbnail.af_setImage(withURL: URL(string: str)!, placeholderImage: #imageLiteral(resourceName: "noimage"))
            thumbnailBack.af_setImage(withURL: URL(string: str)!, placeholderImage: #imageLiteral(resourceName: "noimage"))
        } else {
            thumbnail.image = #imageLiteral(resourceName: "noimage")
            thumbnailBack.image = #imageLiteral(resourceName: "noimage")
        }
        category.text = rest.category
        name.text = rest.name
        access.text = rest.accessText()
        profile.text = rest.prShort
        profileMarginTop.constant = rest.prShort != nil ? 8 : 0
        profile.layoutIfNeeded()
    }

}
