//
//  CalendarViewController.swift
//  Wander
//
//  Created by IOS on 4/12/18.
//  Copyright © 2018 IOS. All rights reserved.
//

import UIKit
import FSCalendar

class CalendarViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, FSCalendarDataSource, FSCalendarDelegate {

    @IBOutlet var eventsCalendar: FSCalendar!
    @IBOutlet var calendarTableView: UITableView!
    
    var responseArray: [[String: Any]] = []
    var eventsArray: [[String: Any]] = []
    var selectedDate: Int = 0
    var selectedMonth: Int = 0
    var selectedYear: Int = 0
    var datesWithEvent: [String] = []
    var datesWithMultipleEvents: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        calendarTableView.estimatedRowHeight = 80.0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        calendarTableView.reloadData()
        
        eventsCalendar.select(Date())
        let calendar = Calendar.current
        let year = calendar.component(.year, from: Date())
        let month = calendar.component(.month, from: Date())
        let day = calendar.component(.day, from: Date())
        selectedDate = day
        selectedMonth = month
        selectedYear = year
        
        MyCalendarEvents()
    }
    
    //MARK: - UITableViewDataSource -
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CalendarTableViewCell") as! CalendarTableViewCell
        let dict: [String: Any] = eventsArray[indexPath.row]
        if let name: String = dict["name"] as? String {
            cell.lblName.text = name
        }
        if let startTime: String = dict["startTime"] as? String {
            cell.lblTime.text = startTime
        }
        if let venue: String = dict["venue"] as? String, let location: String = dict["location"] as? String {
            cell.lblAdrs.text = "\(venue) - \(location)"
        }
        return cell
    }
    
    //MARK: - UITableViewDelegate -
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let dict: [String: Any] = eventsArray[indexPath.row]
        if let eventId: Int = Int((dict["eventId"] as? String)!) {
            let vc: EventDetailsViewController = storyboard?.instantiateViewController(withIdentifier: "EventDetailsViewController") as! EventDetailsViewController
            vc.eventId = eventId
            if let img: String = dict["baseImage"] as? String {
                vc.baseImage = img
            }
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    //MARK:- FSCalendarDataSource
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let calendar = Calendar.current
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        selectedDate = day
        selectedMonth = month
        selectedYear = year

        MyCalendarEvents()
    }
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        print(calendar.currentPage)
        let cal = Calendar.current
        let year = cal.component(.year, from: calendar.currentPage)
        let month = cal.component(.month, from: calendar.currentPage)
        let day = cal.component(.day, from: calendar.currentPage)
        selectedDate = day
        selectedMonth = month
        selectedYear = year
        
        MyCalendarEvents()
    }
    
    func calendar(_ calendar: FSCalendar, hasEventFor date: Date) -> Bool {
        //let dateString = self.dateFormatter.string(from: date)
        if self.datesWithEvent.contains(self.dateFormatter.string(from: date)) {
            return true
        }
        if self.datesWithMultipleEvents.contains(self.dateFormatter.string(from: date)) {
            return true
        }
        return false
    }
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        //let dateString = self.dateFormatter.string(from: date)
        if self.datesWithEvent.contains(self.dateFormatter.string(from: date)) {
            return 1
        }
        if self.datesWithMultipleEvents.contains(self.dateFormatter.string(from: date)) {
            return 2
        }
        return 0
    }
    
    fileprivate lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    //MARK:- API
    
    func MyCalendarEvents() {
        if let userId: String = UserDefaults.standard.string(forKey: "userId") {
            responseArray = []
            eventsArray = []
            datesWithEvent = []
            datesWithMultipleEvents = []
            calendarTableView.reloadData()
            
            let actInd: UIActivityIndicatorView = self.showProgressIndicator()
            let api = APIManager()
            api.post(toURL: API_MY_CALENDAR_EVENTS!, params: ["userId": userId, "month": selectedMonth, "year": selectedYear], responseType: .JSON, progress: { (progress) in
            }, success: { (response) in
                self.hideProgressIndicator(actInd: actInd)
                let dict = response.dictionary
                print(dict)
                if let status = dict["status"] as? Int {
                    if status == SUCCESS {
                        if let year: String = dict["year"] as? String, let month: String = dict["month"] as? String {
                            self.responseArray = dict["events"] as! [[String: Any]]
                            if Int(year) == self.selectedYear && Int(month) == self.selectedMonth {
                                for event in self.responseArray {
                                    let d: [String: Any] = event
                                    if (d["date"] as! Int) == self.selectedDate {
                                        self.eventsArray = d["events"] as! [[String: Any]]
                                    }
                                }
                            }
                        }
                        if let year: Int = dict["year"] as? Int, let month: Int = dict["month"] as? Int {
                            self.responseArray = dict["events"] as! [[String: Any]]
                            if year == self.selectedYear && month == self.selectedMonth {
                                for event in self.responseArray {
                                    let d: [String: Any] = event
                                    if (d["date"] as! Int) == self.selectedDate {
                                        self.eventsArray = d["events"] as! [[String: Any]]
                                    }
                                }
                            }
                        }
                        for dict in self.responseArray {
                            let date: Int = dict["date"] as! Int
                            let d: String = date < 10 ? "0\(date)" : "\(date)"
                            let m: String = self.selectedMonth < 10 ? "0\(self.selectedMonth)" : "\(self.selectedMonth)"
                            let str: String = "\(self.selectedYear)-\(m)-\(d)"
                            let arr: [[String: Any]] = dict["events"] as! [[String: Any]]
                            arr.count > 1 ? self.datesWithMultipleEvents.append(str) : self.datesWithEvent.append(str)
                        }
                    }
                    else {
                        self.showMessage(message: "No events found.")
                    }
                }
                self.calendarTableView.reloadData()
                self.eventsCalendar.reloadData()
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
}
