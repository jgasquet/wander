//
//  AddEventViewController.swift
//  Wander
//
//  Created by IOS on 7/20/18.
//  Copyright © 2018 IOS. All rights reserved.
//

import UIKit

var addEventDict: [String: Any] = [:]

class AddEventViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITextFieldDelegate {

    @IBOutlet var eventHeightConstraint: NSLayoutConstraint!
    @IBOutlet var cityCollectionView: UICollectionView!
    @IBOutlet var nameBGView: UIView!
    @IBOutlet var eventNameTextField: UITextField!
    @IBOutlet var orgBGView: UIView!
    @IBOutlet var orgTextField: UITextField!
    @IBOutlet var ticketBGView: UIView!
    @IBOutlet var ticketTextField: UITextField!
    @IBOutlet var ticketPriceBGView: UIView!
    @IBOutlet var ticketPriceTextField: UITextField!
    @IBOutlet var ticketTypesCollectionView: UICollectionView!
    @IBOutlet var priceView: UIView!
    
    var selectedCityIndex: Int = 0
    var selectedTypeIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameBGView.applyBorder(color: COLOR_THEME_DARK_ASH)
        orgBGView.applyBorder(color: COLOR_THEME_DARK_ASH)
        ticketBGView.applyBorder(color: COLOR_THEME_DARK_ASH)
        ticketPriceBGView.applyBorder(color: COLOR_THEME_DARK_ASH)
        
        eventHeightConstraint.constant = 700
        priceView.isHidden = true
        
        addEventDict = [:]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK:- Button Actions
    
    @IBAction func backBtnAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func nextBtnAction(_ sender: Any) {
        if eventNameTextField.text?.isEmpty == true {
            self.showMessage(message: ERROR_MSG_EVENT_NAME_BLANK)
        } else if orgTextField.text?.isEmpty == true {
            self.showMessage(message: ERROR_MSG_ORG_NAME_BLANK)
        } else if ticketTextField.text?.isEmpty == true {
            self.showMessage(message: ERROR_MSG_TICKET_BLANK)
        } else if (selectedTypeIndex != 0) && (ticketPriceTextField.text?.isEmpty == true) {
            self.showMessage(message: ERROR_MSG_PRICE_BLANK)
        } else {
            addEventDict["eventName"] = eventNameTextField.text!
            addEventDict["eventCityId"] = selectedCityIndex + 1
            addEventDict["orgName"] = orgTextField.text!
            addEventDict["totalTicket"] = ticketTextField.text!
            addEventDict["ticketTypeId"] = selectedTypeIndex + 1
            selectedTypeIndex == 0 ? (addEventDict["ticketPrice"] = String(0)) : (addEventDict["ticketPrice"] = ticketPriceTextField.text!)
            let vc: AddEventSecondViewController = storyboard?.instantiateViewController(withIdentifier: "AddEventSecondViewController") as! AddEventSecondViewController
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    //MARK:- UITextFieldDelegate
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //MARK:- UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionView == cityCollectionView ? cityArray.count : ticketTypesArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ExploreForCollectionViewCell", for: indexPath as IndexPath) as! ExploreForCollectionViewCell
        cell.btnName.applyBorderAndShadow(color: COLOR_THEME_BLUE)
        cell.btnName.applyCornerRadius()
        
        if collectionView == cityCollectionView {
            cell.btnName.setTitle(cityArray[indexPath.item], for: .normal)
            cell.btnName.tag = indexPath.row
            cell.btnName.addTarget(self, action: #selector(self.cityButtonTapped), for: .touchUpInside)
            indexPath.item == selectedCityIndex ? (cell.btnName.isSelected = true) : (cell.btnName.isSelected = false)
        }
        else {
            cell.btnName.setTitle(ticketTypesArray[indexPath.item], for: .normal)
            cell.btnName.tag = indexPath.row
            cell.btnName.addTarget(self, action: #selector(self.typesButtonTapped), for: .touchUpInside)
            indexPath.item == selectedTypeIndex ? (cell.btnName.isSelected = true) : (cell.btnName.isSelected = false)
        }
        return cell
    }
    
    //MARK:- UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView .deselectItem(at: indexPath, animated: true)
    }
    
    //MARK:- UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,sizeForItemAt indexPath:IndexPath ) -> CGSize {
        if collectionView == cityCollectionView {
            let size = (cityArray[indexPath.item] as NSString).size(withAttributes: [NSAttributedStringKey.font: UIFont(name: DIODRUM_MEDIUM, size: 20) as Any])
            return CGSize(width: size.width+20, height: 40)
        }
        else {
            let size = (ticketTypesArray[indexPath.item] as NSString).size(withAttributes: [NSAttributedStringKey.font: UIFont(name: DIODRUM_MEDIUM, size: 20) as Any])
            return CGSize(width: size.width+20, height: 40)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    @objc func cityButtonTapped(sender: UIButton){
        selectedCityIndex = sender.tag
        cityCollectionView.reloadData()
    }
    
    @objc func typesButtonTapped(sender: UIButton){
        selectedTypeIndex = sender.tag
        ticketTypesCollectionView.reloadData()
        selectedTypeIndex == 0 ? (priceView.isHidden = true) : (priceView.isHidden = false)
    }
}
