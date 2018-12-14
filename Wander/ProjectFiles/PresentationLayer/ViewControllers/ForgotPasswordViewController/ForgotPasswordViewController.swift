//
//  ForgotPasswordViewController.swift
//  Wander
//
//  Created by IOS on 3/31/18.
//  Copyright © 2018 IOS. All rights reserved.
//

import UIKit

class ForgotPasswordViewController: UITableViewController, UITextFieldDelegate {

    @IBOutlet var emailBGView: UIView!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var submitButton: UIButton!
    
    var isFromProfile: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailBGView.applyBorder(color: COLOR_THEME_DARK_ASH)
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
        emailTextField.resignFirstResponder()
        
        if isFromProfile == true {
            let vc: UpdatePasswordViewController = self.storyboard?.instantiateViewController(withIdentifier: "UpdatePasswordViewController") as! UpdatePasswordViewController
            vc.isFromProfile = self.isFromProfile
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else {
            if emailTextField.text?.isEmpty == true {
                self.showMessage(message: ERROR_MSG_EMAIL_BLANK)
            } else if emailTextField.text?.isValidEmail == false {
                self.showMessage(message: ERROR_MSG_EMAIL_INVALID)
            } else {
                EmailVerification()
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
        emailTextField.resignFirstResponder()
        return true
    }
    
    //MARK:- API
    
    func EmailVerification() {
        let actInd: UIActivityIndicatorView = self.showProgressIndicator()
        let api = APIManager()
        api.post(toURL: API_EMAIL_VERIFICATION!, params: ["emailId": emailTextField.text!], responseType: .JSON, progress: { (progress) in
        }, success: { (response) in
            self.hideProgressIndicator(actInd: actInd)
            let dict = response.dictionary
            if let status = dict["status"] as? Int {
                if status == SUCCESS {
                    let vc: UpdatePasswordViewController = self.storyboard?.instantiateViewController(withIdentifier: "UpdatePasswordViewController") as! UpdatePasswordViewController
                    vc.isFromProfile = self.isFromProfile
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                else {
                    self.showMessage(message: "Email verification failed.")
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
