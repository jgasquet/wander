//
//  PlanVisitViewController.swift
//  Wander
//
//  Created by IOS on 4/19/18.
//  Copyright © 2018 IOS. All rights reserved.
//

import UIKit

class PlanVisitViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet var planHeightConstraint: NSLayoutConstraint!
    @IBOutlet var cityCollectionView: UICollectionView!
    @IBOutlet var arrivalCollectionView: UICollectionView!
    @IBOutlet var departureCollectionView: UICollectionView!
    @IBOutlet var travellingCollectionView: UICollectionView!
    @IBOutlet var lblArrDateTime: UILabel!
    @IBOutlet var lblDeptDateTime: UILabel!
    
    let arrDepArray: [String] = ["Cab Booking", "Book Hotel", "Book Flight"]
    let travelArray: [String] = ["Solo", "Family/Friends"]
    
    var selectedCityIndex: Int = 0
    var selectedArrivalIndex: Int = 0
    var selectedDepartureIndex: Int = 0
    var selectedTravelIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        planHeightConstraint.constant = 600
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK:- Button Actions
    
    @IBAction func backBtnAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    //MARK:- UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case cityCollectionView:
            return cityArray.count
        case arrivalCollectionView, departureCollectionView:
            return arrDepArray.count
        case travellingCollectionView:
            return travelArray.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ExploreForCollectionViewCell", for: indexPath as IndexPath) as! ExploreForCollectionViewCell
        cell.btnName.applyBorderAndShadow(color: COLOR_THEME_BLUE)
        cell.btnName.applyCornerRadius()
        switch collectionView {
        case cityCollectionView:
            cell.btnName.setTitle(cityArray[indexPath.item], for: .normal)
            cell.btnName.tag = indexPath.row
            cell.btnName.addTarget(self, action: #selector(self.cityButtonTapped), for: .touchUpInside)
            indexPath.item == selectedCityIndex ? (cell.btnName.isSelected = true) : (cell.btnName.isSelected = false)
            break
        case arrivalCollectionView:
            cell.btnName.setTitle(arrDepArray[indexPath.item], for: .normal)
            cell.btnName.tag = indexPath.row
            cell.btnName.addTarget(self, action: #selector(self.arrivalButtonTapped), for: .touchUpInside)
            indexPath.item == selectedArrivalIndex ? (cell.btnName.isSelected = true) : (cell.btnName.isSelected = false)
            break
        case departureCollectionView:
            cell.btnName.setTitle(arrDepArray[indexPath.item], for: .normal)
            cell.btnName.tag = indexPath.row
            cell.btnName.addTarget(self, action: #selector(self.departureButtonTapped), for: .touchUpInside)
            indexPath.item == selectedDepartureIndex ? (cell.btnName.isSelected = true) : (cell.btnName.isSelected = false)
            break
        case travellingCollectionView:
            cell.btnName.setTitle(travelArray[indexPath.item], for: .normal)
            cell.btnName.tag = indexPath.row
            cell.btnName.addTarget(self, action: #selector(self.travelButtonTapped), for: .touchUpInside)
            indexPath.item == selectedTravelIndex ? (cell.btnName.isSelected = true) : (cell.btnName.isSelected = false)
            break
        default:
            break
        }
        return cell
    }
    
    //MARK:- UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView .deselectItem(at: indexPath, animated: true)
    }
    
    //MARK:- UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,sizeForItemAt indexPath:IndexPath ) -> CGSize {
        var arr = collectionView == cityCollectionView ? cityArray : collectionView == arrivalCollectionView ? arrDepArray : collectionView == departureCollectionView ? arrDepArray : collectionView == travellingCollectionView ? travelArray : travelArray
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
    
    @objc func arrivalButtonTapped(sender: UIButton){
        selectedArrivalIndex = sender.tag
        arrivalCollectionView.reloadData()
    }
    
    @objc func departureButtonTapped(sender: UIButton){
        selectedDepartureIndex = sender.tag
        departureCollectionView.reloadData()
    }
    
    @objc func travelButtonTapped(sender: UIButton){
        selectedTravelIndex = sender.tag
        travellingCollectionView.reloadData()
    }
}
