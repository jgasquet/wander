//
//  LoginViewController.swift
//  Wander
//
//  Created by IOS on 09/12/17.
//  Copyright © 2017 IOS. All rights reserved.
//

import UIKit
import FacebookLogin
import FacebookCore
import GoogleSignIn

class LoginViewController: UITableViewController, GIDSignInUIDelegate, GIDSignInDelegate {

    @IBOutlet var btnFacebook: UIButton!
    @IBOutlet var btnGmail: UIButton!
    @IBOutlet var btnEmailLogin: UIButton!
    @IBOutlet var btnEmailSignUp: UIButton!
    @IBOutlet var btnHome: UIButton!
    
    var vcLoader: LoaderViewController?
    var FBUserDetails: [String: Any] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnFacebook.applyShadow(color: COLOR_THEME_BLUE)
        btnGmail.applyShadow(color: COLOR_THEME_BLUE)
        btnEmailLogin.applyShadow(color: COLOR_THEME_BLUE)
        btnEmailSignUp.applyShadow(color: COLOR_THEME_BLUE)
        btnHome.applyBorder(color: COLOR_THEME_DARK_ASH)
        
        GIDSignIn.sharedInstance().uiDelegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueLoader" {
            vcLoader = segue.destination as? LoaderViewController
        }
    }
    //MARK: - Button Actions -
    
    @IBAction func btnFacebookDidTapped(_ sender: Any) {
        let loginManager = LoginManager()
        loginManager.logIn(readPermissions: [.publicProfile,.email,.userFriends,.userBirthday], viewController: self) { loginResult in
            switch loginResult {
            case .failed(let error):
                print(error)
            case .cancelled:
                print("Cancelled.")
            case .success(let accessToken):
                self.getFBUserDetailsWith(Token: accessToken.token.authenticationToken)
            }
        }
    }
    
    @IBAction func btnGmailDidTapped(_ sender: Any) {
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().signIn()
    }
    
    @IBAction func btnHomeDidTapped(_ sender: Any) {
        
        //goToHome()
        SkipLogin()
    }
    
    //MARK:- Google Login
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            print("\(error.localizedDescription)")
        } else {
            print(user.userID!)
            print(user.authentication.idToken!)
            print(user.profile.name!)
            print(user.profile.givenName!)
            print(user.profile.familyName!)
            print(user.profile.email!)
            /*["userId" : 107848426005446543664,
             "fullName" : goigi test,
             "givenName" : goigi,
             "familyName" : test,
             "email" : goigitest1@gmail.com*/
            Login(name: user.profile.name!, emailId: user.profile.email!, password: user.authentication.idToken, loginType: LOGIN_TYPE.GOOGLE.hashValue)
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        print("\(error.localizedDescription)")
    }
    
    //MARK:- Facebook Details
    
    func getFBUserDetailsWith(Token: String) {
        let params = ["fields" : "id, name, first_name, last_name, email"]
        let graphRequest = GraphRequest(graphPath: "me", parameters: params)
        graphRequest.start {
            (urlResponse, requestResult) in
            switch requestResult {
            case .failed(let error):
                print("error in graph request:", error)
                break
            case .success(let graphResponse):
                if let responseDictionary = graphResponse.dictionaryValue {
                    self.FBUserDetails = responseDictionary as [String: Any]
                    print(self.FBUserDetails)
                    print("Token : \(Token)")
                    /*["name": Weare Goigi,
                     "last_name": Goigi,
                     "email": wearegoigi@gmail.com,
                     "id": 708775966177334,
                     "first_name": Weare]*/
                    self.Login(name: self.FBUserDetails["name"] as! String, emailId: self.FBUserDetails["email"] as! String, password: Token, loginType: LOGIN_TYPE.FACEBOOK.hashValue)
                }
            }
        }
    }
    
    //MARK:- API
    
    func SkipLogin() {
        let actInd: UIActivityIndicatorView = self.showProgressIndicator()
        let api = APIManager()
        api.post(toURL: API_SKIP_LOGIN!, params: ["userTypeId": USER_TYPE.VISITOR.hashValue], responseType: .JSON, progress: { (progress) in
        }, success: { (response) in
            self.hideProgressIndicator(actInd: actInd)
            let dict = response.dictionary
            if let status = dict["status"] as? Int {
                if status == SUCCESS {
                    if let userId = dict["userId"] as? Int {
                        UserDefaults.standard.set(userId, forKey: "userId")
                    }
                    if let userTypeId = dict["userTypeId"] as? String {
                        UserDefaults.standard.set(userTypeId, forKey: "userTypeId")
                    }
                    UserDefaults.standard.set("Guest User", forKey: "name")
                    UserDefaults.standard.synchronize()
                    self.goToHome()
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
    
    func goToHome() {
        self.performSegue(withIdentifier: "segueLoader", sender: self)
        let deadlineTime = DispatchTime.now() + .seconds(2)
        DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
            self.vcLoader?.dismiss(animated: false, completion: {
                self.performSegue(withIdentifier: "segueHome", sender: self)
            })
        }
    }
    
    func Login(name: String, emailId: String, password: String, loginType: Int) {
        let actInd: UIActivityIndicatorView = self.showProgressIndicator()
        let api = APIManager()
        api.post(toURL: API_LOGIN!, params: ["emailId": emailId, "password": password, "loginType": loginType], responseType: .JSON, progress: { (progress) in
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
                    self.goToHome()
                }
                else {
                    self.showMessage(message: "Login failed.")
                }
            }
        }, failure: { (response) in
            self.hideProgressIndicator(actInd: actInd)
            let dict = response.dictionary
            if let status = dict["status"] as? Int {
                if status == ERROR {
                    if let errorString = response.dictionary["error"] {
                        self.showMessage(message: errorString as! String)
                    }
                    self.Registration(name: name, emailId: emailId, password: password, loginType: loginType)
                }
            }
        })
    }
    
    func Registration(name: String, emailId: String, password: String, loginType: Int) {
        let actInd: UIActivityIndicatorView = self.showProgressIndicator()
        let api = APIManager()
        api.post(toURL: API_REGISTRATION!, params: ["name": name, "emailId": emailId, "countryId": "", "stateId": "", "cityId": "", "mobile": "", "password": password, "loginType": loginType, "userTypeId": USER_TYPE.VISITOR.hashValue], responseType: .JSON, progress: { (progress) in
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
                    self.goToHome()
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
