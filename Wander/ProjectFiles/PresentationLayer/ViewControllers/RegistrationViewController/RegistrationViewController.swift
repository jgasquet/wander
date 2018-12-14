//
//  RegistrationViewController.swift
//  Wander
//
//  Created by IOS on 3/31/18.
//  Copyright © 2018 IOS. All rights reserved.
//

import UIKit

class RegistrationViewController: UITableViewController, UITextFieldDelegate {

    @IBOutlet var txtFldCollection: [UITextField]!
    @IBOutlet var BGViewCollection: [UIView]!
    
    @IBOutlet var nameBGView: UIView!
    @IBOutlet var emailBGView: UIView!
    @IBOutlet var countryBGView: UIView!
    @IBOutlet var stateBGView: UIView!
    @IBOutlet var cityBGView: UIView!
    @IBOutlet var phoneBGView: UIView!
    @IBOutlet var pswdBGView: UIView!
    @IBOutlet var cnfmPswdBGView: UIView!
    
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var countryTextField: UITextField!
    @IBOutlet var stateTextField: UITextField!
    @IBOutlet var cityTextField: UITextField!
    @IBOutlet var phoneTextField: UITextField!
    @IBOutlet var pswdTextField: UITextField!
    @IBOutlet var cnfmPswdTextField: UITextField!
    
    @IBOutlet var submitButton: UIButton!
    
    var selectedCountry: [String: Any] = [:]
    var selectedState: [String: Any] = [:]
    var selectedCity: [String: Any] = [:]
    
