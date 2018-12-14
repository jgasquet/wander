//
//  BookTicketsViewController.swift
//  Wander
//
//  Created by IOS on 7/5/18.
//  Copyright © 2018 IOS. All rights reserved.
//

import UIKit

class BookTicketsViewController: UITableViewController, UITextFieldDelegate {

    @IBOutlet var nameBGView: UIView!
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var emailBGView: UIView!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var mobileBGView: UIView!
    @IBOutlet var mobileTextField: UITextField!
    @IBOutlet var submitButton: UIButton!
    @IBOutlet var stepper: UIStepper!
    @IBOutlet var valueLabel: UILabel!
    @IBOutlet var priceLabel: UILabel!
    
    var eventId: Int = 0
    var ticketTypeId: Int = 0
    var ticketPrice: Double = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameBGView.applyBorder(color: COLOR_THEME_DARK_ASH)
        emailBGView.applyBorder(color: COLOR_THEME_DARK_ASH)
        mobileBGView.applyBorder(color: COLOR_THEME_DARK_ASH)
        submitButton.applyShadow(color: COLOR_THEME_BLUE)
        
        stepper.maximumValue = 10
        priceLabel.text = "\(ticketPrice)"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK:- Button Actions
    
    @IBAction func backBtnAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func submitBtnAction(_ sender: Any) {
        nameTextField.resignFirstResponder()
        emailTextField.resignFirstResponder()
        mobileTextField.resignFirstResponder()
        
        if nameTextField.text?.isEmpty == true {
            self.showMessage(message: ERROR_MSG_NAME_BLANK)
        } else if emailTextField.text?.isEmpty == true {
            self.showMessage(message: ERROR_MSG_EMAIL_BLANK)
        } else if emailTextField.text?.isValidEmail == false {
            self.showMessage(message: ERROR_MSG_EMAIL_INVALID)
        } else if mobileTextField.text?.isEmpty == true {
            self.showMessage(message: ERROR_MSG_PHONE_BLANK)
        } else {
            BookTicket()
        }
    }
    
    @IBAction func stepperAction(_ sender: UIStepper) {
        valueLabel.text = Int(sender.value).description
        priceLabel.text = "\(ticketPrice * Double(sender.value))"
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
        case nameTextField:
            nameTextField.resignFirstResponder()
            emailTextField.becomeFirstResponder()
            break
        case emailTextField:
            emailTextField.resignFirstResponder()
            mobileTextField.becomeFirstResponder()
            break
        default:
            mobileTextField.resignFirstResponder()
            break
        }
        return true
    }
    
    //MARK:- API
    
    func BookTicket() {
        if let userId: String = UserDefaults.standard.string(forKey: "userId") {
            let actInd: UIActivityIndicatorView = self.showProgressIndicator()
            let api = APIManager()
            api.post(toURL: API_BOOK_TICKET!, params: ["userId": userId, "eventId": eventId, "ticketType": ticketTypeId, "name": nameTextField.text!, "mobile": mobileTextField.text!, "email": emailTextField.text!, "ticketCount": valueLabel.text!, "totalPrice": priceLabel.text!], responseType: .JSON, progress: { (progress) in
            }, success: { (response) in
                self.hideProgressIndicator(actInd: actInd)
                let dict = response.dictionary
                if let status = dict["status"] as? Int {
                    if status == SUCCESS {
                        let alertController = UIAlertController(title: "Message", message: "Ticket booked successfully!", preferredStyle: .alert)
                        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                            UIAlertAction in
                            self.navigationController?.popViewController(animated: true)
                        }
                        alertController.addAction(okAction)
                        self.present(alertController, animated: true, completion: nil)
                    }
                    else {
                        self.showMessage(message: "Booking failed.")
                    }
                }
            }, failure: { (response) in
                self.hideProgressIndicator(actInd: actInd)
                if let errorString = response.dictionary["error"] {
                    self.showMessage(message: errorString as! String)
                }
            })
        }
        else {
            self.showMessage(message: ERROR_MSG_USER_NOT_FOUND)
        }
    }
}
