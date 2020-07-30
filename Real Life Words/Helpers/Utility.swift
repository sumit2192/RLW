//
//  GPIWUtility.swift
//  GirasolPayments_iWallet
//
//  Created by Koshal Saini on 2/1/18.
//  Copyright © 2018 Girasol. All rights reserved.
//

import UIKit
import Foundation
import SystemConfiguration
import SDWebImage 
import CoreData
import UserNotifications
import SwiftyJSON
import IQKeyboardManager

class Utility: NSObject {
    
    //  MARK:-
    //  MARK:- Api hit variable
    static var var_ApiHit = false
    
    /*
     @description: This method will Email
     @parameter: testStr
     @returns: Bool emailTest.evaluate(with: testStr)
     */
    //  MARK:-
    //  MARK:-  Check Internet Connection
    class func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    /*
     @description: This method will check empty Text Field
     @parameter: (_ textField: UITextField)
     @returns: Bool
     */
    //  MARK:-
    //  MARK:-  check email validation
    class func isTxtFldEmpty(_ textField: UITextField) -> Bool{
        return (textField.text?.isEmpty)!
    }
    
    class func isIQTxtViewEmpty(_ textView: IQTextView) -> Bool{
        return (textView.text?.isEmpty)!
    }
    
    class func isTxtViewEmpty(_ textView: UITextView) -> Bool{
        return (textView.text?.isEmpty)!
    }
    
   class func getInitialsFrom(_ str: String) -> String{
         return  str.components(separatedBy: " ").reduce("") { ($0 == "" ? "" : "\($0.first!)") + "\($1.first!)" }
    }
    //MARK:-
    //MARK:- To get random number from given array
    class func getRandomInArray(arr: [Int]) -> Int{
        let indexRandom = Int(arc4random() % UInt32(arr.count))
        return arr[indexRandom]
    }

