//
//  ProfileViewController.swift
//  Wander
//
//  Created by IOS on 4/3/18.
//  Copyright © 2018 IOS. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var vwLogin: UIView!
    @IBOutlet var vwProfile: UIView!
    @IBOutlet var btnFacebook: UIButton!
    @IBOutlet var btnGmail: UIButton!
    @IBOutlet var btnEmailLogin: UIButton!
    @IBOutlet var btnEmailSignUp: UIButton!
    @IBOutlet var vwButtons: UIView!
    @IBOutlet var btnAction: UIButton!
    @IBOutlet var btnBooked: UIButton!
    @IBOutlet var btnBookmarked: UIButton!
    @IBOutlet var vwSettings: UIView!
    @IBOutlet var vwNotification: UIView!
    @IBOutlet var profileTableView: UITableView!
    @IBOutlet var vwTableFooter: UIView!
    @IBOutlet var lblName: UILabel!
    
    var selectedIndex: Int = 0
    var eventsArray: [[String: Any]] = []
    var ticketsArray: [[String: Any]] = []
    var lat: Double = 0.0
    var lon: Double = 0.0
    
    let arrProfile: [[String: Any]] = [/*["title": "Plan Your Visit", "desc": "Let us know where are you going to visit next and we will show you best suited events"],*/
                                       ["title": "Create Your Event", "desc": "Create Your Event and list on Wander"],
                                       ["title": "Questionnaire", "desc": "Answer questionnaire so we can understand you better"],
                                       ["title": "Settings", "desc": "Profile/Notification Settings"]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnFacebook.applyShadow(color: COLOR_THEME_BLUE)
        btnGmail.applyShadow(color: COLOR_THEME_BLUE)
        btnEmailLogin.applyShadow(color: COLOR_THEME_BLUE)
        btnEmailSignUp.applyShadow(color: COLOR_THEME_BLUE)
        vwButtons.applyBorderAndShadow(color: COLOR_THEME_BLUE)
        btnAction.applyCornerRadius()
        btnBooked.applyCornerRadius()
        btnBookmarked.applyCornerRadius()
        
        profileTableView.estimatedRowHeight = 100.0
        
        btnAction.isSelected = true
        
        /*if let userTypeId: String = UserDefaults.standard.string(forKey: "userTypeId") {
            if Int(userTypeId) == USER_TYPE.VISITOR.hashValue {
                vwProfile.isHidden = true
                vwNotification.isHidden = true
                vwSettings.isHidden = false
            }
            else {
                vwProfile.isHidden = false
                vwNotification.isHidden = false
                vwSettings.isHidden = true
            }
        }*/
        vwProfile.isHidden = false
        vwNotification.isHidden = true
        vwSettings.isHidden = true
        
        if let name: String = UserDefaults.standard.string(forKey: "name") {
            lblName.text = name
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: - UITableViewDataSource -
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch selectedIndex {
        case 1:
            return ticketsArray.count
        case 2:
            return eventsArray.count
        default:
            return arrProfile.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch selectedIndex {
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileBookedTableViewCell") as! ProfileBookedTableViewCell
            cell.lblAddCalendar.text = "Add to Calendar"
            cell.lblBookmark.text = "Bookmark"
            cell.btnAddCalendar.isSelected = false
            cell.btnBookmark.isSelected = false
            cell.btnItinerary.isHidden = false
            cell.btnCancel.isHidden = false
            cell.btnItinerary.tag = 4000 + indexPath.row
            cell.btnItinerary.addTarget(self, action: #selector(self.btnItiAction(sender:)), for: .touchUpInside)
            //cell.imgVw.sd_setImage(with: URL(string: BASE_IMAGE_PATH + tempImagesArray[indexPath.row % 4]), placeholderImage: #imageLiteral(resourceName: "Default"), completed: nil)
            let dict: [String: Any] = ticketsArray[indexPath.row]
            if let name: String = dict["eventName"] as? String {
                cell.lblName.text = name
            }
            if let startDate: String = dict["eventStartDate"] as? String, let startTime: String = dict["eventStartTime"] as? String {
                cell.lblDateTime.text = "\(startDate) \(startTime)"
            }
            /*if let venue: String = dict["venue"] as? String, let location: String = dict["location"] as? String {
                cell.lblAddress.text = "\(venue) - \(location)"
            }*/
            if let address: String = dict["address"] as? String {
                cell.lblAddress.text = address
            }
            if let img: String = dict["baseImage"] as? String {
                cell.imgVw.sd_setImage(with: URL(string: BASE_IMAGE_PATH + img), placeholderImage: #imageLiteral(resourceName: "Default"), completed: nil)
            }
            cell.btnCancel.tag = 3000 + indexPath.row
            cell.btnCancel.addTarget(self, action: #selector(self.cancelButtonTapped(sender:)), for: .touchUpInside)
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileBookedTableViewCell") as! ProfileBookedTableViewCell
            /*cell.lblAddCalendar.text = "Added to Calendar"
            cell.lblBookmark.text = "Bookmarked"
            cell.btnAddCalendar.isSelected = true
            cell.btnBookmark.isSelected = true*/
            cell.btnItinerary.isHidden = true
            cell.btnCancel.isHidden = true
            cell.imgVw.sd_setImage(with: URL(string: BASE_IMAGE_PATH + tempImagesArray[indexPath.row % 4]), placeholderImage: #imageLiteral(resourceName: "Default"), completed: nil)
            let dict: [String: Any] = eventsArray[indexPath.row]
            if let name: String = dict["name"] as? String {
                cell.lblName.text = name
            }
            if let startDate: String = dict["startDate"] as? String, let startTime: String = dict["startTime"] as? String {
                cell.lblDateTime.text = "\(startDate) \(startTime)"
            }
            if let venue: String = dict["venue"] as? String, let location: String = dict["location"] as? String {
                cell.lblAddress.text = "\(venue) - \(location)"
            }
            if let cal: Int = dict["addedTocalendar"] as? Int {
                if cal == 1 {
                    cell.btnAddCalendar.isSelected = true
                    cell.lblAddCalendar.text = "Added to Calendar"
                }
                else {
                    cell.btnAddCalendar.isSelected = false
                    cell.lblAddCalendar.text = "Add to Calendar"
                }
            }
            if let book: Int = dict["bookmark"] as? Int {
                if book == 1 {
                    cell.btnBookmark.isSelected = true
                    cell.lblBookmark.text = "Bookmarked"
                }
                else {
                    cell.btnBookmark.isSelected = false
                    cell.lblBookmark.text = "Bookmark"
                }
            }
            cell.btnAddCalendar.tag = 1000 + indexPath.row
            cell.btnAddCalendar.addTarget(self, action: #selector(self.btnCalendarAction(sender:)), for: .touchUpInside)
            cell.btnBookmark.tag = 2000 + indexPath.row
            cell.btnBookmark.addTarget(self, action: #selector(self.btnBookmarkAction(sender:)), for: .touchUpInside)
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileActionTableViewCell") as! ProfileActionTableViewCell
            cell.lblTitle.text = arrProfile[indexPath.row]["title"] as? String
            cell.lblDesc.text = arrProfile[indexPath.row]["desc"] as? String
            return cell
        }
    }
    
    @objc func btnItiAction(sender: UIButton!) {
        let dict: [String: Any] = ticketsArray[sender.tag-4000]
        print(dict)
        if let lt: String = dict["latitude"] as? String {
            lat = Double(lt)!
        }
        if let lg: String = dict["longitude"] as? String {
            lon = Double(lg)!
        }
        let vc: MapViewController = storyboard?.instantiateViewController(withIdentifier: "MapViewController") as! MapViewController
        vc.lat = lat
        vc.lon = lon
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func btnCalendarAction(sender: UIButton!) {
        let dict: [String: Any] = eventsArray[sender.tag-1000]
        print(dict)
        if let eventId: Int = Int((dict["eventId"] as? String)!), let status: Int = Int((dict["addedTocalendar"] as? String)!) {
            self.AddEventToCalendar(eventId: eventId, status: status)
        }
    }
    @objc func btnBookmarkAction(sender: UIButton!) {
        let dict: [String: Any] = eventsArray[sender.tag-2000]
        print(dict)
        if let eventId: Int = Int((dict["eventId"] as? String)!), let status: Int = Int((dict["bookmark"] as? String)!) {
            self.BookmarkEvent(eventId: eventId, status: status)
        }
    }
    
    @objc func cancelButtonTapped(sender: UIButton!){
        let dict: [String: Any] = ticketsArray[sender.tag-3000]
        print(dict)
        if let bookingID: Int = Int((dict["bookingID"] as? String)!) {
            self.CancelBooking(bookingId: bookingID)
        }
    }
    
    //MARK: - UITableViewDelegate -
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if selectedIndex == 0 {
            switch (indexPath.row) {
            /*case 0:
                let vc: PlanVisitViewController = storyboard?.instantiateViewController(withIdentifier: "PlanVisitViewController") as! PlanVisitViewController
                navigationController?.pushViewController(vc, animated: true)
                break*/
            case 0:
                let vc: AddEventViewController = storyboard?.instantiateViewController(withIdentifier: "AddEventViewController") as! AddEventViewController
                navigationController?.pushViewController(vc, animated: true)
                break
            case 1:
                let vc: QuestionnaireViewController = storyboard?.instantiateViewController(withIdentifier: "QuestionnaireViewController") as! QuestionnaireViewController
                navigationController?.pushViewController(vc, animated: true)
                break
            case 2:
                performSegue(withIdentifier: "segueSettings", sender: self)
                break
            default:
                break
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch selectedIndex {
        case 1:
            return 180
        case 2:
            return 140
        default:
            return UITableViewAutomaticDimension
        }
    }
    
    //MARK:- UIButtonActions
    
    @IBAction func btnFacebookAction(_ sender: Any) {
        hideLoginView()
    }
    @IBAction func btnGmailAction(_ sender: Any) {
        hideLoginView()
    }
    @IBAction func btnEmailLoginAction(_ sender: Any) {
        let vc: LoginEmailViewController = storyboard?.instantiateViewController(withIdentifier: "LoginEmailViewController") as! LoginEmailViewController
        vc.isFromProfile = true
        vc.callBack = {(YesOrNo: Bool) -> () in
            self.hideLoginView()
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func btnEmailSignUpAction(_ sender: Any) {
        let vc: RegistrationViewController = storyboard?.instantiateViewController(withIdentifier: "RegistrationViewController") as! RegistrationViewController
        vc.isFromProfile = true
        vc.callBack = {(YesOrNo: Bool) -> () in
            self.hideLoginView()
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func customSegmentBtnAction(_ sender: UIButton) {
        selectedIndex = sender.tag
        switch sender.tag {
        case 1:
            btnAction.isSelected = false
            btnBooked.isSelected = true
            btnBookmarked.isSelected = false
            vwTableFooter.isHidden = true
            self.MyBookedTickets()
            break
        case 2:
            btnAction.isSelected = false
            btnBooked.isSelected = false
            btnBookmarked.isSelected = true
            vwTableFooter.isHidden = true
            self.MyBookmarkedEvents()
            break
        default:
            btnAction.isSelected = true
            btnBooked.isSelected = false
            btnBookmarked.isSelected = false
            vwTableFooter.isHidden = false
            break
        }
        profileTableView.reloadData()
    }
    
    func hideLoginView() {
        vwProfile.isHidden = false
        vwNotification.isHidden = true
        vwSettings.isHidden = true
    }
    
    //MARK:- API
    
    func MyBookmarkedEvents() {
        if let userId: String = UserDefaults.standard.string(forKey: "userId") {
            eventsArray = []
            let actInd: UIActivityIndicatorView = self.showProgressIndicator()
            let api = APIManager()
            api.post(toURL: API_MY_BOOKMARKED_EVENTS!, params: ["userId": userId], responseType: .JSON, progress: { (progress) in
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
                self.profileTableView.reloadData()
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
    
    func MyBookedTickets() {
        if let userId: String = UserDefaults.standard.string(forKey: "userId") {
            ticketsArray = []
            let actInd: UIActivityIndicatorView = self.showProgressIndicator()
            let api = APIManager()
            api.post(toURL: API_BOOKED_TICKET_LIST!, params: ["userId": userId], responseType: .JSON, progress: { (progress) in
            }, success: { (response) in
                self.hideProgressIndicator(actInd: actInd)
                let dict = response.dictionary
                print(dict)
                if let status = dict["status"] as? Int {
                    if status == SUCCESS {
                        self.ticketsArray = dict["data"] as! [[String: Any]]
                    }
                    else {
                        self.showMessage(message: "No tickets found.")
                    }
                }
                self.profileTableView.reloadData()
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
                self.MyBookmarkedEvents()
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
                self.MyBookmarkedEvents()
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
    
    func CancelBooking(bookingId: Int) {
        if let userId: String = UserDefaults.standard.string(forKey: "userId") {
            let actInd: UIActivityIndicatorView = self.showProgressIndicator()
            let api = APIManager()
            api.post(toURL: API_CANCEL_BOOKING!, params: ["bookingId": bookingId], responseType: .JSON, progress: { (progress) in
            }, success: { (response) in
                self.hideProgressIndicator(actInd: actInd)
                let dict = response.dictionary
                print(dict)
                if let status = dict["status"] as? Int {
                    if status == SUCCESS {
                        print("SUCCESS")
                        self.MyBookedTickets()
                    }
                    else {
                        self.showMessage(message: "Failed to cancel.")
                    }
                }
                self.MyBookmarkedEvents()
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
