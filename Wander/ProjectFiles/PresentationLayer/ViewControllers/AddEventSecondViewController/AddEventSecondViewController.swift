//
//  AddEventSecondViewController.swift
//  Wander
//
//  Created by IOS on 7/20/18.
//  Copyright © 2018 IOS. All rights reserved.
//

import UIKit

class AddEventSecondViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var eventHeightConstraint: NSLayoutConstraint!
    @IBOutlet var phoneNoBGView: UIView!
    @IBOutlet var phoneNoTextField: UITextField!
    @IBOutlet var websiteBGView: UIView!
    @IBOutlet var websiteTextField: UITextField!
    @IBOutlet var detailsBGView: UIView!
    @IBOutlet var detailsTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        phoneNoBGView.applyBorder(color: COLOR_THEME_DARK_ASH)
        websiteBGView.applyBorder(color: COLOR_THEME_DARK_ASH)
        detailsBGView.applyBorder(color: COLOR_THEME_DARK_ASH)
        
        eventHeightConstraint.constant = 600
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK:- Button Actions
    
    @IBAction func backBtnAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func nextBtnAction(_ sender: Any) {
        if phoneNoTextField.text?.isEmpty == true {
            self.showMessage(message: ERROR_MSG_PHONE_BLANK)
        } else if websiteTextField.text?.isEmpty == true {
            self.showMessage(message: ERROR_MSG_WEBSITE_BLANK)
        } else if detailsTextView.text?.isEmpty == true {
            self.showMessage(message: ERROR_MSG_DETAILS_BLANK)
        } else {
            addEventDict["phoneNo"] = phoneNoTextField.text!
            addEventDict["website"] = websiteTextField.text!
            addEventDict["details"] = detailsTextView.text!
            let vc: AddEventThirdViewController = storyboard?.instantiateViewController(withIdentifier: "AddEventThirdViewController") as! AddEventThirdViewController
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
