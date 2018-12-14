//
//  ProfileBookedTableViewCell.swift
//  Wander
//
//  Created by IOS on 4/4/18.
//  Copyright © 2018 IOS. All rights reserved.
//

import UIKit

class ProfileBookedTableViewCell: UITableViewCell {

    @IBOutlet var imgVw: UIImageView!
    @IBOutlet var lblName: UILabel!
    @IBOutlet var lblDateTime: UILabel!
    @IBOutlet var lblAddress: UILabel!
    @IBOutlet var btnAddCalendar: UIButton!
    @IBOutlet var lblAddCalendar: UILabel!
    @IBOutlet var btnBookmark: UIButton!
    @IBOutlet var lblBookmark: UILabel!
    @IBOutlet var btnItinerary: UIButton!
    @IBOutlet var btnCancel: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        btnItinerary.applyBorder(color: COLOR_THEME_BLUE)
        btnCancel.applyBorder(color: COLOR_THEME_BLUE)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
