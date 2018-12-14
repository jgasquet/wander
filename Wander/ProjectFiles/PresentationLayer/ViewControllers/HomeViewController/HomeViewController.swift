//
//  HomeViewController.swift
//  Wander
//
//  Created by IOS on 09/12/17.
//  Copyright © 2017 IOS. All rights reserved.
//

import UIKit
import SDWebImage

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, ConcertTableViewCellDelegate {

    @IBOutlet var tblConcertList: UITableView!
    
    var eventsArray: [[String: Any]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        tblConcertList.reloadData()
        EventList()
    }
    
    //MARK: - UITableViewDataSource -
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ConcertCell") as! ConcertTableViewCell
        cell.delegate = self
        cell.vwMain.tag = indexPath.row
        //cell.imgVwBG.sd_setImage(with: URL(string: BASE_IMAGE_PATH + tempImagesArray[indexPath.row % 4]), placeholderImage: #imageLiteral(resourceName: "Default"), completed: nil)
        let dict: [String: Any] = eventsArray[indexPath.row]
        if let name: String = dict["name"] as? String {
            cell.lblName.text = name
        }
        if let img: String = dict["baseImage"] as? String {
            cell.imgVwBG.sd_setImage(with: URL(string: BASE_IMAGE_PATH + img), placeholderImage: #imageLiteral(resourceName: "Default"), completed: nil)
        }
        if let startDate: String = dict["startDate"] as? String, let startTime: String = dict["startTime"] as? String {
            cell.lblDateTime.text = "\(startDate) \(startTime)"
        }
        if let venue: String = dict["venue"] as? String, let location: String = dict["location"] as? String {
            cell.lblAddress.text = "\(venue) - \(location)"
        }
        if let isAddedToCalendar: Int = Int((dict["addedTocalendar"] as? String)!) {
            isAddedToCalendar == 1 ? (cell.vwCalendarBG.isHidden = false) : (cell.vwCalendarBG.isHidden = true)
        }
        cell.vwShareBG.isHidden = true
        if let isBookmarked: Int = Int((dict["bookmark"] as? String)!) {
            isBookmarked == 1 ? (cell.vwBookmarkBG.isHidden = false) : (cell.vwBookmarkBG.isHidden = true)
        }
        if let tagsArray: [[String: Any]] = dict["tags"] as? [[String: Any]] {
            cell.btnTagFirst.isHidden = true
            cell.btnTagSecond.isHidden = true
            cell.btnTagFirst.titleLabel?.text = ""
            cell.btnTagSecond.titleLabel?.text = ""
            if tagsArray.count >= 2 {
                cell.btnTagFirst.isHidden = false
                cell.btnTagSecond.isHidden = false
                let firstTag: String = tagsArray[0]["tag"] as! String
                cell.btnTagFirst.titleLabel?.text = "#\(firstTag.lowercased())"
                let secondTag: String = tagsArray[1]["tag"] as! String
                cell.btnTagSecond.titleLabel?.text = "#\(secondTag.lowercased())"
            }
            else if tagsArray.count == 1 {
                cell.btnTagFirst.isHidden = false
                let firstTag: String = tagsArray[0]["tag"] as! String
                cell.btnTagFirst.titleLabel?.text = "#\(firstTag.lowercased())"
            }
        }
        return cell
    }
    
    //MARK: - UITableViewDelegate -
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tblConcertList.frame.size.height
    }
    
    //MARK: - ExploreTableViewCellDelegate
    
    func concertTableViewCellButtonTapped(_ sender: UIButton, type: ConcertTableViewCellButton) {
        if let cell = sender.superview?.superview?.superview?.superview as? ConcertTableViewCell {
            switch type {
            case .Details:
                let dict: [String: Any] = eventsArray[cell.vwMain.tag]
                if let eventId: Int = Int((dict["eventId"] as? String)!) {
                    let vc: EventDetailsViewController = storyboard?.instantiateViewController(withIdentifier: "EventDetailsViewController") as! EventDetailsViewController
                    vc.eventId = eventId
                    if let img: String = dict["baseImage"] as? String {
                        vc.baseImage = img
                    }
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                break
            case .ConcertBlue:
                cell.vwMultipleBtn.isHidden = false
                cell.btnConcertBlue.isHidden = true
                break
            case .ConcertWhite:
                cell.vwMultipleBtn.isHidden = true
                cell.btnConcertBlue.isHidden = false
                break
            case .Bookmark:
                let dict: [String: Any] = eventsArray[cell.vwMain.tag]
                if let eventId: Int = Int((dict["eventId"] as? String)!), let status: Int = Int((dict["bookmark"] as? String)!) {
                    self.BookmarkEvent(eventId: eventId, status: status)
                }
                break
            case .Share:
                print("SHARE")
                /*let text = "This is some text that I want to share."
                let textToShare = [text]
                let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
                activityViewController.popoverPresentationController?.sourceView = self.view
                activityViewController.excludedActivityTypes = [UIActivityType.airDrop, UIActivityType.postToFacebook]
                self.present(activityViewController, animated: true, completion: nil)*/
                break
            case .Calendar:
                let dict: [String: Any] = eventsArray[cell.vwMain.tag]
                if let eventId: Int = Int((dict["eventId"] as? String)!), let status: Int = Int((dict["addedTocalendar"] as? String)!) {
                    self.AddEventToCalendar(eventId: eventId, status: status)
                }
                break
            case .TagFirst:
                /*let dict: [String: Any] = eventsArray[cell.vwMain.tag]
                let vc = storyboard?.instantiateViewController(withIdentifier: "SubCategoryViewController") as! SubCategoryViewController
                vc.strTitle = (cell.btnTagFirst?.titleLabel?.text)!
                if let tagsArray: [[String: Any]] = dict["tags"] as? [[String: Any]] {
                    if tagsArray.count >= 1 {
                        vc.tagID = Int((tagsArray[0]["id"] as? String)!)!
                    }
                }
                navigationController?.pushViewController(vc, animated: true)*/
                break
            case .TagSecond:
                /*let dict: [String: Any] = eventsArray[cell.vwMain.tag]
                let vc = storyboard?.instantiateViewController(withIdentifier: "SubCategoryViewController") as! SubCategoryViewController
                vc.strTitle = (cell.btnTagSecond?.titleLabel?.text)!
                if let tagsArray: [[String: Any]] = dict["tags"] as? [[String: Any]] {
                    if tagsArray.count >= 2 {
                        vc.tagID = Int((tagsArray[1]["id"] as? String)!)!
                    }
                }
                navigationController?.pushViewController(vc, animated: true)*/
                break
            }
        }
        else if let cell = sender.superview?.superview?.superview?.superview?.superview as? ConcertTableViewCell {
            switch type {
            case .Details:
                let dict: [String: Any] = eventsArray[cell.vwMain.tag]
                if let eventId: Int = Int((dict["eventId"] as? String)!) {
                    let vc: EventDetailsViewController = storyboard?.instantiateViewController(withIdentifier: "EventDetailsViewController") as! EventDetailsViewController
                    vc.eventId = eventId
                    if let img: String = dict["baseImage"] as? String {
                        vc.baseImage = img
                    }
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                break
            case .ConcertBlue:
                cell.vwMultipleBtn.isHidden = false
                cell.btnConcertBlue.isHidden = true
                break
            case .ConcertWhite:
                cell.vwMultipleBtn.isHidden = true
                cell.btnConcertBlue.isHidden = false
                break
            case .Bookmark:
                let dict: [String: Any] = eventsArray[cell.vwMain.tag]
                if let eventId: Int = Int((dict["eventId"] as? String)!), let status: Int = Int((dict["bookmark"] as? String)!) {
                    self.BookmarkEvent(eventId: eventId, status: status)
                }
                break
            case .Share:
                print("SHARE")
                /*let text = "This is some text that I want to share."
                let textToShare = [text]
                let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
                activityViewController.popoverPresentationController?.sourceView = self.view
                activityViewController.excludedActivityTypes = [UIActivityType.airDrop, UIActivityType.postToFacebook]
                self.present(activityViewController, animated: true, completion: nil)*/
                break
            case .Calendar:
                let dict: [String: Any] = eventsArray[cell.vwMain.tag]
                if let eventId: Int = Int((dict["eventId"] as? String)!), let status: Int = Int((dict["addedTocalendar"] as? String)!) {
                    self.AddEventToCalendar(eventId: eventId, status: status)
                }
                break
            case .TagFirst:
                /*let dict: [String: Any] = eventsArray[cell.vwMain.tag]
                let vc = storyboard?.instantiateViewController(withIdentifier: "SubCategoryViewController") as! SubCategoryViewController
                vc.strTitle = (cell.btnTagFirst?.titleLabel?.text)!
                if let tagsArray: [[String: Any]] = dict["tags"] as? [[String: Any]] {
                    if tagsArray.count >= 1 {
                        vc.tagID = Int((tagsArray[0]["id"] as? String)!)!
                    }
                }
                navigationController?.pushViewController(vc, animated: true)*/
                break
            case .TagSecond:
                /*let dict: [String: Any] = eventsArray[cell.vwMain.tag]
                let vc = storyboard?.instantiateViewController(withIdentifier: "SubCategoryViewController") as! SubCategoryViewController
                vc.strTitle = (cell.btnTagSecond?.titleLabel?.text)!
                if let tagsArray: [[String: Any]] = dict["tags"] as? [[String: Any]] {
                    if tagsArray.count >= 2 {
                        vc.tagID = Int((tagsArray[1]["id"] as? String)!)!
                    }
                }
                navigationController?.pushViewController(vc, animated: true)*/
                break
            }
        }
        tblConcertList.reloadData()
    }
    
    //MARK:- API
    
    func EventList() {
        if let userId: String = UserDefaults.standard.string(forKey: "userId") {
            eventsArray = []
            tblConcertList.reloadData()
            let actInd: UIActivityIndicatorView = self.showProgressIndicator()
            let api = APIManager()
            api.post(toURL: API_EVENT_LIST!, params: ["userId": userId], responseType: .JSON, progress: { (progress) in
            }, success: { (response) in
                self.hideProgressIndicator(actInd: actInd)
                let dict = response.dictionary
                print(dict)
                if let status = dict["status"] as? Int {
                    if status == SUCCESS {
                        self.eventsArray = dict["events"] as! [[String: Any]]
                    }
                    else {
                        self.showMessage(message: "No events found.")
                    }
                }
                self.tblConcertList.reloadData()
            }, failure: { (response) in
                self.hideProgressIndicator(actInd: actInd)
                if let errorString = response.dictionary["error"] as? [String: Any] {
                    self.showMessage(message: errorString.description)
                }
            })
        }
        else {
            self.showMessage(message: ERROR_MSG_USER_NOT_FOUND)
        }
    }
    
    func AddEventToCalendar(eventId: Int, status: Int) {
        if let userId: String = UserDefaults.standard.string(forKey: "userId") {
            let actInd: UIActivityIndicatorView = self.showProgressIndicator()
            let api = APIManager()
            var st: Int = 0
            (status == 1) ? (st = 0) : (st = 1)
            api.post(toURL: API_ADD_EVENT_CALENDAR!, params: ["userId": userId, "eventId": eventId, "status": st], responseType: .JSON, progress: { (progress) in
            }, success: { (response) in
                self.hideProgressIndicator(actInd: actInd)
                let dict = response.dictionary
                print(dict)
                if let status = dict["status"] as? Int {
                    if status == SUCCESS {
                        print("SUCCESS")
                    }
                    else {
                        self.showMessage(message: "Failed.")
                    }
                }
                self.EventList()
            }, failure: { (response) in
                self.hideProgressIndicator(actInd: actInd)
                if let errorString = response.dictionary["error"] as? [String: Any] {
                    self.showMessage(message: errorString.description)
                }
            })
        }
        else {
            self.showMessage(message: ERROR_MSG_USER_NOT_FOUND)
        }
    }
    
    func BookmarkEvent(eventId: Int, status: Int) {
        if let userId: String = UserDefaults.standard.string(forKey: "userId") {
            let actInd: UIActivityIndicatorView = self.showProgressIndicator()
            let api = APIManager()
            var st: Int = 0
            (status == 1) ? (st = 0) : (st = 1)
            api.post(toURL: API_BOOKMARK_EVENT!, params: ["userId": userId, "eventId": eventId, "status": st], responseType: .JSON, progress: { (progress) in
            }, success: { (response) in
                self.hideProgressIndicator(actInd: actInd)
                let dict = response.dictionary
                print(dict)
                if let status = dict["status"] as? Int {
                    if status == SUCCESS {
                        print("SUCCESS")
                    }
                    else {
                        self.showMessage(message: "Failed.")
                    }
                }
                self.EventList()
            }, failure: { (response) in
                self.hideProgressIndicator(actInd: actInd)
                if let errorString = response.dictionary["error"] as? [String: Any] {
                    self.showMessage(message: errorString.description)
                }
            })
        }
        else {
            self.showMessage(message: ERROR_MSG_USER_NOT_FOUND)
        }
    }
}
