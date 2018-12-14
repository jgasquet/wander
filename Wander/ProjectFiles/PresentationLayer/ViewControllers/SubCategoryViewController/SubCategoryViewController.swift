//
//  SubCategoryViewController.swift
//  Wander
//
//  Created by IOS on 4/12/18.
//  Copyright © 2018 IOS. All rights reserved.
//

import UIKit

class SubCategoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var srchBar: UISearchBar!
    @IBOutlet var subCatTableView: UITableView!
    @IBOutlet var subCatCollectionView: UICollectionView!
    @IBOutlet var vwHeader: UIView!
    
    var strTitle: String = ""
    var strSearch: String = ""
    var categoryId: Int = 0
    var cityId: Int = 0
    var dateId: Int = 0
    var subcatArray: [[String: Any]] = []
    var selectedArray: [String] = []
    var selectedIdArray: [Int] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lblTitle.text = strTitle
        srchBar.placeholder = "Search \(strTitle) Event"
        srchBar.text = strSearch
        
        hideUnhideView()
        
        subCatTableView.reloadData()
        
        if categoryId != 0 {
            //GetEventByHashtag()
            SubCategoryList()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK:- Button Actions
    
    @IBAction func backBtnAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func searchBtnAction(_ sender: Any) {
        //navigationController?.popViewController(animated: true)
        if selectedArray.count == 0 {
            self.showMessage(message: ERROR_MSG_TOPIC_BLANK)
        }
        else {
            let vc: NearbyRestViewController = storyboard?.instantiateViewController(withIdentifier: "NearbyRestViewController") as! NearbyRestViewController
            vc.isEvent = true
            vc.keyword = strSearch
            vc.dateRange = dateId
            vc.categoryId = categoryId
            vc.subCategoryId = selectedIdArray.map({String(describing: $0)}).joined(separator: ",")
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    //MARK: - UITableViewDataSource -
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subcatArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dict: [String: Any] = subcatArray[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "SubCategoryTableViewCell") as! SubCategoryTableViewCell
        if let name: String = dict["subcategory"] as? String {
            cell.lblCategory.text = name
        }
        return cell
    }
    
    //MARK: - UITableViewDelegate -
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let dict: [String: Any] = subcatArray[indexPath.row]
        if !selectedArray.contains(dict["subcategory"] as! String) {
            selectedArray.append(dict["subcategory"] as! String)
            selectedIdArray.append(Int(dict["id"] as! String)!)
        }
        hideUnhideView()
        subCatCollectionView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    //MARK:- UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectedArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SubCategoryCollectionViewCell", for: indexPath as IndexPath) as! SubCategoryCollectionViewCell
        cell.lblCategory.text = selectedArray[indexPath.item]
        cell.btnDelete.tag = indexPath.item
        cell.btnDelete.addTarget(self, action: #selector(self.deleteButtonTapped), for: .touchUpInside)
        return cell
    }
    
    //MARK:- UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView .deselectItem(at: indexPath, animated: true)
    }
    
    //MARK:- UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,sizeForItemAt indexPath:IndexPath ) -> CGSize {
        let size = (selectedArray[indexPath.item] as NSString).size(withAttributes: [NSAttributedStringKey.font: UIFont(name: DIODRUM_MEDIUM, size: 20) as Any])
        return CGSize(width: size.width+50, height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    @objc func deleteButtonTapped(sender: UIButton){
        selectedArray.remove(at: sender.tag)
        selectedIdArray.remove(at: sender.tag)
        hideUnhideView()
        subCatCollectionView.reloadData()
    }
    
    func hideUnhideView() {
        if selectedArray.count == 0 {
            UIView.transition(with: vwHeader, duration: 0.2, options: .transitionCrossDissolve, animations: {
                self.vwHeader.isHidden = true
                self.subCatTableView.tableHeaderView = nil
            })
        }
        else {
            UIView.transition(with: vwHeader, duration: 0.2, options: .transitionCrossDissolve, animations: {
                self.vwHeader.isHidden = false
                self.subCatTableView.tableHeaderView = self.vwHeader
            })
        }
    }
    
    //MARK:- API
    
    func SubCategoryList() {
        let actInd: UIActivityIndicatorView = self.showProgressIndicator()
        let api = APIManager()
        api.post(toURL: API_SUBCATEGORY_LIST!, params: ["categoryId": categoryId], responseType: .JSON, progress: { (progress) in
        }, success: { (response) in
            self.hideProgressIndicator(actInd: actInd)
            let dict = response.dictionary
            print(dict)
            if let status = dict["status"] as? Int {
                if status == SUCCESS {
                    self.subcatArray = dict["subcategories"] as! [[String: Any]]
                }
                else {
                    self.showMessage(message: "No subcategories found.")
                }
            }
            self.subCatTableView.reloadData()
        }, failure: { (response) in
            self.hideProgressIndicator(actInd: actInd)
            if let errorString = response.dictionary["error"] as? [String: Any] {
                self.showMessage(message: errorString.description)
            }
        })
    }
    
    /*func GetEventByHashtag() {
        if let userId: String = UserDefaults.standard.string(forKey: "userId") {
            let actInd: UIActivityIndicatorView = self.showProgressIndicator()
            let api = APIManager()
            api.post(toURL: API_GET_EVENT_BY_HASHTAG!, params: ["userId": userId, "tagId": tagID], responseType: .JSON, progress: { (progress) in
            }, success: { (response) in
                self.hideProgressIndicator(actInd: actInd)
                let dict = response.dictionary
                print(dict)
                if let status = dict["status"] as? Int {
                    if status == SUCCESS {
                        self.eventsArray = dict["events"] as! [[String: Any]]
                        print(self.eventsArray)
                    }
                    else {
                        self.showMessage(message: "No events found.")
                    }
                }
                self.subCatTableView.reloadData()
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
    }*/
}
