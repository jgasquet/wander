//
//  CountryListViewController.swift
//  Wander
//
//  Created by IOS on 5/1/18.
//  Copyright © 2018 IOS. All rights reserved.
//

import UIKit

class CountryListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var listTableView: UITableView!
    
    var listType: String = ""
    var countryId: Int = 0
    var stateId: Int = 0
    var responseArray: [[String: Any]] = []
    var callBack: ((_ dict: [String: Any]) -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if listType == COUNTRY {
            lblTitle.text = "\(COUNTRY) List"
            CountryList()
        }
        else if listType == STATE {
            lblTitle.text = "\(STATE) List"
            StateList(countryId: countryId)
        }
        else if listType == CITY {
            lblTitle.text = "\(CITY) List"
            CityList(stateId: stateId)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
        return responseArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dict: [String: Any] = responseArray[indexPath.row] as [String: Any]
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        if listType == COUNTRY {
            cell?.textLabel?.text = dict["country"] as? String
        }
        else if listType == STATE {
            cell?.textLabel?.text = dict["state"] as? String
        }
        else if listType == CITY {
            cell?.textLabel?.text = dict["city"] as? String
        }
        return cell!
    }
    
    //MARK: - UITableViewDelegate -
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        callBack!(responseArray[indexPath.row])
        navigationController?.popViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    //MARK:- API
    
    func CountryList() {
        let actInd: UIActivityIndicatorView = self.showProgressIndicator()
        let api = APIManager()
        api.get(toURL: API_COUNTRY_LIST!, params: [:], responseType: .JSON, progress: { (progress) in
        }, success: { (response) in
            self.responseArray = []
            self.hideProgressIndicator(actInd: actInd)
            let dict = response.dictionary
            if let status = dict["status"] as? Int {
                if status == SUCCESS {
                    self.responseArray = dict["countrylist"] as! [[String: Any]]
                }
                else {
                    self.showMessage(message: "No countries found.")
                }
            }
            self.listTableView.reloadData()
        }, failure: { (response) in
            self.hideProgressIndicator(actInd: actInd)
            if let errorString = response.dictionary["error"] {
                self.showMessage(message: errorString as! String)
            }
        })
    }
    
    func StateList(countryId: Int) {
        let actInd: UIActivityIndicatorView = self.showProgressIndicator()
        let api = APIManager()
        api.post(toURL: API_STATE_LIST!, params: ["countryId": countryId], responseType: .JSON, progress: { (progress) in
        }, success: { (response) in
            self.responseArray = []
            self.hideProgressIndicator(actInd: actInd)
            let dict = response.dictionary
            if let status = dict["status"] as? Int {
                if status == SUCCESS {
                    self.responseArray = dict["statelist"] as! [[String: Any]]
                }
                else {
                    self.showMessage(message: "No states found.")
                }
            }
            self.listTableView.reloadData()
        }, failure: { (response) in
            self.hideProgressIndicator(actInd: actInd)
            if let errorString = response.dictionary["error"] {
                self.showMessage(message: errorString as! String)
            }
        })
    }
    
    func CityList(stateId: Int) {
        let actInd: UIActivityIndicatorView = self.showProgressIndicator()
        let api = APIManager()
        api.post(toURL: API_CITY_LIST!, params: ["stateId": stateId], responseType: .JSON, progress: { (progress) in
        }, success: { (response) in
            self.responseArray = []
            self.hideProgressIndicator(actInd: actInd)
            let dict = response.dictionary
            if let status = dict["status"] as? Int {
                if status == SUCCESS {
                    self.responseArray = dict["citieslist"] as! [[String: Any]]
                }
                else {
                    self.showMessage(message: "No cities found.")
                }
            }
            self.listTableView.reloadData()
        }, failure: { (response) in
            self.hideProgressIndicator(actInd: actInd)
            if let errorString = response.dictionary["error"] {
                self.showMessage(message: errorString as! String)
            }
        })
    }
}