    /* Description: This method will Check Internet Connection
     Parameter: Nil
     Returns:Bool value
     */
    //  MARK:-
    //  MARK:-  Check Internet Connection
    class func isInternetAvailable() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else {
            return false
        }

        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return false
        }
        if flags.isEmpty {
            return false
        }
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        return (isReachable && !needsConnection)
    }
    class func getElapsedTimeInSeconds(startTime : Date) -> Int
    {
        return Calendar.current.dateComponents([.hour, .minute,.second], from: startTime  , to: Date()).second!
    }
    
    class func getElapsedTimeInMinute(startTime : Date) -> Int
    {
        //        print("Elapsed Time = \(Calendar.current.dateComponents([.hour, .minute,.second], from: startTime  , to: Date()).minute!) minutes")
        return Calendar.current.dateComponents([.hour, .minute,.second], from: startTime  , to: Date()).minute!
        // print(startTime)
    }
    
    ////  Shows Toasts /////
    class func showToast(controller: UIViewController, message : String, seconds: Double) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.view.backgroundColor = UIColor.black
        alert.view.alpha = 0.6
        alert.view.layer.cornerRadius = 15
        
        controller.present(alert, animated: true)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + seconds) {
            alert.dismiss(animated: true)
        }
    }

    
    /**
     @description: This method will store the User details in core data.
     @parameter: (_ userDetails:Data, completion: @escaping () -> Void)
     @returns:Nil
     */
   /* class func saveUserDetails(_ userDetails:Data, completion: @escaping () -> Void) {
        //***** Save all entity into core data *****//
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "UserEntity",
                                                in: managedContext)!
        let person = NSManagedObject(entity: entity,
                                     insertInto: managedContext)
        person.setValue(userDetails, forKey: "userDetails")
        do {
            try managedContext.save()
            
            completion()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }*/
    /*
     @description: This method will used for clear core data.
     @parameter: (entity: String)
     @returns:nil
     */
  /*  class func deleteAllData(entity: String) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let results = try managedContext.fetch(fetchRequest)
            for managedObject in results {
                let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
                managedContext.delete(managedObjectData)
                try managedContext.save()
            }
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }*/
   /* class func  getFilteredValues(_ myProfile: UserDetail?){
        var nameAgeHeight: String?
        var seconed: String?
        var third : String?
        if myProfile?.displayNameAs != ""{
            nameAgeHeight = (myProfile?.displayNameAs)! + ", "
            if myProfile?.age != ""{
                nameAgeHeight =  myProfile?.age
            }
            if myProfile?.height != ""{
                nameAgeHeight = ", " + (myProfile?.height)!
            }
        }
        
        if myProfile?.education != ""{
            seconed = myProfile?.education
        }
        if myProfile?.livesIn != ""{
            if let _ = seconed{
                third = myProfile?.livesIn
            }
            else{
                seconed = myProfile?.livesIn
            }
        }
        if myProfile?.carModel != ""{
            if let _ = seconed{
                third = myProfile?.carModel
            }
            else{
                seconed = myProfile?.carModel
            }
        }
        if myProfile?.bodyType != ""{
            if let _ = seconed{
                third = myProfile?.bodyType
            }
            else{
                seconed = myProfile?.bodyType
            }
        }
        
        if myProfile?.jobTitle != ""{
            if let _ = seconed{
                third = myProfile?.jobTitle
            }
            else{
                seconed = myProfile?.jobTitle
            }
        }
    }*/
    
    /*
     * To get random string of given length
     */
    class func randomString(length: Int) -> String {
        
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = UInt32(letters.length)
        
        var randomString = ""
        
        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        
        return randomString
    }
    
    /*
     @description: To get the history of array
     @parameters:  Nil
     @returns: ( [String],[String]), where at first index array of tokenId and thebn array of instanceID
    */
    class func retreiveHistory() ->  [String] {
       // return DEFAULTS.stringArray(forKey: Constant().UD_SAVE_HISTORY) ?? [String]()
        return [""]
    }
    
    /*
     @description : This method is used to store userData locally
    **/
    class func saveUserData(parentModel : parentModel){

        DEFAULTS.set(parentModel.name, forKey: Constant().UD_SUPER_USER_NAME)
        DEFAULTS.set(parentModel.email, forKey: Constant().UD_SUPER_USER_EMAIL)
        DEFAULTS.set(parentModel.password, forKey: Constant().UD_SUPER_USER_PASS)

       
    }
    
  /*  class func saveNewUserData(registerModel : NewLoginModel){
        DEFAULTS.set(registerModel.user?.id, forKey: Constant().UD_USER_ID)
        DEFAULTS.set(registerModel.user?.f_name, forKey: Constant().UD_USER_FIRSTNAME)
        DEFAULTS.set(registerModel.user?.l_name, forKey: Constant().UD_USER_LASTNAME)
        DEFAULTS.set(registerModel.user?.age, forKey: Constant().UD_USER_AGE)
        DEFAULTS.set(registerModel.user?.gender, forKey: Constant().UD_USER_GENDER)
        DEFAULTS.set(registerModel.user?.phone_number, forKey: Constant().UD_USER_PHONE)
        DEFAULTS.set(registerModel.user?.country_code, forKey: Constant().UD_USER_COUNTRYCODE)
        DEFAULTS.set(registerModel.user?.email, forKey: Constant().UD_USER_EMAIL)
        DEFAULTS.set(registerModel.user?.login_Type, forKey: Constant().UD_USER_LOGIN_TYPE);
        DEFAULTS.set(registerModel.user?.profession, forKey: Constant().UD_USER_PROFESSION)
        DEFAULTS.set(registerModel.user?.fbToken, forKey: Constant().UD_USER_FBTOKEN)
        DEFAULTS.set(registerModel.user?.gmailToken, forKey: Constant().UD_USER_GTOKEN)
        DEFAULTS.set(registerModel.user?.login_Status, forKey: Constant().UD_USER_LOGINSTATUS)
        DEFAULTS.set(registerModel.user?.device_Type, forKey: Constant().UD_USER_DEVICETYPE)
        DEFAULTS.set(registerModel.user?.bio, forKey: Constant().UD_USER_BIO)
        DEFAULTS.set(registerModel.user?.profilePic, forKey: Constant().UD_USER_PIC)
        DEFAULTS.set(registerModel.user?.role, forKey: Constant().UD_USER_ROLE)
        
    }*/
    
    class func clearUserDefaultsData(){
        DEFAULTS.removeObject(forKey: Constant().UD_SUPER_USER_NAME)
        DEFAULTS.removeObject(forKey: Constant().UD_SUPER_USER_EMAIL)
        DEFAULTS.removeObject(forKey: Constant().UD_SUPER_USER_PASS)
    }
    
    /*
     @description : This method is used to store userData locally
     **/
   /* class func saveUserDataFromEditProfile(loginModel : NewUserModel){
        DEFAULTS.set(loginModel.creditBalance, forKey: Constant().UD_USER_CREDIT)
        DEFAULTS.set(loginModel.name, forKey: Constant().UD_USER_NAME)
        DEFAULTS.set(loginModel.displayName, forKey: Constant().UD_USER_DISPLAY_NAME)
        DEFAULTS.set(loginModel.displayNameAs, forKey: Constant().UD_USER_DISPLAY_NAME_AS)
        DEFAULTS.set(loginModel.age, forKey: Constant().UD_USER_AGE)
        DEFAULTS.set(loginModel.gender, forKey: Constant().UD_USER_GENDER)
        DEFAULTS.set(loginModel.height, forKey: Constant().UD_USER_HEIGHT)
        DEFAULTS.set(loginModel.education, forKey: Constant().UD_USER_EDUCATION)
        DEFAULTS.set(loginModel.jobTitle, forKey: Constant().UD_USER_JOB_TITLE)
        DEFAULTS.set(loginModel.companyName, forKey: Constant().UD_USER_COMPANY_NAME);
        DEFAULTS.set(loginModel.livesIn, forKey: Constant().UD_USER_LIVES_IN)
        DEFAULTS.set(loginModel.carModel, forKey: Constant().UD_USER_CAR_MODEL)
        DEFAULTS.set(loginModel.bodyType, forKey: Constant().UD_USER_BODY_TYPE)
        DEFAULTS.set(loginModel.aboutMe, forKey: Constant().UD_USER_ABOUT_ME)
        DEFAULTS.set(loginModel.imageArr, forKey: Constant().UD_USER_IMAGE_ARR)
        DEFAULTS.set(loginModel.userId, forKey: Constant().UD_USER_USER_ID)
        DEFAULTS.set(loginModel.phoneNo, forKey: Constant().UD_USER_PHONE_NO)
        
        DEFAULTS.set(loginModel.revealFromArray, forKey: Constant().UD_REVEALFROM_ARRAY)
UserDefaults.standard.set(true , forKey:Constant().UD_SETTINGS_UPDATED)
        DEFAULTS.set(loginModel.kismatconnection , forKey:Constant().UD_SWITCH_KISMET_CONN)
        DEFAULTS.set(loginModel.hazypicture , forKey:Constant().UD_BLUR_PROFILE)
        DEFAULTS.set(loginModel.showme , forKey:Constant().UD_SHOW_ME)
        DEFAULTS.set(loginModel.kismatvisibility , forKey:Constant().UD_HIDE_KISMET)
        
        DEFAULTS.set(loginModel.showNearbyUserNotification , forKey:Constant().UD_SWITCH_GENIE_USER_NEARBY)
        DEFAULTS.set(loginModel.showNewKismetRequestNotification , forKey:Constant().UD_SWITCH_NEW_KISMET_REQUEST)
        DEFAULTS.set(loginModel.showNewMatchNotification , forKey:Constant().UD_SWITCH_NEW_MATCH)
        DEFAULTS.set(loginModel.showNewMessageNotification , forKey:Constant().UD_SWITCH_NEW_MESSAGE)
        DEFAULTS.set(loginModel.showNewMessageTextNotification , forKey:Constant().UD_SWITCH_NEW_MESSAGE_TEXT)
        DEFAULTS.set(loginModel.appRestartNotification , forKey:Constant().UD_SWITCH_APP_REQUIRE_RESTART)
    }*/
    
     /*
     @description: Method used for show alert message
     @parameters:  (title: String, message: String, view: UIViewController)
     @returns:Nil
     */
    
    
  /*  class func saveUserDataFromUserDetail(loginModel : UserDetail){
        

        UserDefaults.standard.set(true , forKey:Constant().UD_SETTINGS_UPDATED)
        UserDefaults.standard.set(loginModel.kismatConnection , forKey:Constant().UD_SWITCH_KISMET_CONN)
        UserDefaults.standard.set(loginModel.hazy , forKey:Constant().UD_BLUR_PROFILE)
        UserDefaults.standard.set(loginModel.showme , forKey:Constant().UD_SHOW_ME)
        UserDefaults.standard.set(loginModel.kismatvisibility , forKey:Constant().UD_HIDE_KISMET)
//        UserDefaults.standard.set(loginModel.showNearbyUserNotification , forKey:Constant().UD_SWITCH_GENIE_USER_NEARBY)
//        UserDefaults.standard.set(loginModel.showNewKismetRequestNotification , forKey:Constant().UD_SWITCH_NEW_KISMET_REQUEST)
//        UserDefaults.standard.set(loginModel.showNewMatchNotification , forKey:Constant().UD_SWITCH_NEW_MATCH)
//        UserDefaults.standard.set(loginModel.showNewMessageNotification , forKey:Constant().UD_SWITCH_NEW_MESSAGE)
//        UserDefaults.standard.set(loginModel.showNewMessageTextNotification , forKey:Constant().UD_SWITCH_NEW_MESSAGE_TEXT)
//        UserDefaults.standard.set(loginModel.appRestartNotification , forKey:Constant().UD_SWITCH_APP_REQUIRE_RESTART)
    
    }*/
    
   /* class func clearUserDefaults(){
        // rnapier 2019-06-15 removed Nearby for now
        //        appDel.stopSharingAndScanning()
        
        Utility.deleteAllData(entity: ENTITY)
        UserDefaults.standard.removeObject(forKey: Constant().UD_IS_LOGIN)
        UserDefaults.standard.removeObject(forKey: Constant().UD_XAUTH_KEY)
        UserDefaults.standard.removeObject(forKey: Constant().UD_AUTH_TYPE)
        UserDefaults.standard.removeObject(forKey: Constant().UD_FILLCOUNT)
        UserDefaults.standard.removeObject(forKey: Constant().UD_ACCESS_TOKEN)
        //        DEFAULTS.removeObject( forKey: Constant().SETTINGS_UPDATED)
        DEFAULTS.removeObject(forKey: Constant().UD_SWITCH_KISMET_CONN)
        DEFAULTS.removeObject(forKey: Constant().UD_HIDE_KISMET)
        DEFAULTS.removeObject(forKey: Constant().UD_TOKEN_TYPE)
        DEFAULTS.removeObject(forKey: Constant().UD_ACCESS_TOKEN)
        DEFAULTS.removeObject(forKey: Constant().UD_SAVE_HISTORY)
        DEFAULTS.removeObject(forKey: Constant().UD_BLUR_PROFILE)
        DEFAULTS.removeObject(forKey: Constant().UD_SHOW_ME)
        DEFAULTS.removeObject(forKey: Constant().UD_DB_ID)
        
        DEFAULTS.removeObject(forKey: Constant().UD_USER_NAME)
        DEFAULTS.removeObject(forKey: Constant().UD_USER_DISPLAY_NAME)
        DEFAULTS.removeObject(forKey: Constant().UD_USER_DISPLAY_NAME_AS)
        DEFAULTS.removeObject(forKey: Constant().UD_USER_AGE)
        DEFAULTS.removeObject(forKey: Constant().UD_USER_HEIGHT)
        DEFAULTS.removeObject(forKey: Constant().UD_USER_GENDER)
        DEFAULTS.removeObject(forKey: Constant().UD_USER_EDUCATION)
        DEFAULTS.removeObject(forKey: Constant().UD_USER_JOB_TITLE)
        DEFAULTS.removeObject(forKey: Constant().UD_USER_COMPANY_NAME)
        DEFAULTS.removeObject(forKey: Constant().UD_USER_LIVES_IN)
        DEFAULTS.removeObject(forKey: Constant().UD_USER_CAR_MODEL)
        DEFAULTS.removeObject(forKey: Constant().UD_USER_BODY_TYPE)
        DEFAULTS.removeObject(forKey: Constant().UD_USER_ABOUT_ME)
        DEFAULTS.removeObject(forKey: Constant().UD_USER_IMAGE_ARR)
        DEFAULTS.removeObject(forKey: Constant().UD_USER_USER_ID)
        DEFAULTS.removeObject(forKey: Constant().UD_USER_PHONE_NO)
        DEFAULTS.removeObject(forKey: Constant().UD_USER_HISTORY_TIME)
        DEFAULTS.removeObject(forKey: Constant().UD_SWITCH_GENIE_USER_NEARBY)
        DEFAULTS.removeObject(forKey: Constant().UD_SWITCH_NEW_KISMET_REQUEST)
        DEFAULTS.removeObject(forKey: Constant().UD_SWITCH_NEW_MATCH)
        DEFAULTS.removeObject(forKey: Constant().UD_SWITCH_NEW_MESSAGE)
        DEFAULTS.removeObject(forKey: Constant().UD_SWITCH_NEW_MESSAGE_TEXT)
        DEFAULTS.removeObject(forKey: Constant().UD_SWITCH_APP_REQUIRE_RESTART)
        DEFAULTS.removeObject(forKey: Constant().UD_USER_CREDIT)
        DEFAULTS.removeObject(forKey: Constant().UD_HISTORY_CREDIT_ARR)
        DEFAULTS.removeObject(forKey: Constant().UD_HISTORY_TIMES_ARR)
        DEFAULTS.removeObject(forKey: Constant().UD_HISTORY_EXP_ARR)
        DEFAULTS.removeObject(forKey: Constant().UD_DELAY_CREDIT_ARR)
        DEFAULTS.removeObject(forKey: Constant().UD_DELAY_TIMES_ARR)
        DEFAULTS.removeObject(forKey: Constant().UD_DELAY_EXP_ARR)
        
        
    }*/
    class func showKSAlertMessage(title: String, message: String, view: UIViewController) {
        let objAlert: UIAlertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        //Create and an option action
        let nextAction: UIAlertAction = UIAlertAction(title: "OK", style: .cancel) { action -> Void in
            //Do some other stuff
        }
        objAlert.addAction(nextAction)
        view.present(objAlert, animated: true, completion: nil)
    }
    class func notification(title : String , body : String ) {
        
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = UNNotificationSound.default
        
        // Deliver the notification in 60 seconds.
        let trigger = UNTimeIntervalNotificationTrigger.init(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest.init(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        // Schedule the notification.
        let center = UNUserNotificationCenter.current()
        center.add(request)
    }
    /*
     @description: Method used for show alert message with ok action
     @parameters:  (title: String, message: String, view: UIViewController)
     @returns:Nil
     */
    class func showksAlertMessageWithOkAndCancelAction(title: String, message: String, view: UIViewController, completion: @escaping () -> Void) {
        let objAlert: UIAlertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        //Create and an option action
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .default) { action -> Void in
        }
        let nextAction: UIAlertAction = UIAlertAction(title: "OK", style: .default) { action -> Void in
            completion()
        }
       
        objAlert.addAction(cancelAction)
        objAlert.addAction(nextAction)
        view.present(objAlert, animated: true, completion: nil)
    }
    
    
    class func showksAlertMessageWithTwoAction(title: String, message: String, view: UIViewController, completion: @escaping (_ action: Int) -> Void) {
        let objAlert: UIAlertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        //Create and an option action
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .default) { action -> Void in
            completion(2)
        }
        let nextAction: UIAlertAction = UIAlertAction(title: "OK", style: .default) { action -> Void in
            completion(1)
        }
       
        objAlert.addAction(cancelAction)
        objAlert.addAction(nextAction)
        view.present(objAlert, animated: true, completion: nil)
    }
    /*
     @description: Method used for show alert message
     @parameters:  (title: String, message: String, view: UIViewController)
     @returns:Nil
     */
    

    class func showKSAlertMessageWithOkAction(title: String, message: String, view: UIViewController, completion: @escaping () -> Void) {
        let objAlert: UIAlertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        //Create and an option action
        let nextAction: UIAlertAction = UIAlertAction(title: "OK", style: .cancel) { action -> Void in
            //Do some other stuff
            completion()
        }
        objAlert.addAction(nextAction)
        view.present(objAlert, animated: true, completion: nil)
    }
    
    /*
     @description: Method used for move on specific screen
     @parameters:  navController, storyBoard, vcID
     @returns:Nil
     */
    class func goToScreen(navController:UINavigationController, storyBoard:UIStoryboard, vcID:String) {
        let objVC = storyBoard.instantiateViewController(withIdentifier:vcID)
        navController.pushViewController(objVC, animated: true)
    }
    
    
    /*
     @description: Method used for download image from server
     @parameters:  imageUrl,imageView
     @returns:Nil
     */
    class func downloadProfileImage(url:String,imageView:UIImageView) {
        
        imageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
        imageView.sd_setImage(with: URL(string: url), placeholderImage: UIImage(named: "ic_user"))
               // imageView.layer.cornerRadius = imageView.frame.size.width / 2
        imageView.clipsToBounds = true
    }
    
    /*
     @description: This method will used for animate view from bottom to top.
     @parameter: (animateView:UIView)
     @returns:Nil
     */
    class func addSubView(addSubView:UIView, viewController:UIViewController) {
        addSubView.frame = viewController.view.frame
        addSubView.center = viewController.view.center
        viewController.view.addSubview(addSubView)
    }
    
    
    /*
     @description: Method used for show alert message
     @parameters:  (title: String, message: String, view: UIViewController)
     @returns:Nil
     */
    class func showAlertMessage(title: String, message: String, view: UIViewController) {
        if !appDel.isTopControllerAlert() {  
        let objAlert: UIAlertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        //Create and an option action
        let nextAction: UIAlertAction = UIAlertAction(title: "OK", style: .cancel) { action -> Void in
            //Do some other stuff
        }
        objAlert.addAction(nextAction)
        
        view.present(objAlert, animated: true, completion: nil)
        }
    }
    
    /*
     @description: Method used for move on specific screen
     @parameters:  ControllerID,  viewController
     @returns:Nil
     */
    
    class func goToViewController(controllerID:String, viewController:UIViewController) {
        let objVC = viewController.storyboard?.instantiateViewController(withIdentifier: controllerID)
        viewController.navigationController?.pushViewController(objVC!, animated: true)
    }

    
    class func getUserId(_ instanceId: String) -> String{
        //1000000000123
        let charArr = Array(instanceId)
        var index = 0
        for i in 0..<charArr.count {
            if i == 0 || i == 1 || i == 2{
                continue
            }
            if charArr[i] != "0" {
                index = i
                break
            }
        }
        let userId = instanceId.suffix(12 - index)
        return String(userId)
    }
    

    class func convertStringToDate(refString:String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let actualdate = dateFormatter.date(from: refString)
        return actualdate!
    }
    class func convertDateToString(refDate:Date, refFormat:String) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = refFormat
        let dateString = dateFormatter.string(from: refDate)
        return dateString
    }
    
    class func convertDateToStamp(dt: Date) -> Int{
        let dfmatter = DateFormatter()
        dfmatter.dateFormat="yyyy-MM-dd"
        let dateStamp:TimeInterval = dt.timeIntervalSince1970
        return Int(dateStamp)
    }

}
