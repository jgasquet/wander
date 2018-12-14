//
//  ExploreViewController.swift
//  Wander
//
//  Created by IOS on 3/30/18.
//  Copyright © 2018 IOS. All rights reserved.
//

import UIKit

struct Explore {
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

class ExploreViewController: UIViewController, UITableViewDataSource, ExploreTableViewCellDelegate, UISearchBarDelegate {

    @IBOutlet var tblExplore: UITableView!
    @IBOutlet var srchBar: UISearchBar!
    @IBOutlet var vwLocation: UIView!
    @IBOutlet var vwTime: UIView!
    @IBOutlet var lblLocation: UILabel!
    @IBOutlet var lblTime: UILabel!
    
    var arrExpCategories: [[Explore]]!
    var cityId: Int = 1
    var dateId: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        vwLocation.layer.borderColor = UIColor.black.cgColor
        vwLocation.layer.borderWidth = 1.0
        vwLocation.layer.cornerRadius = 10.0
        vwLocation.layer.masksToBounds = true
        vwTime.layer.borderColor = UIColor.black.cgColor
        vwTime.layer.borderWidth = 1.0
        vwTime.layer.cornerRadius = 10.0
        vwTime.layer.masksToBounds = true
        
        fetchExpCategories()
        tblExplore.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        srchBar.text = ""
    }
    
    //MARK: - UIButtonAction
    
    @IBAction func btnLocationAction(_ sender: Any) {
        let vc: ExploreForViewController = storyboard?.instantiateViewController(withIdentifier: "ExploreForViewController") as! ExploreForViewController
        vc.selectedCity = self.lblLocation.text!
        vc.selectedDayTime = self.lblTime.text!
        vc.callBack = {(dict: [String: Any]) -> () in
            self.lblLocation.text = dict["city"] as? String
            self.lblTime.text = dict["date"] as? String
            self.cityId = dict["cityId"] as! Int
            self.dateId = dict["dateId"] as! Int
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func btnDateTimeAction(_ sender: Any) {
        let vc: ExploreForViewController = storyboard?.instantiateViewController(withIdentifier: "ExploreForViewController") as! ExploreForViewController
        vc.selectedCity = self.lblLocation.text!
        vc.selectedDayTime = self.lblTime.text!
        vc.callBack = {(dict: [String: Any]) -> () in
            self.lblLocation.text = dict["city"] as? String
            self.lblTime.text = dict["date"] as? String
            self.cityId = dict["cityId"] as! Int
            self.dateId = dict["dateId"] as! Int
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: - UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExploreTableViewCell") as! ExploreTableViewCell
        cell.delegate = self
        let expList = arrExpCategories![indexPath.row]
        cell.btnFirst.setTitle(expList[0].name, for: .normal)
        cell.imgFirst.image = UIImage(named: expList[0].imageName!)
        cell.btnSecond.setTitle(expList[1].name, for: .normal)
        cell.imgSecond.image = UIImage(named: expList[1].imageName!)
        cell.btnFirst.tag = 1000 + indexPath.row
        cell.btnSecond.tag = 2000 + indexPath.row
        return cell
    }
    
    //MARK: - UISearchbarDelegate
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    //MARK: - ExploreTableViewCellDelegate
    
    func exploreTableViewCellButtonTapped(_ sender: UIButton, type: ExploreTableViewCellButton) {
        srchBar.resignFirstResponder()
        if srchBar.text?.isEmpty == true {
            self.showMessage(message: ERROR_MSG_SEARCH_BLANK)
        }
        else {
            let vc = storyboard?.instantiateViewController(withIdentifier: "SubCategoryViewController") as! SubCategoryViewController
            vc.strTitle = (sender.titleLabel?.text)!
            var catId: Int = sender.tag
            if catId >= 2000 {
                catId = (catId-2000+1)*2
            }
            else if catId >= 1000 {
                catId = ((catId-1000)*2)+1
            }
            print(catId)
            vc.categoryId = catId
            vc.strSearch = srchBar.text!
            vc.cityId = cityId
            vc.dateId = dateId
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    //MARK: - SELF
    
    fileprivate func fetchExpCategories() {
        arrExpCategories = [[Explore]]()
        if let url = Bundle.main.url(forResource: "CategoryButtons", withExtension: "plist") {
            if let root = NSArray(contentsOf: url) {
                for row in root {
                    var arr = [Explore]()
                    for dict in row as! [Dictionary<String, String>] {
                        arr.append(Explore(name: dict["name"]!, imageName: dict["imageName"]!))
                    }
                    arrExpCategories.append(arr)
                }
            }
            print(arrExpCategories)
        }
    }
}
