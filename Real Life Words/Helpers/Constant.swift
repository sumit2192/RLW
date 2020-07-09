//
//  Constant.swift
//  PorpertyMgr
//
//  Created by Apple on 24/02/20.
//  Copyright © 2020 Apple. All rights reserved.
//


import Foundation
import UIKit

let appDel = UIApplication.shared.delegate as! AppDelegate
let context = appDel.persistentContainer.viewContext
let persistenceStrategy: PersistenceStrategy = CoreDataStrategy()
let DEFAULTS = UserDefaults.standard





/**********  URl *****************/

let BASE_URL = "http://3.21.9.49/api/"

let SIGNUP_URL = "signup"
let LOGIN_URL = "signin"
let VERIFY_OTP_URL = "verifyotp"
let SOCIAL_URL = "socialregister"
let FORGOT_PASS_URL = "forgotpassword"
let RESET_PASS_URL = "setnewpassword"
let RESEND_OTP_URL = "resendotp"
let ADD_PROPERTY_URL = "addproperty"
let EDIT_PROPERTY_URL = "editproperty"
let DELETE_PROPERTY_URL = "deleteproperty"
let PROPERTY_LIST_URL = "listproperty"
let TENANT_LIST_URL = "listtenants"
let TENANT_REQUEST_LIST_URL = "requestslist"
let TENANT_ACCEPT_REJECT_URL = "assigntenants"
let ASSIGN_PROPERTY_URL = "assign"
let UPDATE_ASSIGN_PROPERTY_URL = "updateassign"
let REMOVE_ASSIGN_PROPERTY_URL = "removeassign"
let REMOVE_TENANT_URL = "removetenants"
let TICKETS_REQUEST_LIST_URL = "listticketsbyowner"
let TICKETS_DETAIL_URL = "ticketdetails"
let TICKETS_ACCEPT_REJECT_URL = "accepcttickets"
let BID_TICKET_LIST_URL = "bidsbyproperty"
let BID_LIST_URL = "bidsbytickets"
let BID_ACCEPT_REJECT_URL = "accpetbids"



/*********************************/


class Constant: NSObject {
    
    //class Constant object
    
    // For Commen KeyWords
    let BLANK = ""
    let TITLE = "Real Life Words"
    let PROGRESS_TITLE = "Loading..."
    let MESSAGE = "Please_Check_network_connection"
    let RESPONSE_CODE = "responseCode"
    let DEACTIVE = "user is deactivated"
    let ERROR_MSG = "Something went wrong."
    let ERROR_NOT_EXIST = "User does not exits."
    let BACK_MSG = "Are you sure you want to exit this page. if you exit this page you would loose all information entered on this page."
    let TEXT_FLD_ERROR_MSG = "You can fill only two, if you want to fill another one first clear the already filled values."
    let BLUETOOTH_OFF = "TURN ON BLUETOOTH"
    static let SELECT_PIC = "Select Picture"
    static let SELECT_CAMERA = "Camera"
    static let SELECT_GALLERY = "Gallery"
    static let CANCEL = "Cancel"
    static let CAMERA_NOT_FOUND = "Camera not found"
    static let NO_CAMERA = "This device has no camera."
    static let ARE_YOU_SURE = "Are you sure, you want to logout?"
    static let EMAIL_VERIFIED = "Email Verified"
    static let FORGOT_EMAIL_VERIFIED = "Now, You can Set New Password"
    //Validation Message
    static let NAME_REQUIRED = "Please enter the name."
    static let LNAME_REQUIRED = "Please enter the last name."
    static let FNAME_REQUIRED = "Please enter the first name."
    static let AGE_REQUIRED = "Please enter the age in years."
    static let GENDER_REQUIRED = "Please enter the gender(Male/Female)."
    static let EMAIL_REQUIRED = "Please enter a valid email."
    static let PHONE_REQUIRED = "Please enter your Mobile number."
    static let PHOTO_REQUIRED = "Please upload a Profile Picture."
    static let PASS_REQUIRED = "Please set your password."
    static let PASS_UNMATCH = "Password didn't match. Please Try Again"
    static let SHORT_PASSWORD = "Please use aleast 6 alpha numeric characters to set as password."
    static let SHORT_CHILD_PASSWORD = "Please use aleast 4 characters to set as password."
    static let ADDRESS_REQUIRED = "Please enter the address."
    static let REGISTRATION_REQUIRED = "Please provide the Registration Number"
    static let REGISTRATION_DATE_REQUIRED = "Please provide the Registration Date"
    static let PRICE_REQUIRED = "Please mention the Price"
    static let RENT_REQUIRED = "Please mention the Rent"
    static let PROPERTY_PHOTO_REQUIRED = "Please upload a Picture of the property."
    static let REJECTION_MESSAGE_REQUIRED = "Please provide the reason of rejection"
    static let FONT_TYPE_REQUIRED = "Please select the font type"
    static let FONT_COLOR_REQUIRED = "Please select the font color"
    static let WORD_NAME_REQUIRED = "Please provide the word"
    static let WORD_IMAGE_REQUIRED = "Please provide a Picture depicting the word."
    //UserDefault Keys
    let UD_IS_LOGIN = "isLogin"
    let UD_IS_SECOND_LOGIN = "isSecondLogin"
    let UD_AUTH_TYPE = "authType"
    let UD_XAUTH_KEY = "xAuth"
    let UD_FILLCOUNT = "fillCount"
    let UD_SWITCH_KISMET_CONN = "kismet"
    let UD_HIDE_KISMET = "hideKismet"
    let UD_TOKEN_TYPE = "tokenType"
    let UD_ACCESS_TOKEN = "accessToken"
    let UD_SAVE_HISTORY = "SavedStringArray"
    let UD_SAVE_HISTORY_INSTANCE = "saveHistoryInstanceID"
    let UD_BLUR_PROFILE = "isBlurProfile"
    let UD_REVEALYOUR_SELF = "isReveal"
    let UD_SHOW_ME = "showMe"
    let UD_DB_ID = "dbId"
    let PRELOAD_DATA_STORED = "ispreloaded"
    
