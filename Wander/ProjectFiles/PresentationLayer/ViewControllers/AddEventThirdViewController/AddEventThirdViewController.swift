//
//  AddEventThirdViewController.swift
//  Wander
//
//  Created by IOS on 7/20/18.
//  Copyright © 2018 IOS. All rights reserved.
//

import UIKit
import CoreLocation

class AddEventThirdViewController: UIViewController, UITextFieldDelegate, CLLocationManagerDelegate {

    @IBOutlet var eventHeightConstraint: NSLayoutConstraint!
    @IBOutlet var venueBGView: UIView!
    @IBOutlet var venueTextField: UITextField!
    @IBOutlet var adrsBGView: UIView!
    @IBOutlet var adrsTextField: UITextField!
    @IBOutlet var locationBGView: UIView!
    @IBOutlet var locationTextField: UITextField!
    @IBOutlet var dateTimePicker: UIDatePicker!
    @IBOutlet var doneButton: UIButton!
    @IBOutlet var startDateTimeLabel: UILabel!
    @IBOutlet var endDateTimeLabel: UILabel!
    
    var START_OR_END: String = ""
    let START: String = "START"
    var END: String = "END"
    let locationManager = CLLocationManager()
    var currentLat: Double = 0.0
    var currentLng: Double = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        venueBGView.applyBorder(color: COLOR_THEME_DARK_ASH)
        adrsBGView.applyBorder(color: COLOR_THEME_DARK_ASH)
        locationBGView.applyBorder(color: COLOR_THEME_DARK_ASH)
        
        eventHeightConstraint.constant = 600
        
        dateTimePicker.backgroundColor = UIColor.init(red: 230.0/255.0, green: 230.0/255.0, blue: 230.0/255.0, alpha: 1.0)
        dateTimePicker.isHidden = true
        doneButton.isHidden = true
        dateTimePicker.minimumDate = Date()
        
        let currentDate = Date()
        let formatter = DateFormatter()
        //formatter.dateFormat = "dd/MM/yyyy hh:mm a"
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        let date = formatter.string(from: currentDate)
        print(date)
        startDateTimeLabel.text = date + ":00"
        endDateTimeLabel.text = date + ":00"
        
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK:- CLLocationManagerDelegate
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        currentLat = locValue.latitude
        currentLng = locValue.longitude
        print("locations = \(currentLat) \(currentLng)")
        getAddressFromLatLon(Latitude: currentLat, withLongitude: currentLng)
    }
    
    func getAddressFromLatLon(Latitude: Double, withLongitude Longitude: Double) {
        var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
        let ceo: CLGeocoder = CLGeocoder()
        center.latitude = Latitude
        center.longitude = Longitude
        
        let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)
        
        ceo.reverseGeocodeLocation(loc, completionHandler:
            {(placemarks, error) in
                if (error != nil)
                {
                    print("reverse geodcode fail: \(error!.localizedDescription)")
                }
                let pm = placemarks! as [CLPlacemark]
                
                if pm.count > 0 {
                    let pm = placemarks![0]
                    var addressString : String = ""
                    if pm.subLocality != nil {
                        addressString = addressString + pm.subLocality! + ", "
                    }
                    if pm.thoroughfare != nil {
                        addressString = addressString + pm.thoroughfare! + ", "
                    }
                    if pm.subThoroughfare != nil {
                        addressString = addressString + pm.subThoroughfare! + ", "
                    }
                    addressString.removeLast()
                    addressString.removeLast()
                    print(addressString)
                    self.adrsTextField.text = addressString
                    
                    var locationString : String = ""
                    if pm.locality != nil {
                        locationString = locationString + pm.locality! + ", "
                    }
                    if pm.country != nil {
                        locationString = locationString + pm.country! + ", "
                    }
                    if pm.postalCode != nil {
                        locationString = locationString + pm.postalCode! + ", "
                    }
                    locationString.removeLast()
                    locationString.removeLast()
                    print(locationString)
                    self.locationTextField.text = locationString
                }
        })
    }
    
    //MARK:- Button Actions
    
    @IBAction func backBtnAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func startBtnAction(_ sender: Any) {
        START_OR_END = START
        dateTimePicker.date = Date()
        dateTimePicker.showWithAnimation()
        doneButton.showWithAnimation()
    }
    @IBAction func endBtnAction(_ sender: Any) {
        START_OR_END = END
        dateTimePicker.date = Date()
        dateTimePicker.showWithAnimation()
        doneButton.showWithAnimation()
    }
    @IBAction func doneBtnAction(_ sender: Any) {
        dateTimePicker.hideWithAnimation()
        doneButton.hideWithAnimation()
        let formatter = DateFormatter()
        //formatter.dateFormat = "dd/MM/yyyy hh:mm a"
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        let date = formatter.string(from: dateTimePicker.date)
        print(date)
        START_OR_END == START ? (startDateTimeLabel.text = date + ":00") : (endDateTimeLabel.text = date + ":00")
    }
    @IBAction func nextBtnAction(_ sender: Any) {
        if venueTextField.text?.isEmpty == true {
            self.showMessage(message: ERROR_MSG_VENUE_BLANK)
        } else if adrsTextField.text?.isEmpty == true {
            self.showMessage(message: ERROR_MSG_ADRS_BLANK)
        } else if locationTextField.text?.isEmpty == true {
            self.showMessage(message: ERROR_MSG_LOCATION_BLANK)
        } else {
            addEventDict["venue"] = venueTextField.text!
            addEventDict["address"] = adrsTextField.text!
            addEventDict["location"] = locationTextField.text!
            addEventDict["startDateTime"] = startDateTimeLabel.text!
            addEventDict["endDateTime"] = endDateTimeLabel.text!
            addEventDict["lat"] = currentLat
            addEventDict["lng"] = currentLng
            let vc: AddEventFourthViewController = storyboard?.instantiateViewController(withIdentifier: "AddEventFourthViewController") as! AddEventFourthViewController
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
}
