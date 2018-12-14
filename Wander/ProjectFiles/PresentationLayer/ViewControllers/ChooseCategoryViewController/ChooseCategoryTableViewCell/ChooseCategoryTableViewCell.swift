//
//  ChooseCategoryTableViewCell.swift
//  Wander
//
//  Created by IOS on 04/12/17.
//  Copyright © 2017 IOS. All rights reserved.
//

import UIKit

enum ChooseCategoryTableViewCellButton {
    case First
    case Last
}

protocol ChooseCategoryTableViewCellDelegate {
    func chooseCategoryTableViewCellButtonTapped(_ sender: UIButton, type: ChooseCategoryTableViewCellButton)
}

class ChooseCategoryTableViewCell: UITableViewCell {

    @IBOutlet var btnFirst: UIButton!
    @IBOutlet var btnSecond: UIButton!
    @IBOutlet var imgFirst: UIImageView!
    @IBOutlet var imgSecond: UIImageView!
    
    var delegate: ChooseCategoryTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        btnFirst.addTarget(self, action: #selector(btnDidStartHighlight(_:)), for: [.touchDown])
        btnFirst.addTarget(self, action: #selector(btnDidEndHighlight(_:)), for: [.touchDragExit, .touchUpInside, .touchUpOutside, .touchCancel])
        btnSecond.addTarget(self, action: #selector(btnDidStartHighlight(_:)), for: [.touchDown])
        btnSecond.addTarget(self, action: #selector(btnDidEndHighlight(_:)), for: [.touchDragExit, .touchUpInside, .touchUpOutside, .touchCancel])
        
        btnFirst.applyBorderAndShadow(color: COLOR_THEME_BLUE)
        btnSecond.applyBorderAndShadow(color: COLOR_THEME_BLUE)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    //MARK: -  Button Actions -
    
    @IBAction func btnFirstDidTapped(_ sender: Any) {
        delegate?.chooseCategoryTableViewCellButtonTapped(sender as! UIButton, type: .First)
    }

    @IBAction func btnSecondDidTapped(_ sender: Any) {
        delegate?.chooseCategoryTableViewCellButtonTapped(sender as! UIButton, type: .Last)
    }
    
    @objc func btnDidStartHighlight(_ sender: Any) {
        let button = sender as! UIButton
        //top left botto right
//        button.imageEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, 80.0)
        button.clipsToBounds = true
        //button.removeBorder()
    }
    
    @objc func btnDidEndHighlight(_ sender: Any) {
        let button = sender as! UIButton
        button.applyBorderAndShadow(color: COLOR_THEME_BLUE)
        button.isSelected = !button.isSelected
    }
}
