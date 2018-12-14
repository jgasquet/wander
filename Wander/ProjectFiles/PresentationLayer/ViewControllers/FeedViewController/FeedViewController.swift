//
//  FeedViewController.swift
//  Wander
//
//  Created by IOS on 4/9/18.
//  Copyright © 2018 IOS. All rights reserved.
//

import UIKit

class FeedViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var lblCity: UILabel!
    @IBOutlet var lblDateTime: UILabel!
    @IBOutlet var firstCollectionBGView: UIView!
    @IBOutlet var firstCollectionView: UICollectionView!
    @IBOutlet var secondCollectionView: UICollectionView!
    @IBOutlet var feedTableView: UITableView!
    
    var categoriesArray: [[String: Any]] = []
    var subCategoriesArray: [[String: Any]] = []
    var firstSelectedIndex: Int = 0
    var secondSelectedIndex: Int = 0
    var eventsArray: [[String: Any]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        firstCollectionBGView.layer.shadowColor = UIColor.black.cgColor
        firstCollectionBGView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        firstCollectionBGView.layer.shadowOpacity = 0.6
        firstCollectionBGView.layer.shadowRadius = 10.0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //CategoryList()
        eventsArray = []
        feedTableView.reloadData()
        MyCategories()
    }
    
    //MARK:- UIButtonAction
    
    @IBAction func locationBtnAction(_ sender: Any) {
        let vc: ExploreForViewController = storyboard?.instantiateViewController(withIdentifier: "ExploreForViewController") as! ExploreForViewController
        vc.selectedCity = self.lblCity.text!
        vc.selectedDayTime = self.lblDateTime.text!
        vc.callBack = {(dict: [String: Any]) -> () in
            self.lblCity.text = dict["city"] as? String
            self.lblDateTime.text = dict["date"] as? String
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func plusBtnAction(_ sender: Any) {
        let vc: ChooseCategoryViewController = storyboard?.instantiateViewController(withIdentifier: "ChooseCategoryViewController") as! ChooseCategoryViewController
        vc.isLoggedIn = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK:- UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionView == firstCollectionView ? categoriesArray.count : subCategoriesArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var c: UIColor = UIColor.darkGray
        if collectionView == firstCollectionView {
            var f: UIFont = UIFont(name: DIODRUM_MEDIUM, size: 18)!
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FeedFirstCollectionViewCell", for: indexPath as IndexPath) as! FeedFirstCollectionViewCell
            let dict: [String: Any] = categoriesArray[indexPath.item]
            if let name: String = dict["category"] as? String {
                cell.lblCategory.text = name
            }
            if indexPath.item == firstSelectedIndex {
                c = COLOR_THEME_BLUE
                f = UIFont(name: DIODRUM_SEMIBOLD, size: 20)!
            }
            cell.lblCategory.textColor = c
            cell.lblCategory.font = f
            return cell
        }
        else {
            var f: UIFont = UIFont(name: DIODRUM_MEDIUM, size: 16)!
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FeedSecondCollectionViewCell", for: indexPath as IndexPath) as! FeedSecondCollectionViewCell
            let dict: [String: Any] = subCategoriesArray[indexPath.item]
            if let name: String = dict["subcategory"] as? String {
                cell.lblCategory.text = name
            }
            if indexPath.item == secondSelectedIndex {
                c = COLOR_THEME_BLUE
                f = UIFont(name: DIODRUM_SEMIBOLD, size: 18)!
            }
            cell.lblCategory.textColor = c
            cell.lblCategory.font = f
            return cell
        }
    }
    
    //MARK:- UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView .deselectItem(at: indexPath, animated: true)
        if collectionView == firstCollectionView {
            firstSelectedIndex = indexPath.item
            self.SubCategoryList()
        }
        else {
            secondSelectedIndex = indexPath.item
            secondCollectionView.reloadData()
            MyFeed()
        }
    }
    
    //MARK:- UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,sizeForItemAt indexPath:IndexPath ) -> CGSize {
        var str: String = ""
        if collectionView == firstCollectionView {
            let dict: [String: Any] = categoriesArray[indexPath.item]
            if let name: String = dict["category"] as? String {
                str = name
            }
        }
        else {
            let dict: [String: Any] = subCategoriesArray[indexPath.item]
            if let name: String = dict["subcategory"] as? String {
                str = name
            }
        }
        let size = (str as NSString).size(withAttributes: [NSAttributedStringKey.font: UIFont(name: DIODRUM_MEDIUM, size: 20) as Any])
        return CGSize(width: size.width+20, height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    //MARK: - UITableViewDataSource -
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeedTableViewCell") as! FeedTableViewCell
        //cell.imgView.sd_setImage(with: URL(string: BASE_IMAGE_PATH + tempImagesArray[indexPath.row % 4]), placeholderImage: #imageLiteral(resourceName: "Default"), completed: nil)
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
        if let img: String = dict["baseImage"] as? String {
            cell.imgView.sd_setImage(with: URL(string: BASE_IMAGE_PATH + img), placeholderImage: #imageLiteral(resourceName: "Default"), completed: nil)
        }
        return cell
    }
    
    //MARK: - UITableViewDelegate -
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        performSegue(withIdentifier: "eventDetailSegue", sender: self)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
    
    //MARK:- API
    
    func CategoryList() {
        categoriesArray = []
        subCategoriesArray = []
        eventsArray = []
        firstCollectionView.reloadData()
        secondCollectionView.reloadData()
        feedTableView.reloadData()
        let actInd: UIActivityIndicatorView = self.showProgInd(vw: firstCollectionView)
        let api = APIManager()
        api.get(toURL: API_CATEGORY_LIST!, params: [:], responseType: .JSON, progress: { (progress) in
        }, success: { (response) in
            self.hideProgressIndicator(actInd: actInd)
            let dict = response.dictionary
            print(dict)
            if let status = dict["status"] as? Int {
                if status == SUCCESS {
                    self.categoriesArray = dict["categorylist"] as! [[String: Any]]
                    self.sortArray()
                }
                else {
                    self.showMessage(message: "No categories found.")
                }
            }
            self.firstSelectedIndex = 0
            self.secondSelectedIndex = 0
            self.firstCollectionView.reloadData()
            self.secondCollectionView.reloadData()
            self.SubCategoryList()
        }, failure: { (response) in
            self.hideProgressIndicator(actInd: actInd)
            if let errorString = response.dictionary["error"] as? [String: Any] {
                self.showMessage(message: errorString.description)
            }
        })
    }
    
    func MyCategories() {
        if let userId: String = UserDefaults.standard.string(forKey: "userId") {
            categoriesArray = []
            subCategoriesArray = []
            firstCollectionView.reloadData()
            secondCollectionView.reloadData()
            let actInd: UIActivityIndicatorView = self.showProgInd(vw: firstCollectionView)
            let api = APIManager()
            api.post(toURL: API_MY_CATEGORIES!, params: ["userId": userId], responseType: .JSON, progress: { (progress) in
            }, success: { (response) in
                self.hideProgressIndicator(actInd: actInd)
                let dict = response.dictionary
                print(dict)
                if let status = dict["status"] as? Int {
                    if status == SUCCESS {
                        self.categoriesArray = dict["categorylist"] as! [[String: Any]]
                        self.sortArray()
                    }
                    else {
                        self.showMessage(message: "No categories found.")
                    }
                }
                self.firstSelectedIndex = 0
                self.secondSelectedIndex = 0
                self.firstCollectionView.reloadData()
                self.secondCollectionView.reloadData()
                self.SubCategoryList()
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
    
    func SubCategoryList() {
        if categoriesArray.count != 0 {
            let dict: [String: Any] = categoriesArray[firstSelectedIndex]
            if let catID: String = dict["id"] as? String {
                subCategoriesArray = []
                secondCollectionView.reloadData()
                let actInd: UIActivityIndicatorView = self.showProgInd(vw: secondCollectionView)
                let api = APIManager()
                api.post(toURL: API_SUBCATEGORY_LIST!, params: ["categoryId": catID], responseType: .JSON, progress: { (progress) in
                }, success: { (response) in
                    self.hideProgressIndicator(actInd: actInd)
                    let dict = response.dictionary
                    print(dict)
                    if let status = dict["status"] as? Int {
                        if status == SUCCESS {
                            self.subCategoriesArray = dict["subcategories"] as! [[String: Any]]
                            self.sortArray()
                        }
                        else {
                            self.showMessage(message: "No subcategories found.")
                        }
                    }
                    self.secondSelectedIndex = 0
                    self.firstCollectionView.reloadData()
                    self.secondCollectionView.reloadData()
                    let deadlineTime = DispatchTime.now()
                    DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
                        self.MyFeed()
                    }
                }, failure: { (response) in
                    self.hideProgressIndicator(actInd: actInd)
                    if let errorString = response.dictionary["error"] as? [String: Any] {
                        self.showMessage(message: errorString.description)
                    }
                })
            }
        }
    }
    
    func MyFeed() {
        if let userId: String = UserDefaults.standard.string(forKey: "userId") {
            let eventCityId: Int = UserDefaults.standard.integer(forKey: "eventCityId")
            if categoriesArray.count != 0 {
                let dict1: [String: Any] = categoriesArray[firstSelectedIndex]
                if let catID: String = dict1["id"] as? String {
                    self.eventsArray = []
                    self.feedTableView.reloadData()
                    if subCategoriesArray.count != 0 {
                        let dict2: [String: Any] = subCategoriesArray[secondSelectedIndex]
                        if let subCatID: String = dict2["id"] as? String {
                            let actInd: UIActivityIndicatorView = self.showProgressIndicator()
                            let api = APIManager()
                            api.post(toURL: API_MY_FEED!, params: ["userId": userId, "eventCityId": eventCityId, "dateRange": 2, "categoryId": catID, "subCategoryId": subCatID], responseType: .JSON, progress: { (progress) in
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
                                self.feedTableView.reloadData()
                            }, failure: { (response) in
                                self.hideProgressIndicator(actInd: actInd)
                                if let errorString = response.dictionary["error"] as? [String: Any] {
                                    self.showMessage(message: errorString.description)
                                }
                            })
                        }
                    }
                }
            }
        }
        else {
            self.showMessage(message: ERROR_MSG_USER_NOT_FOUND)
        }
    }
    
    func sortArray() {
        let descriptor: NSSortDescriptor =  NSSortDescriptor(key: "id", ascending: true, selector: #selector(NSString.caseInsensitiveCompare(_:)))
        var sortedArray: NSArray = (self.categoriesArray as NSArray).sortedArray(using: [descriptor]) as NSArray
        self.categoriesArray = NSMutableArray(array: sortedArray) as! [[String : Any]]
        print(self.categoriesArray)
        sortedArray = (self.subCategoriesArray as NSArray).sortedArray(using: [descriptor]) as NSArray
        self.subCategoriesArray = NSMutableArray(array: sortedArray) as! [[String : Any]]
        print(self.subCategoriesArray)
    }
    
    func showProgInd(vw: UIView) -> UIActivityIndicatorView {
        let myActInd = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
        myActInd.center = vw.center
        myActInd.color = COLOR_THEME_BLUE
        myActInd.startAnimating()
        vw.addSubview(myActInd)
        vw.bringSubview(toFront: myActInd)
        return myActInd
    }
}
