//
//  Constants.swift
//  Wander
//
//  Created by IOS on 04/12/17.
//  Copyright © 2017 IOS. All rights reserved.
//

import UIKit

let SCREEN_SIZE = UIScreen.main.bounds.size
let COLOR_THEME_BLUE = UIColor(red: 12.0/255.0, green: 87.0/255.0, blue: 210.0/255.0, alpha: 0.8)
let COLOR_THEME_DARK_ASH = UIColor(red: 63.0/255.0, green: 64.0/255.0, blue: 62.0/255.0, alpha: 0.8)

/*let COLOR_QUIZ_FIRST_TOP = UIColor(red: 26.0/255.0, green: 154.0/255.0, blue: 106.0/255.0, alpha: 1.0)
let COLOR_QUIZ_FIRST_BOTTOM = UIColor(red: 190.0/255.0, green: 237.0/255.0, blue: 146.0/255.0, alpha: 1.0)
let COLOR_QUIZ_SECOND_TOP = UIColor(red: 243.0/255.0, green: 90.0/255.0, blue: 25.0/255.0, alpha: 1.0)
let COLOR_QUIZ_SECOND_BOTTOM = UIColor(red: 248.0/255.0, green: 210.0/255.0, blue: 78.0/255.0, alpha: 1.0)
let COLOR_QUIZ_THIRD_TOP = UIColor(red: 232.0/255.0, green: 0.0/255.0, blue: 225.0/255.0, alpha: 1.0)
let COLOR_QUIZ_THIRD_BOTTOM = UIColor(red: 82.0/255.0, green: 99.0/255.0, blue: 249.0/255.0, alpha: 1.0)
let COLOR_QUIZ_FOURTH_TOP = UIColor.orange
let COLOR_QUIZ_FOURTH_BOTTOM = UIColor.yellow
let COLOR_QUIZ_FIFTH_TOP = UIColor.purple
let COLOR_QUIZ_FIFTH_BOTTOM = UIColor.blue*/

let COLOR_1ST_TOP = UIColor(red: 74.0/255.0, green: 61.0/255.0, blue: 245.0/255.0, alpha: 1.0)
let COLOR_1ST_BTM = UIColor(red: 168.0/255.0, green: 225.0/255.0, blue: 255.0/255.0, alpha: 1.0)
let COLOR_2ND_TOP = UIColor(red: 28.0/255.0, green: 139.0/255.0, blue: 87.0/255.0, alpha: 1.0)
let COLOR_2ND_BTM = UIColor(red: 165.0/255.0, green: 229.0/255.0, blue: 125.0/255.0, alpha: 1.0)
let COLOR_3RD_TOP = UIColor(red: 237.0/255.0, green: 68.0/255.0, blue: 21.0/255.0, alpha: 1.0)
let COLOR_3RD_BTM = UIColor(red: 245.0/255.0, green: 191.0/255.0, blue: 59.0/255.0, alpha: 1.0)
let COLOR_4TH_TOP = UIColor(red: 102.0/255.0, green: 0.0/255.0, blue: 139.0/255.0, alpha: 1.0)
let COLOR_4TH_BTM = UIColor(red: 103.0/255.0, green: 250.0/255.0, blue: 233.0/255.0, alpha: 1.0)
let COLOR_5TH_TOP = UIColor(red: 47.0/255.0, green: 69.0/255.0, blue: 0.0/255.0, alpha: 1.0)
let COLOR_5TH_BTM = UIColor(red: 66.0/255.0, green: 250.0/255.0, blue: 213.0/255.0, alpha: 1.0)

let GOOGLE_CLIENT_ID = "458261340427-7843kv6fqnjp0qnhadlsd24r0tnam7od.apps.googleusercontent.com"
let GOOGLE_REVERSE_CLIENT_ID = "com.googleusercontent.apps.458261340427-7843kv6fqnjp0qnhadlsd24r0tnam7od"

let API_AUTH_KEY = "dbc20b3cabafc1e1b2b25ae6c4f9f248"
let BASE_URL = URL(string: "http://demo.goigi.biz/wander-app/api/") //"https://demo.goigi.biz/wander-app/index.php"
let BASE_IMAGE_PATH = "http://demo.goigi.biz/wander-app/uploads/"

