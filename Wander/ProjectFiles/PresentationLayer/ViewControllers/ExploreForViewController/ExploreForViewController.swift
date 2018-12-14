//
//  ExploreForViewController.swift
//  Wander
//
//  Created by IOS on 4/18/18.
//  Copyright © 2018 IOS. All rights reserved.
//

import UIKit

class ExploreForViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet var cityCollectionView: UICollectionView!
    @IBOutlet var dayTimeCollectionView: UICollectionView!
    @IBOutlet var fromDateLabel: UILabel!
    @IBOutlet var toDateLabel: UILabel!
    @IBOutlet var expDatePicker: UIDatePicker!
    @IBOutlet var doneButton: UIButton!
    
    var selectedCityIndex: Int = 0
    var selectedDayTimeIndex: Int = 0
    var FROM_OR_TO: String = ""
    let FROM: String = "FROM"
    let TO: String = "TO"
    var selectedCity: String = ""
    var selectedDayTime: String = ""
    var callBack: ((_ dict: [String: Any]) -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        expDatePicker.backgroundColor = UIColor.init(red: 230.0/255.0, green: 230.0/255.0, blue: 230.0/255.0, alpha: 1.0)
        expDatePicker.isHidden = true
        doneButton.isHidden = true
        expDatePicker.minimumDate = Date()
        
        let currentDate = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        let date = formatter.string(from: currentDate)
        print(date)
        fromDateLabel.text = date
        toDateLabel.text = date
        
        if cityArray.contains(selectedCity) {
            selectedCityIndex = cityArray.index(of: selectedCity)!
        }
        cityCollectionView.reloadData()
        if dayTimeArray.contains(selectedDayTime) {
            selectedDayTimeIndex = dayTimeArray.index(of: selectedDayTime)!
        }
        dayTimeCollectionView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK:- Button Actions
    
    @IBAction func backBtnAction(_ sender: Any) {
        let dict: [String: Any] = ["city": cityArray[selectedCityIndex], "date": dayTimeArray[selectedDayTimeIndex], "cityId": selectedCityIndex+1, "dateId": selectedDayTimeIndex]
        callBack!(dict)
        navigationController?.popViewController(animated: true)
    }
    @IBAction func fromBtnAction(_ sender: Any) {
        FROM_OR_TO = FROM
        expDatePicker.date = Date()
        expDatePicker.showWithAnimation()
        doneButton.showWithAnimation()
    }
    @IBAction func toBtnAction(_ sender: Any) {
        FROM_OR_TO = TO
        expDatePicker.date = Date()
        expDatePicker.showWithAnimation()
        doneButton.showWithAnimation()
    }
    @IBAction func doneBtnAction(_ sender: Any) {
        expDatePicker.hideWithAnimation()
        doneButton.hideWithAnimation()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        let date = formatter.string(from: expDatePicker.date)
        print(date)
        FROM_OR_TO == FROM ? (fromDateLabel.text = date) : (toDateLabel.text = date)
    }
    @IBAction func searchBtnAction(_ sender: Any) {
        let dict: [String: Any] = ["city": cityArray[selectedCityIndex], "date": dayTimeArray[selectedDayTimeIndex], "cityId": selectedCityIndex+1, "dateId": selectedDayTimeIndex]
        callBack!(dict)
        navigationController?.popViewController(animated: true)
    }
    
    //MARK:- UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionView == cityCollectionView ? cityArray.count : dayTimeArray.count
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
            cell.btnName.setTitle(dayTimeArray[indexPath.item], for: .normal)
            cell.btnName.tag = indexPath.row
            cell.btnName.addTarget(self, action: #selector(self.dayTimeButtonTapped), for: .touchUpInside)
            indexPath.item == selectedDayTimeIndex ? (cell.btnName.isSelected = true) : (cell.btnName.isSelected = false)
        }
        return cell
    }
    
    //MARK:- UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView .deselectItem(at: indexPath, animated: true)
    }
    
    //MARK:- UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,sizeForItemAt indexPath:IndexPath ) -> CGSize {
        var arr = collectionView == cityCollectionView ? cityArray : dayTimeArray
        let size = (arr[indexPath.item] as NSString).size(withAttributes: [NSAttributedStringKey.font: UIFont(name: DIODRUM_MEDIUM, size: 20) as Any])
        return CGSize(width: size.width+20, height: 40)
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
    
    @objc func dayTimeButtonTapped(sender: UIButton){
        selectedDayTimeIndex = sender.tag
        dayTimeCollectionView.reloadData()
    }
}
