//
//  UpdatePasswordViewController.swift
//  Wander
//
//  Created by IOS on 3/31/18.
//  Copyright © 2018 IOS. All rights reserved.
//

import UIKit

class UpdatePasswordViewController: UITableViewController, UITextFieldDelegate {

    @IBOutlet var pswdBGView: UIView!
    @IBOutlet var cnfmPswdBGView: UIView!
    @IBOutlet var pswdTextField: UITextField!
    @IBOutlet var cnfmPswdTextField: UITextField!
    @IBOutlet var submitButton: UIButton!
    
    var isFromProfile: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pswdBGView.applyBorder(color: COLOR_THEME_DARK_ASH)
        cnfmPswdBGView.applyBorder(color: COLOR_THEME_DARK_ASH)
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
        pswdTextField.resignFirstResponder()
        cnfmPswdTextField.resignFirstResponder()
        
        if isFromProfile == true {
            let vc: CongratsViewController = self.storyboard?.instantiateViewController(withIdentifier: "CongratsViewController") as! CongratsViewController
            vc.isFromProfile = self.isFromProfile
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else {
            if pswdTextField.text?.isEmpty == true {
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
                ChangePassword()
            }
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
        switch textField {
        case pswdTextField:
            pswdTextField.resignFirstResponder()
            cnfmPswdTextField.becomeFirstResponder()
            break
        default:
            cnfmPswdTextField.resignFirstResponder()
            break
        }
        return true
    }
    
    //MARK:- API
    
    func ChangePassword() {
        if let userId: String = UserDefaults.standard.string(forKey: "userId") {
            let actInd: UIActivityIndicatorView = self.showProgressIndicator()
            let api = APIManager()
            api.post(toURL: API_CHANGE_PASSWORD!, params: ["userId": userId, "password": pswdTextField.text!], responseType: .JSON, progress: { (progress) in
            }, success: { (response) in
                self.hideProgressIndicator(actInd: actInd)
                let dict = response.dictionary
                if let status = dict["status"] as? Int {
                    if status == SUCCESS {
                        let vc: CongratsViewController = self.storyboard?.instantiateViewController(withIdentifier: "CongratsViewController") as! CongratsViewController
                        vc.isFromProfile = self.isFromProfile
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                    else {
                        self.showMessage(message: "Update password failed.")
                    }
                }
            }, failure: { (response) in
                self.hideProgressIndicator(actInd: actInd)
                if let errorString = response.dictionary["error"] {
                    self.showMessage(message: errorString as! String)
                }
            })
        }
    }
}