let API_LOGIN = BASE_URL?.appendingPathComponent("userslogin/") //1 (API doc serial no)
let API_REGISTRATION = BASE_URL?.appendingPathComponent("usersignup/") //2
let API_SKIP_LOGIN = BASE_URL?.appendingPathComponent("skiplogin/") //4
let API_COUNTRY_LIST = BASE_URL?.appendingPathComponent("countrylist/") //5
let API_STATE_LIST = BASE_URL?.appendingPathComponent("statelist/") //6
let API_CITY_LIST = BASE_URL?.appendingPathComponent("citylist/") //7
let API_FEED_PERSONALIZATION = BASE_URL?.appendingPathComponent("feedPersonalisation/") //8
let API_EVENT_LIST = BASE_URL?.appendingPathComponent("eventList/") //9
let API_ADD_EVENT_CALENDAR = BASE_URL?.appendingPathComponent("addUserEventCalendar/") //10
let API_BOOKMARK_EVENT = BASE_URL?.appendingPathComponent("addUserBookmarkEvent/") //11
let API_CATEGORY_LIST = BASE_URL?.appendingPathComponent("categoryList/") //12
let API_SUBCATEGORY_LIST = BASE_URL?.appendingPathComponent("subCategoryList/") //13
let API_GET_EVENT_BY_HASHTAG = BASE_URL?.appendingPathComponent("getEventByHashtag/") //14
let API_UPDATE_EVENT_CITY = BASE_URL?.appendingPathComponent("updateUserEventCity/") //15
let API_UPDATE_EVENT_CATEGORY = BASE_URL?.appendingPathComponent("updateUserEventCategory/") //16
let API_EMAIL_VERIFICATION = BASE_URL?.appendingPathComponent("verifyEmail/") //17
let API_CHANGE_PASSWORD = BASE_URL?.appendingPathComponent("changepassword/") //18
let API_ADD_EVENT = BASE_URL?.appendingPathComponent("addEvent/") //19
let API_EVENT_DETAILS = BASE_URL?.appendingPathComponent("eventDetails/") //20
let API_MY_BOOKMARKED_EVENTS = BASE_URL?.appendingPathComponent("myBookmarkedEvents/") //21
let API_EXPLORE_EVENTS = BASE_URL?.appendingPathComponent("exploreEvents/") //22
let API_MY_CATEGORIES = BASE_URL?.appendingPathComponent("myCategories/") //23
let API_MY_FEED = BASE_URL?.appendingPathComponent("myFeed/") //24
let API_BOOK_TICKET = BASE_URL?.appendingPathComponent("bookTickets/") //25
let API_BOOKED_TICKET_LIST = BASE_URL?.appendingPathComponent("bookTicketsList/") //26
let API_CANCEL_BOOKING = BASE_URL?.appendingPathComponent("cancelTicket/") //27
let API_RESTAURANT_LIST = BASE_URL?.appendingPathComponent("nearByRestaurants/") //28
let API_MY_CALENDAR_EVENTS = BASE_URL?.appendingPathComponent("myCalenderEvents/") //29
let API_QUESTION_LIST = BASE_URL?.appendingPathComponent("question_list/")
let API_SUBMIT_ANSWER = BASE_URL?.appendingPathComponent("submit_answer/")


let SUCCESS = 1
let ERROR = 0

let ERROR_BLANK = "Please enter "
let ERROR_MSG_NAME_BLANK = ERROR_BLANK.appending("name.")
let ERROR_MSG_EMAIL_BLANK = ERROR_BLANK.appending("email id.")
let ERROR_MSG_PHONE_BLANK = ERROR_BLANK.appending("phone number.")
let ERROR_MSG_PASSWORD_BLANK = ERROR_BLANK.appending("password.")
let ERROR_MSG_PASSWORD_INVALID = ERROR_BLANK.appending("Password should be 6 to 12 characters.")
let ERROR_MSG_NEW_PASSWORD_BLANK = ERROR_BLANK.appending("new password.")
let ERROR_MSG_OLD_PASSWORD_BLANK = ERROR_BLANK.appending("your old password.")
let ERROR_MSG_CONFIRM_PASSWORD_BLANK = ERROR_BLANK.appending("confirm password.")
let ERROR_MSG_EVENT_NAME_BLANK = ERROR_BLANK.appending("event name.")
let ERROR_MSG_ORG_NAME_BLANK = ERROR_BLANK.appending("organization name.")
let ERROR_MSG_TICKET_BLANK = ERROR_BLANK.appending("total ticket.")
let ERROR_MSG_PRICE_BLANK = ERROR_BLANK.appending("ticket price.")
let ERROR_MSG_WEBSITE_BLANK = ERROR_BLANK.appending("wesite.")
let ERROR_MSG_DETAILS_BLANK = ERROR_BLANK.appending("details.")
let ERROR_MSG_VENUE_BLANK = ERROR_BLANK.appending("venue.")
let ERROR_MSG_ADRS_BLANK = ERROR_BLANK.appending("address.")
let ERROR_MSG_LOCATION_BLANK = ERROR_BLANK.appending("location.")
let ERROR_MSG_SEARCH_BLANK = ERROR_BLANK.appending("search keyword.")
let ERROR_MSG_PASSWORD_CONFIRM = "Your password does not match with confirm password."
let ERROR_MSG_EMAIL_INVALID = "Kindly provide a valid email id."
let ERROR_MSG_PHONE_INVALID = "Kindly provide a valid phone no."
let ERROR_MSG_NETWORK_ERROR = "Sorry, we are unable to proceed. Please check your internet connection."
let ERROR_MSG_FORGOT_PASSWORD = "Please enter your email address."
let ERROR_MSG_COUNTRY_BLANK = "Please select country."
let ERROR_MSG_STATE_BLANK = "Please select state."
let ERROR_MSG_CITY_BLANK = "Please select city."
let ERROR_MSG_TOPIC_BLANK = "Please select topic."
let ERROR_MSG_USER_NOT_FOUND = "User not found."

let MSG_LOGOUT_SUCCESS = "You are logged out successfully."

enum USER_TYPE {
    case NONE
    case VISITOR
    case MEMBER
    case OWNER
    case ADMIN
}

enum LOGIN_TYPE {
    case PASSWORD
    case FACEBOOK
    case GOOGLE
}

let HORIZONTAL = "Horizontal"
let VERTICAL = "Vertical"

let COUNTRY = "Country"
let STATE = "State"
let CITY = "City"

let tempImagesArray: [String] = ["demo_singer_1.png", "demo_singer_2.png", "demo_singer_3.png", "demo_singer_4.png"]
let cityArray: [String] = ["San Francisco", "New Orleans"]
let dayTimeArray: [String] = ["Today", "This Week", "This Month"]
let ticketTypesArray: [String] = ["Free", "Paid", "Donation"]

let DIODRUM_MEDIUM = "Diodrum-Medium"
let DIODRUM_SEMIBOLD = "Diodrum-Semibold"
