//
//  AppDelegate.swift
//  Real Life Words
//
//  Created by Mac on 01/06/20.
//  Copyright © 2020 Invito Softwares. All rights reserved.
// SUMIT SINGH


import UIKit
import CoreData
import Braintree


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var word: wordModel!
    var wordArr : [wordModel]? = []
    var window: UIWindow?
    var mainStoryboard: UIStoryboard?
    var navigationController: UINavigationController?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
       // self.perform(#selector(loadData), with: nil, afterDelay: 2.0)
       
        BTAppSwitch.setReturnURLScheme("com.invito.RLW.payments")
        if !DEFAULTS.bool(forKey: Constant().PRELOAD_DATA_STORED){
            self.perform(#selector(loadData), with: nil, afterDelay: 1.0)
        }
        mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        if DEFAULTS.bool(forKey: Constant().UD_IS_LOGIN){
            self.navigateToTabBarVC()
        }else{
            self.navigateToRegisterVC()
        }
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        if url.scheme?.localizedCaseInsensitiveCompare("com.invito.RLW.payments") == .orderedSame {
            return BTAppSwitch.handleOpen(url, options: options)
        }
        return false
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "Real_Life_Words")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    func topController () ->UIViewController? {
        return UIApplication.topViewController()
    }
    
    func isTopControllerAlert () -> Bool{
           if UIApplication.shared.keyWindow?.rootViewController?.presentedViewController is UIAlertController {
               return true
           }
           return false
       }
}

extension UIApplication {
    class func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
    
}

extension AppDelegate{
    
    func navigateToTabBarVC(){
       // statisticsVC ------ (withIdentifier: Constant.TAB_VC) as! TabbarViewController
        let vc = mainStoryboard!.instantiateViewController(withIdentifier: Constant.TAB_VC) as! TabbarViewController
        navigationController = UINavigationController(rootViewController: vc)
        navigationController!.isNavigationBarHidden = true
        self.window?.rootViewController = navigationController
    }
    
    func navigateToRegisterVC(){
        let vc: UIViewController = mainStoryboard!.instantiateViewController(withIdentifier: Constant.REGISTER_VC) as! RegisterViewController
        navigationController = UINavigationController(rootViewController: vc)
        navigationController!.isNavigationBarHidden = true
        self.window?.rootViewController = navigationController
    }
    
    @objc func loadData(){
        
        let data = WordDataLoader().wordData
        for obj in data{
            let image = UIImage(named: obj.sign)
            let imagedata : Data? = image?.pngData()
            let wordData: [String: Any] = [
                "font_color": "[0.9330000281333923, 0.9760000109672546, 1.0, 1.0]",
                "font_name": "Baloo Paji",
                "name":obj.name,
                "parent_email":"",
                "user_name":"",
                "sign": imagedata!,
                "word_id": obj.word_id,
                "same_word_id": obj.same_word_id,
                "opp_word_id": obj.opp_word_id,
                "type": obj.type  
            ]
            if let word = persistenceStrategy.addWord(Entity: Constant().Table.WORDS, data: wordData){
                print(word.name!)
                DEFAULTS.set(true, forKey: Constant().PRELOAD_DATA_STORED)
            }
        }
        
        let Rdata = WordDataLoader().rewardData
        for obj in Rdata{
            let image = UIImage(named: obj.reward_Image)
            let imagedata : Data? = image?.pngData()
            let Data: [String: Any] = [
                "reward_Type":obj.reward_Type,
                "reward_Text": obj.reward_Text,
                "reward_Image": imagedata!,
                "reward_id": obj.reward_id,
                "reward_URL": obj.reward_URL
                
            ]
            if let reward = persistenceStrategy.addReward(Entity: Constant().Table.REWARD, data: Data){
                print(reward.reward_id!)
                DEFAULTS.set(true, forKey: Constant().PRELOAD_DATA_STORED)
            }
        }
        
    } 
}
