//
//  SettingsViewController.swift
//  Wander
//
//  Created by IOS on 4/3/18.
//  Copyright © 2018 IOS. All rights reserved.
//

import UIKit

class SettingsViewController: UITableViewController {

    @IBOutlet var lblCity: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK:- Button Actions
    
    @IBAction func backBtnAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    //MARK: - UITableViewDelegate -
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.row {
        case 0:
            let vc: ChooseCityViewController = storyboard?.instantiateViewController(withIdentifier: "ChooseCityViewController") as! ChooseCityViewController
            vc.isLoggedIn = true
            vc.callBack = {(str: String) -> () in
                self.lblCity.text = str
            }
            self.navigationController?.pushViewController(vc, animated: true)
            break
        case 3:
            logout()
            break
        default:
            break
        }
    }
    
    func logout(){
        let vc: LoginViewController = storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        let nav = UINavigationController(rootViewController: vc)
        nav.setNavigationBarHidden(true, animated: false)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = nav
    }
}
