//
//  FeedTableViewCell.swift
//  Wander
//
//  Created by IOS on 4/12/18.
//  Copyright © 2018 IOS. All rights reserved.
//

import UIKit

class FeedTableViewCell: UITableViewCell {

    @IBOutlet var imgView: UIImageView!
    @IBOutlet var lblName: UILabel!
    @IBOutlet var lblDateTime: UILabel!
    @IBOutlet var lblAddress: UILabel!
    @IBOutlet var btnAddCalendar: UIButton!
    @IBOutlet var lblAddCalendar: UILabel!
    @IBOutlet var btnBookmark: UIButton!
    @IBOutlet var lblBookmark: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
