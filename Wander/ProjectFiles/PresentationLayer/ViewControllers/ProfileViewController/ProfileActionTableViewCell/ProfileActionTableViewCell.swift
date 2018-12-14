//
//  ProfileActionTableViewCell.swift
//  Wander
//
//  Created by IOS on 4/4/18.
//  Copyright © 2018 IOS. All rights reserved.
//

import UIKit

class ProfileActionTableViewCell: UITableViewCell {

    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lblDesc: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
