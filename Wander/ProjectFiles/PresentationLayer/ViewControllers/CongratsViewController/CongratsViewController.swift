//
//  CongratsViewController.swift
//  Wander
//
//  Created by IOS on 3/31/18.
//  Copyright © 2018 IOS. All rights reserved.
//

import UIKit

class CongratsViewController: UITableViewController {

    @IBOutlet var gotItButton: UIButton!
    
    var isFromProfile: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gotItButton.applyShadow(color: COLOR_THEME_BLUE)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK:- Button Actions
    
    @IBAction func backBtnAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func gotItBtnAction(_ sender: Any) {
        navigationController?.popToViewController(navigationController!.viewControllers[1], animated: true)
    }
}
