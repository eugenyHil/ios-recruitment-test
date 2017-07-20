//
//  TableViewCell.swift
//  iOSRecruitmentTest
//
//  Created by Bazyli Zygan on 15.06.2016.
//  Copyright © 2016 Snowdog. All rights reserved.
//

import UIKit
import SDWebImage


class TableViewCell: UITableViewCell {
    fileprivate let defaultTitleText = "Test"
    fileprivate let defaultDescriptionText = "Some description"
    fileprivate let defaultIconCornerRadius: CGFloat = 4
    
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var itemTitleLabel: UILabel!
    @IBOutlet weak var itemDescLabel: UILabel!
    
    var item: ItemModel? {
        didSet {
            if item == nil {
                iconView.image = nil
                itemTitleLabel.text = defaultTitleText
                itemDescLabel.text = defaultDescriptionText
            } else {
                itemTitleLabel.text = item?.name
                itemDescLabel.text = item?.modelDescription
                
                if let imagePath = item?.icon,
                    let imageUrl = URL(string: imagePath) {
                    iconView.sd_setImage(with: imageUrl)
                }
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        iconView.layer.cornerRadius = defaultIconCornerRadius
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.item = nil
    }
}
