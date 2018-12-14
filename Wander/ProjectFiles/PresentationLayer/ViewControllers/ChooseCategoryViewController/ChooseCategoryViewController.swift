//
//  ChooseCategoryViewController.swift
//  Wander
//
//  Created by IOS on 04/12/17.
//  Copyright © 2017 IOS. All rights reserved.
//

import UIKit

struct Category {
    var name: String?
    var imageName: String?
    init(name: String, imageName: String?) {
        self.name = name
        self.imageName = imageName
    }
    init() {
        name = ""
        imageName = ""
    }
}

class ChooseCategoryViewController: BaseViewController, UITableViewDataSource, ChooseCategoryTableViewCellDelegate {

    @IBOutlet var vwHeader: UIView!
    @IBOutlet var tblCategoryList: UITableView!
    @IBOutlet var btnLetsGo: UIButton!
    @IBOutlet var btnBack: UIButton!
    
    var arrCategories: [[Category]]!
    var arrSelected: [Int] = []
    var selectedCityId: Int = 0
    var selectedCategoryIds: [Int] = []
    var isLoggedIn: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        populateCategory()
        tblCategoryList.reloadData()
        btnLetsGo.applyBorderAndShadow(color: COLOR_THEME_BLUE)
        btnLetsGo.isHidden = true
        
        vwHeader.isHidden = isLoggedIn
        btnBack.isHidden = !isLoggedIn
        if isLoggedIn == true {
            btnLetsGo.setTitle("Update", for: .normal)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: - UIButonActions -
    
    @IBAction func backBtnAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnLetsGoDidTapped(_ sender: Any) {
        isLoggedIn == true ? UpdateCategories() : FeedPersonalization()
    }
    
    //MARK: - UITableViewDataSource -
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! ChooseCategoryTableViewCell
        cell.delegate = self
        let catList = arrCategories![indexPath.row]
        cell.btnFirst.setTitle(catList[0].name, for: .normal)
        //cell.btnFirst.setImage(UIImage(named: catList[0].imageName!), for: .normal)
        cell.imgFirst.image = UIImage(named: catList[0].imageName!)
        cell.btnSecond.setTitle(catList[1].name, for: .normal)
        //cell.btnSecond.setImage(UIImage(named: catList[1].imageName!), for: .normal)
        cell.imgSecond.image = UIImage(named: catList[1].imageName!)
        cell.btnFirst.tag = 1000 + indexPath.row
        cell.btnSecond.tag = 2000 + indexPath.row
        return cell
    }
    
    //MARK: - ChooseCategoryTableViewCellDelegate -
    
    func chooseCategoryTableViewCellButtonTapped(_ sender: UIButton, type: ChooseCategoryTableViewCellButton) {
        if arrSelected.contains(sender.tag) {
            arrSelected.remove(at: arrSelected.index(of: sender.tag)!)
        }
        else {
            arrSelected.append(sender.tag)
        }
        arrSelected.count == 0 ? (btnLetsGo.isHidden = true) : (btnLetsGo.isHidden = false)
        
        //left side button tags are of 1000 series & right side button tags are of 2000 series
        selectedCategoryIds.removeAll()
        for catId in arrSelected {
            if catId >= 2000 {
                selectedCategoryIds.append((catId-2000+1)*2)
            }
            else if catId >= 1000 {
                selectedCategoryIds.append(((catId-1000)*2)+1)
            }
        }
        print(selectedCategoryIds)
    }
    
    //MARK: - SELF -
    
    fileprivate func populateCategory() {
        arrCategories = [[Category]]()
        if let url = Bundle.main.url(forResource: "CategoryButtons", withExtension: "plist") {
            if let root = NSArray(contentsOf: url) {
                for row in root {
                    var arr = [Category]()
                    for dict in row as! [Dictionary<String, String>] {
                        arr.append(Category(name: dict["name"]!, imageName: dict["imageName"]!))
                    }
                    arrCategories.append(arr)
                }
            }
            print(arrCategories)
        }
    }
    
    //MARK:- API
    
    func FeedPersonalization() {
        if let userId: String = UserDefaults.standard.string(forKey: "userId") {
            let actInd: UIActivityIndicatorView = self.showProgressIndicator()
            let api = APIManager()
            let catIdStr = selectedCategoryIds.map {String($0)}.joined(separator: ",")
            api.post(toURL: API_FEED_PERSONALIZATION!, params: ["userId": userId, "eventCityId": selectedCityId, "categoryId": catIdStr], responseType: .JSON, progress: { (progress) in
            }, success: { (response) in
                self.hideProgressIndicator(actInd: actInd)
                let dict = response.dictionary
                print(dict)
                if let status = dict["status"] as? Int {
                    if status == SUCCESS {
                        UserDefaults.standard.set(self.selectedCityId, forKey: "eventCityId")
                        UserDefaults.standard.synchronize()
                        self.performSegue(withIdentifier: "CategoryToHome", sender: self)
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
    
    func UpdateCategories() {
        if let userId: String = UserDefaults.standard.string(forKey: "userId") {
            let actInd: UIActivityIndicatorView = self.showProgressIndicator()
            let api = APIManager()
            let catIdStr = selectedCategoryIds.map {String($0)}.joined(separator: ",")
            api.post(toURL: API_UPDATE_EVENT_CATEGORY!, params: ["userId": userId, "categoryId": catIdStr], responseType: .JSON, progress: { (progress) in
            }, success: { (response) in
                self.hideProgressIndicator(actInd: actInd)
                let dict = response.dictionary
                print(dict)
                if let status = dict["status"] as? Int {
                    if status == SUCCESS {
                        self.navigationController?.popViewController(animated: true)
                    }
                    else {
                        self.showMessage(message: "Failed to update.")
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
}
