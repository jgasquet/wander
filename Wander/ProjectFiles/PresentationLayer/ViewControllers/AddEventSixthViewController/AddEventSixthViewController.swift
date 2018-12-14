//
//  AddEventSixthViewController.swift
//  Wander
//
//  Created by IOS on 7/20/18.
//  Copyright © 2018 IOS. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class AddEventSixthViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet var eventHeightConstraint: NSLayoutConstraint!
    @IBOutlet var tagsCollectionView: UICollectionView!
    @IBOutlet var tagBGView: UIView!
    @IBOutlet var tagTextField: UITextField!
    @IBOutlet var selectedHeightConstraint: NSLayoutConstraint!
    
    var selectedArray: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        eventHeightConstraint.constant = 600
        selectedHeightConstraint.constant = 0
        
        tagBGView.applyBorder(color: COLOR_THEME_DARK_ASH)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK:- Button Actions
    
    @IBAction func backBtnAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func addBtnAction(_ sender: Any) {
        if tagTextField.text?.isEmpty == false {
            if !selectedArray.contains(tagTextField.text!) {
                selectedArray.append(tagTextField.text!)
                tagsCollectionView.reloadData()
            }
            tagTextField.text = ""
        }
        hideUnhideView()
    }
    @IBAction func submitBtnAction(_ sender: Any) {
        addEventDict["tags"] = selectedArray
        print(addEventDict)
        AddEvent()
        //navigationController?.popToRootViewController(animated: true)
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
        cell.lblCategory.text = "#" + selectedArray[indexPath.item]
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
        hideUnhideView()
        tagsCollectionView.reloadData()
    }
    
    func hideUnhideView() {
        if selectedArray.count == 0 {
            selectedHeightConstraint.constant = 0
        }
        else {
            selectedHeightConstraint.constant = 100
        }
    }
    
    //MARK:- API
    
    func AddEvent() {
        print(addEventDict)
        if let userId: String = UserDefaults.standard.string(forKey: "userId") {
            let actInd: UIActivityIndicatorView = self.showProgressIndicator()
            
            let startDateTime: String = addEventDict["startDateTime"] as! String
            var indexStartDate = startDateTime.index(startDateTime.startIndex, offsetBy: 0)
            var indexEndDate = startDateTime.index(startDateTime.startIndex, offsetBy: 10)
            let startDate: String = String(startDateTime[indexStartDate..<indexEndDate])
            var indexStartTime = startDateTime.index(startDateTime.endIndex, offsetBy: -8)
            var indexEndTime = startDateTime.index(startDateTime.endIndex, offsetBy: 0)
            let startTime: String = String(startDateTime[indexStartTime..<indexEndTime])
            
            let endDateTime: String = addEventDict["endDateTime"] as! String
            indexStartDate = endDateTime.index(endDateTime.startIndex, offsetBy: 0)
            indexEndDate = endDateTime.index(endDateTime.startIndex, offsetBy: 10)
            let endDate: String = String(endDateTime[indexStartDate..<indexEndDate])
            indexStartTime = endDateTime.index(endDateTime.endIndex, offsetBy: -8)
            indexEndTime = endDateTime.index(endDateTime.endIndex, offsetBy: 0)
            let endTime: String = String(endDateTime[indexStartTime..<indexEndTime])
            
            /*let typeArr: [[String: Any]] = [["categoryId": addEventDict["category"]!,
                                           "subCategoryId": addEventDict["subcategory"]!]]
            let tagsArr: [[String: Any]] = [["tag": addEventDict["tags"]!]]*/
            let photosArr: [Data] = addEventDict["photos"] as! [Data]
            
            let parameters: [String: Any] = ["userId": userId,
                                             "eventName": addEventDict["eventName"]!,
                                             "eventCityId": addEventDict["eventCityId"]!,
                                             "venue": addEventDict["venue"]!,
                                             "address": addEventDict["address"]!,
                                             "location": addEventDict["location"]!,
                                             "lat": addEventDict["lat"]!,
                                             "long": addEventDict["lng"]!,
                                             "startDate": startDate,
                                             "startTime": startTime,
                                             "endDate": endDate,
                                             "endTime": endTime,
                                             "organizerName": addEventDict["orgName"]!,
                                             "totalTickets": addEventDict["totalTicket"]!,
                                             "ticketTypeId": addEventDict["ticketTypeId"]!,
                                             "price": addEventDict["ticketPrice"]!,
                                             "phoneNo": addEventDict["phoneNo"]!,
                                             "website": addEventDict["website"]!,
                                             "details": addEventDict["details"]!,
                                             "type[0][categoryId]": addEventDict["category"]!,
                                             "type[0][subCategoryId]": addEventDict["subcategory"]!,
                                             "tags[0][tag]": 1/*addEventDict["tags"]!*/]
            
            let headers: HTTPHeaders = ["x-api-key": API_AUTH_KEY]
            
            Alamofire.upload(multipartFormData: { (multipartFormData) in
                for (key, value) in parameters {
                    multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key)
                }
                var c: Int = 0
                for photo in photosArr {
                    c = c + 1
                    multipartFormData.append(photo, withName: "photos[]", fileName: "image_\(c).jpg", mimeType: "image/jpg")
                }
                
            }, usingThreshold: UInt64.init(), to: API_ADD_EVENT!, method: .post, headers: headers) { (result) in
                switch result {
                case .success(let upload, _, _):
                    upload.uploadProgress(closure: { (Progress) in
                        print("Upload Progress: \(Progress.fractionCompleted)")
                    })
                    upload.responseJSON { response in
                        self.hideProgressIndicator(actInd: actInd)
                        print(response.result)
                        if let JSON = response.result.value {
                            let dict: [String: Any] = JSON as! [String : Any]
                            print(dict)
                            self.navigationController?.popToRootViewController(animated: true)
                        }
                    }
                case .failure(let encodingError):
                    print(encodingError)
                }
            }
            
            /*api.post(toURL: API_ADD_EVENT!, params: dict, responseType: .JSON, progress: { (progress) in
            }, success: { (response) in
                self.hideProgressIndicator(actInd: actInd)
                let dict = response.dictionary
                print(dict)
                if let status = dict["status"] as? Int {
                    if status == SUCCESS {
                        print("SUCCESS")
                    }
                }
                self.navigationController?.popToRootViewController(animated: true)
            }, failure: { (response) in
                self.hideProgressIndicator(actInd: actInd)
                if let errorString = response.dictionary["error"] as? [String: Any] {
                    self.showMessage(message: errorString.description)
                }
            })*/
        }
        else {
            self.showMessage(message: ERROR_MSG_USER_NOT_FOUND)
        }
    }
}
