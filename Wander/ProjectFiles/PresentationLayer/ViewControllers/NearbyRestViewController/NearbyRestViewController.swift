//
//  NearbyRestViewController.swift
//  Wander
//
//  Created by IOS on 4/18/18.
//  Copyright © 2018 IOS. All rights reserved.
//

import UIKit

class NearbyRestViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var restrntsTableView: UITableView!
    
    var restrntsArray: [[String: Any]] = []
    var eventsArray: [[String: Any]] = []
    var isEvent: Bool = false
    var keyword: String = ""
    var cityId: Int = 0
    var dateRange: Int = 0
    var categoryId: Int = 0
    var subCategoryId: String = "1"
    var lat: Double = 0.0
    var lng: Double = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if isEvent == true {
            lblTitle.text = "Event List"
        }
        isEvent == true ? ExploreEvents() : RestaurantList()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidLayoutSubviews() {
        restrntsTableView.reloadData()
    }
    
    //MARK:- Button Actions
    
    @IBAction func backBtnAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    //MARK: - UITableViewDataSource -
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (isEvent == true ? eventsArray.count : restrntsArray.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NearbyRestTableViewCell") as! NearbyRestTableViewCell
        if indexPath.row % 2 == 0 {
            cell.vwGradient.createGradientView(FirstColor: UIColor.purple, SecondColor: UIColor.blue, width: SCREEN_SIZE.width, height: cell.frame.size.height, direction: HORIZONTAL, alpha: 0.4)
        }
        else {
            cell.vwGradient.createGradientView(FirstColor: UIColor.orange, SecondColor: UIColor.yellow, width: SCREEN_SIZE.width, height: cell.frame.size.height, direction: HORIZONTAL, alpha: 0.4)
        }
        cell.imgVw.sd_setImage(with: URL(string: BASE_IMAGE_PATH + tempImagesArray[indexPath.row % 4]), placeholderImage: #imageLiteral(resourceName: "Default"), completed: nil)
        
        if isEvent == true {
            let dict: [String: Any] = eventsArray[indexPath.row]
            if let name: String = dict["name"] as? String {
                cell.lblName.text = name
            }
            if let venue: String = dict["venue"] as? String, let location: String = dict["location"] as? String {
                cell.lblAddress2.text = "\(venue) - \(location)"
            }
            if let startDate: String = dict["startDate"] as? String, let startTime: String = dict["startTime"] as? String {
                cell.lblDistance.text = "\(startDate) - \(startTime)"
            }
            if let tagsArray: [[String: Any]] = dict["tags"] as? [[String: Any]] {
                if tagsArray.count >= 2 {
                    let firstTag: String = tagsArray[0]["tag"] as! String
                    cell.lblHashtag1.text = "#\(firstTag.lowercased())"
                    let secondTag: String = tagsArray[1]["tag"] as! String
                    cell.lblHashtag2.text = "#\(secondTag.lowercased())"
                }
                else if tagsArray.count == 1 {
                    let firstTag: String = tagsArray[0]["tag"] as! String
                    cell.lblHashtag1.text = "#\(firstTag.lowercased())"
                }
            }
            if let img: String = dict["baseImage"] as? String {
                cell.imgVw.sd_setImage(with: URL(string: BASE_IMAGE_PATH + img), placeholderImage: #imageLiteral(resourceName: "Default"), completed: nil)
            }
        }
        else {
            let dict: [String: Any] = restrntsArray[indexPath.row]
            if let name: String = dict["name"] as? String {
                cell.lblName.text = name
            }
            if let address: String = dict["address"] as? String {
                cell.lblAddress2.text = address
            }
            if let distance: String = dict["distance"] as? String {
                cell.lblDistance.text = "\(Double(round(100*Double(distance)!)/100)) miles away"
            }
            if let hashtag: String = dict["hashtag"] as? String {
                cell.lblHashtag1.text = hashtag
            }
        }
        return cell
    }
    
    //MARK: - UITableViewDelegate -
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return SCREEN_SIZE.width*2.0/3.0
    }
    
    //MARK:- API
    
    func RestaurantList() {
        restrntsArray = []
        let actInd: UIActivityIndicatorView = self.showProgressIndicator()
        let api = APIManager()
        api.post(toURL: API_RESTAURANT_LIST!, params: ["lat": lat, "lon": lng, "radius": "50"], responseType: .JSON, progress: { (progress) in
        }, success: { (response) in
            self.hideProgressIndicator(actInd: actInd)
            let dict = response.dictionary
            print(dict)
            if let status = dict["status"] as? Int {
                if status == SUCCESS {
                    self.restrntsArray = dict["data"] as! [[String: Any]]
                }
                else {
                    self.showMessage(message: "No restaurants found.")
                }
            }
            self.restrntsTableView.reloadData()
        }, failure: { (response) in
            self.hideProgressIndicator(actInd: actInd)
            if let errorString = response.dictionary["error"] as? [String: Any] {
                self.showMessage(message: errorString.description)
            }
        })
    }
    
    func ExploreEvents() {
        if let userId: String = UserDefaults.standard.string(forKey: "userId") {
            let actInd: UIActivityIndicatorView = self.showProgressIndicator()
            let api = APIManager()
            api.post(toURL: API_EXPLORE_EVENTS!, params: ["userId": userId, "keyword": keyword, "eventCityId": cityId, "dateRange": dateRange, "categoryId": categoryId, "subCategoryId": subCategoryId], responseType: .JSON, progress: { (progress) in
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
                self.restrntsTableView.reloadData()
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
