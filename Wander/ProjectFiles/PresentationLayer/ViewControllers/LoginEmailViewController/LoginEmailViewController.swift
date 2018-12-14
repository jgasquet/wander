//
//  LoginEmailViewController.swift
//  Wander
//
//  Created by IOS on 3/30/18.
//  Copyright © 2018 IOS. All rights reserved.
//

import UIKit

class LoginEmailViewController: UITableViewController, UITextFieldDelegate {

    @IBOutlet var emailBGView: UIView!
    @IBOutlet var pswdBGView: UIView!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var pswdTextField: UITextField!
    @IBOutlet var loginButton: UIButton!
    
    var isFromProfile: Bool = false
    var callBack: ((_ YesOrNo: Bool) -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailBGView.applyBorder(color: COLOR_THEME_DARK_ASH)
        pswdBGView.applyBorder(color: COLOR_THEME_DARK_ASH)
        loginButton.applyShadow(color: COLOR_THEME_BLUE)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK:- Button Actions
    
    @IBAction func backBtnAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func loginBtnAction(_ sender: Any) {
        emailTextField.resignFirstResponder()
        pswdTextField.resignFirstResponder()
        
        if isFromProfile == true {
            callBack!(true)
            navigationController?.popViewController(animated: false)
        }
        else {
            if emailTextField.text?.isEmpty == true {
                self.showMessage(message: ERROR_MSG_EMAIL_BLANK)
            } else if pswdTextField.text?.isEmpty == true {
                self.showMessage(message: ERROR_MSG_PASSWORD_BLANK)
            } else if emailTextField.text?.isValidEmail == false {
                self.showMessage(message: ERROR_MSG_EMAIL_INVALID)
            } else if pswdTextField.text?.isValidPasword == false {
                self.showMessage(message: ERROR_MSG_PASSWORD_INVALID)
            } else {
                Login()
            }
        }
    }
    @IBAction func forgotBtnAction(_ sender: Any) {
        let vc: ForgotPasswordViewController = storyboard?.instantiateViewController(withIdentifier: "ForgotPasswordViewController") as! ForgotPasswordViewController
        vc.isFromProfile = isFromProfile
        navigationController?.pushViewController(vc, animated: true)
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
        case emailTextField:
            emailTextField.resignFirstResponder()
            pswdTextField.becomeFirstResponder()
            break
        default:
            pswdTextField.resignFirstResponder()
            break
        }
        return true
    }
    
    //MARK:- API
    
    func Login() {
        let actInd: UIActivityIndicatorView = self.showProgressIndicator()
        let api = APIManager()
        api.post(toURL: API_LOGIN!, params: ["emailId": emailTextField.text!, "password": pswdTextField.text!, "loginType": LOGIN_TYPE.PASSWORD.hashValue], responseType: .JSON, progress: { (progress) in
        }, success: { (response) in
            self.hideProgressIndicator(actInd: actInd)
            let dict = response.dictionary
            if let status = dict["status"] as? Int {
                if status == SUCCESS {
                    if let profile: [String: Any] = dict["profile"] as? [String: Any] {
                        if let userId = profile["userId"] as? String {
                            UserDefaults.standard.set(userId, forKey: "userId")
                        }
                        if let userId = profile["userId"] as? Int {
                            UserDefaults.standard.set(String(userId), forKey: "userId")
                        }
                        if let userTypeId = profile["userTypeId"] as? String {
                            UserDefaults.standard.set(userTypeId, forKey: "userTypeId")
                        }
                        if let name = profile["name"] as? String {
                            UserDefaults.standard.set(name, forKey: "name")
                        }
                        UserDefaults.standard.synchronize()
                    }
                    self.performSegue(withIdentifier: "LoginToHome", sender: self)
                }
                else {
                    self.showMessage(message: "Login failed.")
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
