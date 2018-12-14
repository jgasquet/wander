//
//  NearbyRestTableViewCell.swift
//  Wander
//
//  Created by IOS on 4/18/18.
//  Copyright © 2018 IOS. All rights reserved.
//

import UIKit

class NearbyRestTableViewCell: UITableViewCell {

    @IBOutlet var vwGradient: UIView!
    @IBOutlet var imgVw: UIImageView!
    @IBOutlet var lblName: UILabel!
    @IBOutlet var lblHashtag1: UILabel!
    @IBOutlet var lblHashtag2: UILabel!
    @IBOutlet var lblAddress1: UILabel!
    @IBOutlet var lblAddress2: UILabel!
    @IBOutlet var lblDistance: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
