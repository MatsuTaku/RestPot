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
    
    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var category: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var access: UILabel!

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
            let thumbURL = URL(string: str)!
            thumbnail.af_setImage(withURL: thumbURL, placeholderImage: nil)
        }
        category.text = rest.category
        name.text = rest.name
        let accesses: [String?] = [rest.accessLine,
                                  rest.accessStation,
                                  rest.accessStationExit,
                                  rest.accessWalk,
                                  rest.accessNote
        ]
        access.text = (accesses.filter{ $0 != nil } as! [String]).joined(separator: " ")
    }

}
