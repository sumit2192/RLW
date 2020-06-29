//
//  loginViewController.swift
//  Real Life Words
//
//  Created by Mac on 02/06/20.
//  Copyright © 2020 Invito Softwares. All rights reserved.
//

import UIKit
import CoreData

class loginViewController: UIViewController {

    //MARK:- Variables and Outlets
    //MARK:-
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPass: UITextField!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var btnForgot: UIButton!
    var user : parentModel!
    var userData : [String:String] = [:]
    var userFound: Bool = false
    var pass :String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtEmail.addSahadow()
        txtEmail.addSpace()
        txtPass.addSahadow()
        txtPass.addSpace()
        btnLogin.addSahadow()
        btnLogin.setButtonTitle(Title: "Login")
    }
 
    //MARK:- Implement Custom Methods
    //MARK:-
    
    func getUser(){
        
        let parent : [parentModel] = persistenceStrategy.getParent(Entity: Constant().Table.PARENT)
        if parent.count > 0{
            for usr in parent{
                if usr.email!.caseInsensitiveCompare(txtEmail.text!) == ComparisonResult.orderedSame{
                    pass = usr.password
                    userFound = true
                    user = usr
                    break
                }
            }
            if !userFound{
                Utility.showKSAlertMessageWithOkAction(title: Constant().TITLE, message: "This email does not exist", view: self) {}
            }else{
                loginProcess()
            }
        }
    }
    
    func loginProcess(){
        if txtPass.text == pass {
            Utility.saveUserData(parentModel: user)
            DEFAULTS.set(true, forKey: Constant().UD_IS_LOGIN)
            let vc = self.storyboard?.instantiateViewController(withIdentifier: Constant.TAB_VC) as! TabbarViewController; self.navigationController?.pushViewController(vc, animated: true)
        }else{
            Utility.showKSAlertMessageWithOkAction(title: Constant().TITLE, message: "Password doest not match", view: self) {}
        }
    }

    //MARK:- Implement Button Actions
    //MARK:-
    
    @IBAction func cmdLogin(_ sender: UIButton) {
        if Utility.isTxtFldEmpty(txtEmail){
            Utility.showAlertMessage(title: Constant().TITLE, message: Constant.EMAIL_REQUIRED, view: self)
            return
        }else  if !(txtEmail.text?.isValidEmail())!{
            Utility.showAlertMessage(title: Constant().TITLE, message: Constant.EMAIL_REQUIRED, view: self)
            return
        }else  if Utility.isTxtFldEmpty(txtPass){
            Utility.showAlertMessage(title: Constant().TITLE, message: Constant.PASS_REQUIRED, view: self)
            return
        }else{
            self.getUser()
            
        }
    }
    
    @IBAction func cmdForgot(_ sender: UIButton) {
        
    }

}