    let UD_SWITCH_GENIE_USER_NEARBY = "usernearby"
    let UD_SWITCH_NEW_KISMET_REQUEST = "kismetrequest"
    let UD_SWITCH_NEW_MATCH = "newmatch"
    let UD_SWITCH_NEW_MESSAGE = "newmessage"
    
    let UD_SWITCH_NEW_MESSAGE_TEXT = "newmessageText"
    let UD_SWITCH_APP_REQUIRE_RESTART = "restart"

    let UD_SETTINGS_UPDATED = "settingsUpdated"
    
    
    /************** User Data store **************/
    let UD_SUPER_USER_ID = "parent_id"
    let UD_SUPER_USER_NAME = "parent_name"
    let UD_SUPER_USER_EMAIL = "parent_email"
    let UD_SUPER_USER_PASS = "parent_password"
    
    /*let UD_CHILD_NAME = "child_name"
    let UD_CHILD_PSS = "child_password"
    let UD_CHILD_PARENT = "child_parent"*/
    //For Key Constant Object of API
    
    // For ViewControllers identifiers
    static let REGISTER_VC = "RegisterViewController"
    static let TERMS_VC = "TermsVC"
    static let POLICY_VC = "PolicyVC"
    static let LOGIN_VC = "loginViewController"
    static let TAB_VC = "tabVC"
    static let USER_LIST_VC = "userListViewController"
    static let CREATE_CHILD_VC = "createChildVC"
    static let CHILD_HOME_VC = "childHomeViewController"
    static let SETUP_GAME_VC = "setUpGameVC"
    static let RECOGNIZING_VC = "recognizingVC"
    static let ADD_WORD_SIGN_VC = "AddWordAndSignVC"
    static let OPTION_VC = "optionVC"
    static let WORD_VERBAL_VC = "wordsVerbalVC"
    static let REWARDS_VC = "rewardsVC"
    static let CUES_VC = "cuesVC"
    static let LIST_VC = "listViewController"
    static let STATISTIC_VC = "statisticsVC"
    static let PLAY_VC = "playVC"
    
    static let ViewController = "ViewController"
    let Table = TableName()
    let Option = OptionName()
    let Verbal = VerbalHint()
    let RewardType = Reward()
    let DataType = D_type()

}

struct TableName {
    let PARENT = "Parents"
    let CHILDREN = "Children"
    let WORDS = "Words"
    let GAMES = "Games"
    let REWARD = "Reward_List"
}

struct OptionName {
    let FIRSTOPTION = 1
    let SECONDOPTION = 2
    let THIRDOPTION = 3
}

struct VerbalHint {
    let FIND = 1
    let SELECT = 2
    let TOUCH = 3
}

struct Reward {
    let AUDIO = "Audio"
    let VISUAL = "Visual"
    let AV = "AV"
}
struct D_type {
    let STRING = "STRING"
    let DATA = "DATA"
    let INT = "INT"
}

struct LoginConst {
    let MANUAL = "1"
    let GMAIL = "2"
    let FACEBOOK = "3"
}

struct device {
    let iOS = "IOS"
}
struct ReqStatus {
    let ACCEPT = "1"
    let REJECT = "2"
}
struct ticketsReqtype {
    let ALL = ""
    let PENDING = "0"
    let ACCEPTED = "1"
    let REJECTED = "2"
}
