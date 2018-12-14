//
//  AddEventFourthViewController.swift
//  Wander
//
//  Created by IOS on 7/20/18.
//  Copyright © 2018 IOS. All rights reserved.
//

import UIKit

class AddEventFourthViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet var eventHeightConstraint: NSLayoutConstraint!
    @IBOutlet var firstCollectionBGView: UIView!
    @IBOutlet var firstCollectionView: UICollectionView!
    @IBOutlet var secondCollectionBGView: UIView!
    @IBOutlet var secondCollectionView: UICollectionView!
    
    var categoriesArray: [[String: Any]] = []
    var subCategoriesArray: [[String: Any]] = []
    var firstSelectedIndex: Int = 0
    var secondSelectedArray: [Int] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        eventHeightConstraint.constant = 600
        
        firstCollectionBGView.layer.shadowColor = UIColor.black.cgColor
        firstCollectionBGView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        firstCollectionBGView.layer.shadowOpacity = 0.5
        firstCollectionBGView.layer.shadowRadius = 10.0
        
        secondCollectionBGView.layer.shadowColor = UIColor.black.cgColor
        secondCollectionBGView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        secondCollectionBGView.layer.shadowOpacity = 0.5
        secondCollectionBGView.layer.shadowRadius = 10.0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //MyCategories()
        CategoryList()
    }
    
    //MARK:- Button Actions
    
    @IBAction func backBtnAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func nextBtnAction(_ sender: Any) {
        addEventDict["category"] = firstSelectedIndex + 1
        var subCatArr: [Int] = []
        for item in secondSelectedArray {
            subCatArr.append(item + 1)
        }
        addEventDict["subcategory"] = subCatArr[0]
        let vc: AddEventFifthViewController = storyboard?.instantiateViewController(withIdentifier: "AddEventFifthViewController") as! AddEventFifthViewController
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
            if secondSelectedArray.contains(indexPath.item) {
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
            SubCategoryList()
        }
        else {
            if secondSelectedArray.contains(indexPath.item) {
                secondSelectedArray.remove(at: secondSelectedArray.index(of: indexPath.item)!)
            }
            else {
                secondSelectedArray = []
                secondSelectedArray.append(indexPath.item)
            }
            secondCollectionView.reloadData()
        }
        print(secondSelectedArray)
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
    
    //MARK:- API
    
    func CategoryList() {
        categoriesArray = []
        subCategoriesArray = []
        firstCollectionView.reloadData()
        secondCollectionView.reloadData()
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
                }
                else {
                    self.showMessage(message: "No categories found.")
                }
            }
            self.firstSelectedIndex = 0
            self.secondSelectedArray = []
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
                    }
                    else {
                        self.showMessage(message: "No categories found.")
                    }
                }
                self.firstSelectedIndex = 0
                self.secondSelectedArray = []
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
                        }
                        else {
                            self.showMessage(message: "No subcategories found.")
                        }
                    }
                    self.secondSelectedArray = []
                    self.firstCollectionView.reloadData()
                    self.secondCollectionView.reloadData()
                }, failure: { (response) in
                    self.hideProgressIndicator(actInd: actInd)
                    if let errorString = response.dictionary["error"] as? [String: Any] {
                        self.showMessage(message: errorString.description)
                    }
                })
            }
        }
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
