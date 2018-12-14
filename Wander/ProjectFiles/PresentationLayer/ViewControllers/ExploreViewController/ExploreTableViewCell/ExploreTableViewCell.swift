//
//  ExploreTableViewCell.swift
//  Wander
//
//  Created by IOS on 3/30/18.
//  Copyright © 2018 IOS. All rights reserved.
//

import UIKit

enum ExploreTableViewCellButton {
    case First
    case Last
}

protocol ExploreTableViewCellDelegate {
    func exploreTableViewCellButtonTapped(_ sender: UIButton, type: ExploreTableViewCellButton)
}

class ExploreTableViewCell: UITableViewCell {

    @IBOutlet var btnFirst: UIButton!
    @IBOutlet var btnSecond: UIButton!
    @IBOutlet var imgFirst: UIImageView!
    @IBOutlet var imgSecond: UIImageView!
    
    var delegate: ExploreTableViewCellDelegate?
    
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
    
    //MARK: -  Button Actions
    
    @IBAction func btnFirstDidTapped(_ sender: Any) {
        delegate?.exploreTableViewCellButtonTapped(sender as! UIButton, type: .First)
    }
    
    @IBAction func btnSecondDidTapped(_ sender: Any) {
        delegate?.exploreTableViewCellButtonTapped(sender as! UIButton, type: .Last)
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
