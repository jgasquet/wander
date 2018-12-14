//
//  QuestionnaireViewController.swift
//  Wander
//
//  Created by IOS on 4/24/18.
//  Copyright © 2018 IOS. All rights reserved.
//

import UIKit

class QuestionnaireViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet var containerVw: UIView!
    @IBOutlet var descLabel: UILabel!
    @IBOutlet var questionImageView: UIImageView!
    @IBOutlet var questionLabel: UILabel!
    @IBOutlet var yesButton: UIButton!
    @IBOutlet var noButton: UIButton!
    @IBOutlet var questionPageCtrl: UIPageControl!
    
    var ColorArray: [[UIColor]] = [[COLOR_1ST_TOP, COLOR_1ST_BTM], [COLOR_2ND_TOP, COLOR_2ND_BTM], [COLOR_3RD_TOP, COLOR_3RD_BTM], [COLOR_4TH_TOP, COLOR_4TH_BTM], [COLOR_5TH_TOP, COLOR_5TH_BTM]]
    var questionsArray: [[String: Any]] = []
    var currentPage: Int = 0
    var qstnIDArray: [Int] = []
    var selectedAnsArray: [Int] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        yesButton.applyBorderAndShadow(color: COLOR_THEME_BLUE)
        noButton.applyBorderAndShadow(color: COLOR_THEME_BLUE)
        yesButton.isHidden = true
        noButton.isHidden = true
        
        QuestionList()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK:- Button Actions
    
    @IBAction func backBtnAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func skipBtnAction(_ sender: Any) {
        reloadPage()
    }
    @IBAction func yesBtnAction(_ sender: Any) {
        selectedAnsArray.append(1)
        reloadPage()
    }
    @IBAction func noBtnAction(_ sender: Any) {
        selectedAnsArray.append(0)
        reloadPage()
    }
    
    //MARK:- API
    
    func QuestionList() {
        if let userId: String = UserDefaults.standard.string(forKey: "userId") {
            questionsArray = []
            selectedAnsArray = []
            let actInd: UIActivityIndicatorView = self.showProgressIndicator()
            let api = APIManager()
            api.post(toURL: API_QUESTION_LIST!, params: ["userId": userId], responseType: .JSON, progress: { (progress) in
            }, success: { (response) in
                self.hideProgressIndicator(actInd: actInd)
                let dict = response.dictionary
                print(dict)
                if let status = dict["status"] as? Int {
                    if status == SUCCESS {
                        if let qstnList: [[String: Any]] = dict["questionList"] as? [[String: Any]] {
                            self.questionsArray = qstnList
                            if self.questionsArray.count > 0 {
                                if let qstn: String = self.questionsArray[0]["question"] as? String {
                                    self.questionLabel.text = qstn
                                }
                            }
                        }
                        self.questionPageCtrl.numberOfPages = self.questionsArray.count
                        self.questionPageCtrl.currentPage = 0
                        self.yesButton.isHidden = false
                        self.noButton.isHidden = false
                        self.reloadPage()
                        self.qstnIDArray = []
                        for qstn in self.questionsArray {
                            if let qstnID: String = qstn["questionId"] as? String {
                                self.qstnIDArray.append(Int(qstnID)!)
                            }
                        }
                        print(self.qstnIDArray)
                    }
                    else {
                        self.showMessage(message: "No questions found.")
                    }
                }
            }, failure: { (response) in
                self.hideProgressIndicator(actInd: actInd)
                if let errorString = response.dictionary["error"] as? [String: Any] {
                    self.showMessage(message: errorString.description)
                }
            })
        }
        else {
            self.showMessage(message: ERROR_MSG_USER_NOT_FOUND)
        }
    }
    
    func SubmitAnswer() {
        if qstnIDArray.count == selectedAnsArray.count {
            let qstnIDStr = qstnIDArray.map{String($0)}.joined(separator: ",")
            let ansStr = selectedAnsArray.map{String($0)}.joined(separator: ",")
            
            if let userId: String = UserDefaults.standard.string(forKey: "userId") {
                let actInd: UIActivityIndicatorView = self.showProgressIndicator()
                let api = APIManager()
                api.post(toURL: API_SUBMIT_ANSWER!, params: ["userId": userId, "questionId": qstnIDStr, "answer": ansStr], responseType: .JSON, progress: { (progress) in
                }, success: { (response) in
                    self.hideProgressIndicator(actInd: actInd)
                    let dict = response.dictionary
                    print(dict)
                    if let status = dict["status"] as? Int {
                        if status == SUCCESS {
                            self.navigationController?.popViewController(animated: true)
                        }
                        else {
                            self.showMessage(message: "Failed to submit.")
                        }
                    }
                }, failure: { (response) in
                    self.hideProgressIndicator(actInd: actInd)
                    if let errorString = response.dictionary["error"] as? [String: Any] {
                        self.showMessage(message: errorString.description)
                    }
                })
            }
            else {
                self.showMessage(message: ERROR_MSG_USER_NOT_FOUND)
            }
        }
        else {
            self.showMessage(message: "Unknown error.")
        }
    }
    
    func reloadPage() {
        currentPage == 0 ? (descLabel.isHidden = false) : (descLabel.isHidden = true)
        if currentPage < questionsArray.count {
            for view in containerVw.subviews {
                if (view.tag == 1000) {
                    view.removeFromSuperview()
                }
            }
            let v: UIView = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_SIZE.width, height: SCREEN_SIZE.height))
            v.tag = 1000
            v.createGradientView(FirstColor: ColorArray[currentPage%5][0], SecondColor: ColorArray[currentPage%5][1], width: SCREEN_SIZE.width, height: SCREEN_SIZE.height, direction: VERTICAL, alpha: 1.0)
            containerVw.addSubview(v)
            containerVw.sendSubview(toBack: v)
            questionLabel.text = questionsArray[currentPage]["question"] as? String
            questionPageCtrl.currentPage = currentPage
            currentPage += 1
        }
        else {
            print(selectedAnsArray)
            SubmitAnswer()
        }
    }
}
