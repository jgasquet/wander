//
//  ChooseCityViewController.swift
//  Wander
//
//  Created by IOS on 04/12/17.
//  Copyright © 2017 IOS. All rights reserved.
//

import UIKit

class ChooseCityViewController: BaseViewController, UITableViewDataSource, ChooseCityTableViewCellDelegate {

    let cellHeight = 70.0
    let tableFixHeight = 134.0
    var isLoggedIn: Bool = false
    var callBack: ((_ str: String) -> ())?

    @IBOutlet var tblCity: UITableView!
    @IBOutlet var btnBack: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnBack.isHidden = !isLoggedIn
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let height = tableFixHeight + (cellHeight * Double(cityArray.count))
        tblCity.frame = CGRect(x: 0.0, y: 0.0, width: Double(SCREEN_SIZE.width), height: height > Double(SCREEN_SIZE.height) ? Double(SCREEN_SIZE.height) : height)
        tblCity.center = view.center
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func backBtnAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    //MARK: - UITableViewDataSource -
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cityArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! ChooseCityTableViewCell
        cell.btnCityName.setTitle(cityArray[indexPath.row], for: .normal)
        cell.delegate = self
        cell.btnCityName.tag = indexPath.row
        return cell
    }
    
    //MARK: - ChooseCityTableViewCellDelegate -
    
    func chooseCityTableViewCellCityNameButtonTapped(_ sender: UIButton) {
        if isLoggedIn == true {
            self.UpdateEventCity(eventCityId: sender.tag + 1)
        }
        else {
            let vc: ChooseCategoryViewController = storyboard?.instantiateViewController(withIdentifier: "ChooseCategoryViewController") as! ChooseCategoryViewController
            vc.selectedCityId = sender.tag + 1
            print(vc.selectedCityId)
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    //MARK:- API
    
    func UpdateEventCity(eventCityId: Int) {
        if let userId: String = UserDefaults.standard.string(forKey: "userId") {
            let actInd: UIActivityIndicatorView = self.showProgressIndicator()
            let api = APIManager()
            api.post(toURL: API_UPDATE_EVENT_CITY!, params: ["userId": userId, "eventCityId": eventCityId], responseType: .JSON, progress: { (progress) in
            }, success: { (response) in
                self.hideProgressIndicator(actInd: actInd)
                let dict = response.dictionary
                print(dict)
                if let status = dict["status"] as? Int {
                    if status == SUCCESS {
                        print("SUCCESS")
                    }
                    else {
                        self.showMessage(message: "Failed to update.")
                    }
                }
                self.callBack!(cityArray[eventCityId-1])
                self.navigationController?.popViewController(animated: true)
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
