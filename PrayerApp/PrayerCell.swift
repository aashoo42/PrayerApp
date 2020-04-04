//
//  PrayerCell.swift
//  PrayerApp
//
//  Created by mac on 4/4/20.
//  Copyright © 2020 mac. All rights reserved.
//

import UIKit

class PrayerCell: UITableViewCell {

    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var notificationBtn: UIButton!
    
    @IBOutlet weak var innerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        innerView.layer.cornerRadius = 10.0
        innerView.layer.shadowColor = UIColor.black.cgColor
        innerView.layer.shadowRadius = 3.0
        innerView.layer.shadowOpacity = 0.3
        innerView.layer.shadowOffset = CGSize(width: 0, height: 0)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
