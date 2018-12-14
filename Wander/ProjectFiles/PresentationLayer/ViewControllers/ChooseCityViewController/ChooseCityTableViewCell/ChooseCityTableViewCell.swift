//
//  ChooseCityTableViewCell.swift
//  Wander
//
//  Created by IOS on 04/12/17.
//  Copyright © 2017 IOS. All rights reserved.
//

import UIKit

protocol ChooseCityTableViewCellDelegate {
    func chooseCityTableViewCellCityNameButtonTapped(_ sender: UIButton)
}

class ChooseCityTableViewCell: UITableViewCell {

    @IBOutlet var btnCityName: UIButton!
    var delegate: ChooseCityTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        btnCityName.addTarget(self, action: #selector(btnDidStartHighlight(_:)), for: [.touchDown])
        btnCityName.addTarget(self, action: #selector(btnDidEndHighlight(_:)), for: [.touchDragExit, .touchUpInside, .touchUpOutside, .touchCancel])
        btnCityName.applyBorderAndShadow(color: COLOR_THEME_BLUE)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func btnCityNameDidTapped(_ sender: Any) {
        delegate?.chooseCityTableViewCellCityNameButtonTapped(sender as! UIButton)
    }
    
    @objc func btnDidStartHighlight(_ sender: Any) {
        let button = sender as! UIButton
        button.clipsToBounds = true
        button.removeBorder()
    }
    
    @objc func btnDidEndHighlight(_ sender: Any) {
        let button = sender as! UIButton
        button.applyBorderAndShadow(color: COLOR_THEME_BLUE)
    }
}