    var isFromProfile: Bool = false
    var callBack: ((_ YesOrNo: Bool) -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for vw in BGViewCollection {
            vw.applyBorder(color: COLOR_THEME_DARK_ASH)
        }
        
        submitButton.applyShadow(color: COLOR_THEME_BLUE)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK:- Button Actions
    
    @IBAction func backBtnAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func submitBtnAction(_ sender: Any) {
        //performSegue(withIdentifier: "RegToCity", sender: self)
        
        for tf in txtFldCollection {
            tf.resignFirstResponder()
        }
        
        if isFromProfile == true {
            callBack!(true)
            navigationController?.popViewController(animated: false)
        }
        else {
            if nameTextField.text?.isEmpty == true {
                self.showMessage(message: ERROR_MSG_NAME_BLANK)
            } else if emailTextField.text?.isEmpty == true {
                self.showMessage(message: ERROR_MSG_EMAIL_BLANK)
            } else if emailTextField.text?.isValidEmail == false {
                self.showMessage(message: ERROR_MSG_EMAIL_INVALID)
            } else if countryTextField.text?.isEmpty == true || selectedCountry.isEmpty == true {
                self.showMessage(message: ERROR_MSG_COUNTRY_BLANK)
            } else if stateTextField.text?.isEmpty == true || selectedState.isEmpty == true {
                self.showMessage(message: ERROR_MSG_STATE_BLANK)
            } else if cityTextField.text?.isEmpty == true || selectedCity.isEmpty == true {
                self.showMessage(message: ERROR_MSG_CITY_BLANK)
            } else if phoneTextField.text?.isEmpty == true {
                self.showMessage(message: ERROR_MSG_PHONE_BLANK)
            } else if pswdTextField.text?.isEmpty == true {
                self.showMessage(message: ERROR_MSG_PASSWORD_BLANK)
            } else if pswdTextField.text?.isValidPasword == false {
                self.showMessage(message: ERROR_MSG_PASSWORD_INVALID)
            } else if cnfmPswdTextField.text?.isEmpty == true {
                self.showMessage(message: ERROR_MSG_CONFIRM_PASSWORD_BLANK)
            } else if cnfmPswdTextField.text?.isValidPasword == false {
                self.showMessage(message: ERROR_MSG_PASSWORD_INVALID)
            } else if pswdTextField.text != cnfmPswdTextField.text {
                self.showMessage(message: ERROR_MSG_PASSWORD_CONFIRM)
            } else {
                Registration()
            }
        }
    }
    
    //MARK:- UITextFieldDelegate
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        switch textField {
        case countryTextField:
            emailTextField.resignFirstResponder()
            let vc: CountryListViewController = storyboard?.instantiateViewController(withIdentifier: "CountryListViewController") as! CountryListViewController
            vc.listType = COUNTRY
            vc.callBack = {(dict: [String: Any]) -> () in
                self.selectedCountry = dict
                self.countryTextField.text = dict["country"] as? String
                self.selectedState = [:]
                self.selectedCity = [:]
                self.stateTextField.text = ""
                self.cityTextField.text = ""
            }
            self.navigationController?.pushViewController(vc, animated: true)
            return false
        case stateTextField:
            let vc: CountryListViewController = storyboard?.instantiateViewController(withIdentifier: "CountryListViewController") as! CountryListViewController
            vc.listType = STATE
            if (countryTextField.text?.isEmpty)! {
                self.showMessage(message: ERROR_MSG_COUNTRY_BLANK)
            }
            else {
                if let id: String = self.selectedCountry["id"] as? String {
                    vc.countryId = Int(id)!
                    vc.callBack = {(dict: [String: Any]) -> () in
                        self.selectedState = dict
                        self.stateTextField.text = dict["state"] as? String
                        self.selectedCity = [:]
                        self.cityTextField.text = ""
                    }
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
            return false
        case cityTextField:
            let vc: CountryListViewController = storyboard?.instantiateViewController(withIdentifier: "CountryListViewController") as! CountryListViewController
            vc.listType = CITY
            if (stateTextField.text?.isEmpty)! {
                self.showMessage(message: ERROR_MSG_STATE_BLANK)
            }
            else {
                if let id: String = self.selectedState["id"] as? String {
                    vc.stateId = Int(id)!
                    vc.callBack = {(dict: [String: Any]) -> () in
                        self.selectedCity = dict
                        self.cityTextField.text = dict["city"] as? String
                    }
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
            return false
        default:
            return true
        }
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
        switch textField {
        case nameTextField:
            emailTextField.becomeFirstResponder()
            break
        case phoneTextField:
            pswdTextField.becomeFirstResponder()
            break
        case pswdTextField:
            cnfmPswdTextField.becomeFirstResponder()
            break
        default:
            textField.resignFirstResponder()
            break
        }
        return true
    }
    
    //MARK:- API
    
    func Registration() {
        let actInd: UIActivityIndicatorView = self.showProgressIndicator()
        let api = APIManager()
        api.post(toURL: API_REGISTRATION!, params: ["name": nameTextField.text!, "emailId": emailTextField.text!, "countryId": selectedCountry["id"]!, "stateId": selectedState["id"]!, "cityId": selectedCity["id"]!, "mobile": phoneTextField.text!, "password": pswdTextField.text!, "loginType": LOGIN_TYPE.PASSWORD.hashValue, "userTypeId": USER_TYPE.VISITOR.hashValue], responseType: .JSON, progress: { (progress) in
        }, success: { (response) in
            self.hideProgressIndicator(actInd: actInd)
            let dict = response.dictionary
            if let status = dict["status"] as? Int {
                if status == SUCCESS {
                    if let userId = dict["userId"] as? String {
                        UserDefaults.standard.set(userId, forKey: "userId")
                    }
                    if let userId = dict["userId"] as? Int {
                        UserDefaults.standard.set(String(userId), forKey: "userId")
                    }
                    if let userTypeId = dict["userTypeId"] as? String {
                        UserDefaults.standard.set(userTypeId, forKey: "userTypeId")
                    }
                    UserDefaults.standard.synchronize()
                    self.performSegue(withIdentifier: "RegToCity", sender: self)
                }
                else {
                    self.showMessage(message: "Registration failed.")
                }
            }
        }, failure: { (response) in
            self.hideProgressIndicator(actInd: actInd)
            if let errorString = response.dictionary["error"] as? String {
                self.showMessage(message: errorString)
            }
        })
    }
}
