//
//  CalendarTableViewCell.swift
//  Wander
//
//  Created by IOS on 4/12/18.
//  Copyright © 2018 IOS. All rights reserved.
//

import UIKit

class CalendarTableViewCell: UITableViewCell {

    @IBOutlet var lblTime: UILabel!
    @IBOutlet var lblName: UILabel!
    @IBOutlet var lblAdrs: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
