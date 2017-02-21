//
//  RestTitleCell.swift
//  RestPot
//
//  Created by 松本拓真 on 2017/02/11.
//  Copyright © 2017年 TakumaMatsumoto. All rights reserved.
//

import UIKit
import SwiftyJSON

class RestTitleCell: UITableViewCell {
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var furigana: UILabel!
    @IBOutlet weak var category: UILabel!
    @IBOutlet weak var imageHeight: NSLayoutConstraint!
    
    @IBOutlet weak var firstImage: UIImageView!
    @IBOutlet weak var firstImageWidth: NSLayoutConstraint!
    @IBOutlet weak var secondImage: UIImageView!
    @IBOutlet weak var secondImageWidth: NSLayoutConstraint!
    @IBOutlet weak var prShort: UILabel!
    @IBOutlet weak var prShortTop: NSLayoutConstraint!
    @IBOutlet weak var prLong: UILabel!
    @IBOutlet weak var prLongTop: NSLayoutConstraint!
    @IBOutlet weak var prLongBottom: NSLayoutConstraint!
    
    var imageAspect: CGFloat = 4/3
    var imageAspectRev: CGFloat {
        get{ return 1/imageAspect }
        set(a){ imageAspect = 1/a }
    }
    
    enum ImageIndex {
        case First
        case Second
    }
    var mainImageIndex: ImageIndex = .First

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupCell(rest: Restaulant) {
        name.text = rest.name
        furigana.text = rest.nameKana
        category.text = rest.category
        if let url1 = rest.shopImageURL1 {
            firstImage.af_setImage(withURL: URL(string: url1)!, placeholderImage: #imageLiteral(resourceName: "noimage"))
        } else {
            firstImage.image = #imageLiteral(resourceName: "noimage")
        }
        if let url2 = rest.shopImageURL2 {
            secondImage.af_setImage(withURL: URL(string: url2)!, placeholderImage: #imageLiteral(resourceName: "noimage"))
        } else {
            secondImage.image = #imageLiteral(resourceName: "noimage")
        }
        mainImage(atIndex: .First)
        prShort.text = rest.prShort
        prShortTop.constant = rest.prShort != nil ? 8 : 0
        prLong.text = rest.prLong
        prLongTop.constant = rest.prLong != nil ? 8 : 0
        prLongBottom.constant = rest.prLong != nil ? 15 : 0
    }
    
    func mainImage(atIndex index: ImageIndex) {
        if mainImageIndex == index { return }
        mainImageIndex = index
        let height = (UIScreen.main.bounds.width - (8*3)) * imageAspectRev / (1 + pow(imageAspectRev, 2))
        self.imageHeight.constant = height
        self.firstImageWidth.constant = height * (index == .First ? imageAspect : imageAspectRev)
        self.secondImageWidth.constant = height * (index == .Second ? imageAspectRev : imageAspect)
        UIView.animate(withDuration: 0.4, animations: {
            self.firstImage.superview?.layoutIfNeeded()
            self.firstImage.layoutIfNeeded()
            self.secondImage.layoutIfNeeded()
        })
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        touches.forEach { touch in
            if touch.view == firstImage {
                mainImage(atIndex: .First)
            }
            if touch.view == secondImage {
                mainImage(atIndex: .Second)
            }
        }
    }

}
