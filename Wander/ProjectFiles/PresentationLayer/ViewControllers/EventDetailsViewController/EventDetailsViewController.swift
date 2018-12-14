//
//  EventDetailsViewController.swift
//  Wander
//
//  Created by IOS on 4/3/18.
//  Copyright © 2018 IOS. All rights reserved.
//

import UIKit

class EventDetailsViewController: UITableViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet var imgView: UIImageView!
    @IBOutlet var lblName: UILabel!
    @IBOutlet var lblDateTime: UILabel!
    @IBOutlet var lblAddress1: UILabel!
    @IBOutlet var lblAddress2: UILabel!
    @IBOutlet var btnCalendar: UIButton!
    @IBOutlet var lblCalendar: UILabel!
    @IBOutlet var btnBookmark: UIButton!
    @IBOutlet var lblBookmark: UILabel!
    @IBOutlet var btnNearby: UIButton!
    @IBOutlet var btnShare: UIButton!
    @IBOutlet var btnBookTickets: UIButton!
    @IBOutlet var btnBookCab: UIButton!
    @IBOutlet var btnBookNearby: UIButton!
    @IBOutlet var btnBookFlight: UIButton!
    @IBOutlet var photosCollectionView: UICollectionView!
    @IBOutlet var btnPhone: UIButton!
    @IBOutlet var lblPrice: UILabel!
    @IBOutlet var btnWebsite: UIButton!
    @IBOutlet var lblDetails: UILabel!
    @IBOutlet var lblAddress: UILabel!
    
    var eventId: Int = 0
    var addedToCalendar: Int = 0
    var bookmarked: Int = 0
    var photosArray: [String] = []
    var phoneNumber: String = ""
    var website: String = ""
    var ticketTypeId: Int = 0
    var ticketPrice: Double = 0.0
    var lat: Double = 0.0
    var lon: Double = 0.0
    var baseImage: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnBookTickets.applyShadow(color: COLOR_THEME_BLUE)
        btnBookTickets.applyCornerRadius()
        btnBookCab.applyBorderAndShadow(color: COLOR_THEME_BLUE)
        btnBookNearby.applyBorderAndShadow(color: COLOR_THEME_BLUE)
        btnBookFlight.applyBorderAndShadow(color: COLOR_THEME_BLUE)
        
        imgView.sd_setImage(with: URL(string: BASE_IMAGE_PATH + baseImage), placeholderImage: #imageLiteral(resourceName: "Default"), completed: nil)
        
        EventDetails()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK:- Button Actions
    
    @IBAction func backBtnAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func calendarBtnAction(_ sender: Any) {
        AddEventToCalendar()
    }
    @IBAction func bookmarkBtnAction(_ sender: Any) {
        BookmarkEvent()
    }
    @IBAction func nearbyBtnAction(_ sender: Any) {
        let vc: NearbyRestViewController = storyboard?.instantiateViewController(withIdentifier: "NearbyRestViewController") as! NearbyRestViewController
        vc.lat = lat
        vc.lng = lon
        navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func shareBtnAction(_ sender: Any) {
        SharePopup()
    }
    @IBAction func bookTicketBtnAction(_ sender: Any) {
        let vc: BookTicketsViewController = storyboard?.instantiateViewController(withIdentifier: "BookTicketsViewController") as! BookTicketsViewController
        vc.ticketTypeId = ticketTypeId
        vc.ticketPrice = ticketPrice
        vc.eventId = eventId
        navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func bookCabBtnAction(_ sender: Any) {
        
    }
    @IBAction func bookNearbyBtnAction(_ sender: Any) {
        
    }
    @IBAction func bookFlightBtnAction(_ sender: Any) {
        
    }
    @IBAction func phoneBtnAction(_ sender: Any) {
        if let url = URL(string: "tel://\(phoneNumber)"), UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    @IBAction func websiteBtnAction(_ sender: Any) {
        guard let url = URL(string: website) else {
            return
        }
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    @IBAction func getDirBtnAction(_ sender: Any) {
        let vc: MapViewController = storyboard?.instantiateViewController(withIdentifier: "MapViewController") as! MapViewController
        vc.lat = lat
        vc.lon = lon
        navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK:- UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 40
        case 1:
            return 60
        case 2,3:
            return 80
        case 5:
            return 120
        case 6:
            return 10
        case 7:
            return 70
        case 8,9:
            return 50
        case 10:
            return 30 + heightForView(text: lblDetails.text!)
        case 11:
            return 90
        default:
            return 0
        }
    }
    
    func heightForView(text:String) -> CGFloat{
        let label:UILabel = UILabel(frame: CGRect(x: lblDetails.frame.origin.x, y: lblDetails.frame.origin.y, width: lblDetails.frame.size.width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.text = text
        label.sizeToFit()
        return label.frame.height
    }
    
    //MARK:- UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photosArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EventDetailsCollectionViewCell", for: indexPath as IndexPath) as! EventDetailsCollectionViewCell
        cell.cellImageView.sd_setImage(with: URL(string: BASE_IMAGE_PATH + photosArray[indexPath.item]), placeholderImage: #imageLiteral(resourceName: "Default"), completed: nil)
        //cell.cellImageView.sd_setImage(with: URL(string: BASE_IMAGE_PATH + tempImagesArray[indexPath.item]), placeholderImage: #imageLiteral(resourceName: "Default"), completed: nil)
        return cell
    }
    
    //MARK:- UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView .deselectItem(at: indexPath, animated: true)
    }
    
    //MARK:- UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,sizeForItemAt indexPath:IndexPath ) -> CGSize {
        return CGSize(width: 70, height: 70)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10.0
    }
    
    //MARK:- API
    
    func EventDetails() {
        if let userId: String = UserDefaults.standard.string(forKey: "userId") {
            let actInd: UIActivityIndicatorView = self.showProgressIndicator()
            let api = APIManager()
            api.post(toURL: API_EVENT_DETAILS!, params: ["userId": userId, "eventId": eventId], responseType: .JSON, progress: { (progress) in
            }, success: { (response) in
                self.hideProgressIndicator(actInd: actInd)
                let dict = response.dictionary
                print(dict)
                if let status = dict["status"] as? Int {
                    if status == SUCCESS {
                        if let arr = dict["events"] as? [[String: Any]] {
                            if arr.count != 0 {
                                self.setupData(dict: arr[0])
                            }
                        }
                    }
                    else {
                        self.showMessage(message: "Failed.")
                    }
                }
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
    
    func setupData(dict: [String: Any]) {
        if let name: String = dict["eventName"] as? String {
            lblName.text = name
        }
        if let startDate: String = dict["startDate"] as? String, let startTime: String = dict["startTime"] as? String {
            lblDateTime.text = "\(startDate) \(startTime)"
        }
        if let venue: String = dict["venue"] as? String, let location: String = dict["location"] as? String {
            lblAddress1.text = "\(venue) - \(location)"
        }
        if let city: String = dict["eventCity"] as? String {
            lblAddress2.text = city
        }
        if let details: String = dict["details"] as? String {
            lblDetails.text = details
        }
        if let phoneNo: String = dict["phone_no"] as? String {
            btnPhone.setTitle(phoneNo, for: .normal)
            phoneNumber = phoneNo
        }
        if let price: String = dict["price"] as? String {
            lblPrice.text = "$ \(price) / Person"
            ticketPrice = Double(price)!
        }
        if let web: String = dict["website"] as? String {
            btnWebsite.setTitle(web, for: .normal)
            website = web
        }
        if let venue: String = dict["venue"] as? String, let location: String = dict["location"] as? String, let city: String = dict["eventCity"] as? String {
            lblAddress.text = "\(venue) - \(location) - \(city)"
        }
        photosArray = []
        if let photos: [[String: Any]] = dict["photo"] as? [[String: Any]] {
            for dict in photos {
                if let name: String = dict["fileName"] as? String {
                    photosArray.append(name)
                }
            }
        }
        photosCollectionView.reloadData()
        if let cal: Int = dict["addedToCalendar"] as? Int {
            addedToCalendar = cal
            if addedToCalendar == 1 {
                self.btnCalendar.isSelected = true
                self.lblCalendar.text = "Added to Calendar"
            }
            else {
                self.btnCalendar.isSelected = false
                self.lblCalendar.text = "Add to Calendar"
            }
        }
        if let book: Int = dict["bookmark"] as? Int {
            bookmarked = book
            if bookmarked == 1 {
                self.btnBookmark.isSelected = true
                self.lblBookmark.text = "Bookmarked"
            }
            else {
                self.btnBookmark.isSelected = false
                self.lblBookmark.text = "Bookmark"
            }
        }
        if let tktTypeId: String = dict["ticketTypeId"] as? String {
            ticketTypeId = Int(tktTypeId)!
        }
        if let evntId: String = dict["eventId"] as? String {
            eventId = Int(evntId)!
        }
        if let lt: String = dict["lat"] as? String {
            lat = Double(lt)!
        }
        if let lg: String = dict["lon"] as? String {
            lon = Double(lg)!
        }
    }
    
    func AddEventToCalendar() {
        if let userId: String = UserDefaults.standard.string(forKey: "userId") {
            let actInd: UIActivityIndicatorView = self.showProgressIndicator()
            let api = APIManager()
            var st: Int = 0
            (self.addedToCalendar == 1) ? (st = 0) : (st = 1)
            api.post(toURL: API_ADD_EVENT_CALENDAR!, params: ["userId": userId, "eventId": eventId, "status": st], responseType: .JSON, progress: { (progress) in
            }, success: { (response) in
                self.hideProgressIndicator(actInd: actInd)
                let dict = response.dictionary
                print(dict)
                if let status = dict["status"] as? Int {
                    if status == SUCCESS {
                        print("SUCCESS")
                        (self.addedToCalendar == 1) ? (self.addedToCalendar = 0) : (self.addedToCalendar = 1)
                        if self.addedToCalendar == 1 {
                            self.btnCalendar.isSelected = true
                            self.lblCalendar.text = "Added to Calendar"
                        }
                        else {
                            self.btnCalendar.isSelected = false
                            self.lblCalendar.text = "Add to Calendar"
                        }
                    }
                    else {
                        self.showMessage(message: "Failed.")
                    }
                }
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
    
    func BookmarkEvent() {
        if let userId: String = UserDefaults.standard.string(forKey: "userId") {
            let actInd: UIActivityIndicatorView = self.showProgressIndicator()
            let api = APIManager()
            var st: Int = 0
            (self.bookmarked == 1) ? (st = 0) : (st = 1)
            api.post(toURL: API_BOOKMARK_EVENT!, params: ["userId": userId, "eventId": eventId, "status": st], responseType: .JSON, progress: { (progress) in
            }, success: { (response) in
                self.hideProgressIndicator(actInd: actInd)
                let dict = response.dictionary
                print(dict)
                if let status = dict["status"] as? Int {
                    if status == SUCCESS {
                        print("SUCCESS")
                        (self.bookmarked == 1) ? (self.bookmarked = 0) : (self.bookmarked = 1)
                        if self.bookmarked == 1 {
                            self.btnBookmark.isSelected = true
                            self.lblBookmark.text = "Bookmarked"
                        }
                        else {
                            self.btnBookmark.isSelected = false
                            self.lblBookmark.text = "Bookmark"
                        }
                    }
                    else {
                        self.showMessage(message: "Failed.")
                    }
                }
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
    
    func SharePopup() {
        let text = "Please find the event details at " + (btnWebsite.titleLabel?.text)!
        let textToShare = [text]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
    }
}
