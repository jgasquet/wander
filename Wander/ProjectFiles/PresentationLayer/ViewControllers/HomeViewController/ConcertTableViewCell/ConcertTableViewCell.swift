//
//  ConcertTableViewCell.swift
//  Wander
//
//  Created by IOS on 01/01/18.
//  Copyright © 2018 IOS. All rights reserved.
//

import UIKit

enum ConcertTableViewCellButton {
    case Details
    case ConcertBlue
    case ConcertWhite
    case Bookmark
    case Share
    case Calendar
    case TagFirst
    case TagSecond
}

protocol ConcertTableViewCellDelegate {
    func concertTableViewCellButtonTapped(_ sender: UIButton, type: ConcertTableViewCellButton)
}

class ConcertTableViewCell: UITableViewCell {
    
    @IBOutlet var vwMain: UIView!
    @IBOutlet var imgVwBG: UIImageView!
    @IBOutlet var lblName: UILabel!
    @IBOutlet var lblDateTime: UILabel!
    @IBOutlet var lblAddress: UILabel!
    @IBOutlet var btnDetails: UIButton!
    @IBOutlet var vwMultipleBtn: UIView!
    @IBOutlet var btnConcertBlue: UIButton!
    @IBOutlet var btnConcertWhite: UIButton!
    @IBOutlet var btnBookmark: UIButton!
    @IBOutlet var btnShare: UIButton!
    @IBOutlet var btnCalendar: UIButton!
    @IBOutlet var btnTagFirst: UIButton!
    @IBOutlet var btnTagSecond: UIButton!
    @IBOutlet var vwBookmarkBG: UIView!
    @IBOutlet var vwShareBG: UIView!
    @IBOutlet var vwCalendarBG: UIView!
    
    var delegate: ConcertTableViewCellDelegate?
    var completionHandler: ((UIView) -> ())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        /*let swipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeActionFired(sender:)))
        swipe.direction = .left
        swipe.numberOfTouchesRequired = 1
        vwMain.addGestureRecognizer(swipe)*/
        
        vwMultipleBtn.isHidden = true
        
        btnDetails.addTarget(self, action: #selector(btnDetailsAction(_:)), for: .touchUpInside)
        btnConcertBlue.addTarget(self, action: #selector(btnConcertBlueAction(_:)), for: .touchUpInside)
        btnConcertWhite.addTarget(self, action: #selector(btnConcertWhiteAction(_:)), for: .touchUpInside)
        btnBookmark.addTarget(self, action: #selector(btnBookmarkAction(_:)), for: .touchUpInside)
        btnShare.addTarget(self, action: #selector(btnShareAction(_:)), for: .touchUpInside)
        btnCalendar.addTarget(self, action: #selector(btnCalendarAction(_:)), for: .touchUpInside)
        btnTagFirst.addTarget(self, action: #selector(btnTagFirstAction(_:)), for: .touchUpInside)
        btnTagSecond.addTarget(self, action: #selector(btnTagSecondAction(_:)), for: .touchUpInside)
        
        vwBookmarkBG.layer.cornerRadius = vwBookmarkBG.frame.size.width/2.0
        vwShareBG.layer.cornerRadius = vwShareBG.frame.size.width/2.0
        vwCalendarBG.layer.cornerRadius = vwCalendarBG.frame.size.width/2.0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @objc func swipeActionFired(sender: UIGestureRecognizer) {
        completionHandler!(sender.view!)
    }
    
    @objc func btnDetailsAction(_ sender: Any) {
        delegate?.concertTableViewCellButtonTapped(sender as! UIButton, type: .Details)
    }
    
    @objc func btnConcertBlueAction(_ sender: Any) {
        delegate?.concertTableViewCellButtonTapped(sender as! UIButton, type: .ConcertBlue)
    }
    
    @objc func btnConcertWhiteAction(_ sender: Any) {
        delegate?.concertTableViewCellButtonTapped(sender as! UIButton, type: .ConcertWhite)
    }
    
    @objc func btnBookmarkAction(_ sender: Any) {
        delegate?.concertTableViewCellButtonTapped(sender as! UIButton, type: .Bookmark)
    }
    
    @objc func btnShareAction(_ sender: Any) {
        delegate?.concertTableViewCellButtonTapped(sender as! UIButton, type: .Share)
    }
    
    @objc func btnCalendarAction(_ sender: Any) {
        delegate?.concertTableViewCellButtonTapped(sender as! UIButton, type: .Calendar)
    }
    
    @objc func btnTagFirstAction(_ sender: Any) {
        delegate?.concertTableViewCellButtonTapped(sender as! UIButton, type: .TagFirst)
    }
    
    @objc func btnTagSecondAction(_ sender: Any) {
        delegate?.concertTableViewCellButtonTapped(sender as! UIButton, type: .TagSecond)
    }
}
