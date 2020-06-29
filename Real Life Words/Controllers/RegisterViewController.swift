//
//  ViewController.swift
//  Real Life Words
//
//  Created by Mac on 01/06/20.
//  Copyright © 2020 Invito Softwares. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {
//MARK:- Variables andOutlets
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPass: UITextField!
    @IBOutlet weak var txtConfirm: UITextField!
    @IBOutlet weak var btnRegister: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtName.addSahadow()
        txtName.addSpace()
        txtEmail.addSahadow()
        txtEmail.addSpace()
        txtPass.addSahadow()
        txtPass.addSpace()
        txtConfirm.addSahadow()
        txtConfirm.addSpace()
        btnRegister.addSahadow()
        
        btnRegister.setButtonTitle(Title: "Register")
        
      
    }
//MARK:- Implement Button Actions
    
    @IBAction func cmdRegister(_ sender: UIButton) {
 
        if Utility.isTxtFldEmpty(txtName){
            Utility.showAlertMessage(title: Constant().TITLE, message: Constant.NAME_REQUIRED, view: self)
            return
        }else  if Utility.isTxtFldEmpty(txtEmail){
            Utility.showAlertMessage(title: Constant().TITLE, message: Constant.EMAIL_REQUIRED, view: self)
            return
        }else  if !(txtEmail.text?.isValidEmail())!{
            Utility.showAlertMessage(title: Constant().TITLE, message: Constant.EMAIL_REQUIRED, view: self)
            return
        }else  if Utility.isTxtFldEmpty(txtPass){
            Utility.showAlertMessage(title: Constant().TITLE, message: Constant.PASS_REQUIRED, view: self)
            return
        }else{
           
            if txtPass.text!.count < 6{
                Utility.showAlertMessage(title: Constant().TITLE, message: Constant.SHORT_PASSWORD, view: self)
            }else{
                if txtPass.text != txtConfirm.text {
                    Utility.showAlertMessage(title: Constant().TITLE, message: Constant.PASS_UNMATCH, view: self)
                }else{
                    //Agree to terms
                    
                    let userData: [String: String] = [
                        "name": txtName.text!,
                        "email": txtEmail.text!,
                        "password":txtPass.text!
                    ]
                    
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: Constant.TERMS_VC) as! TermsVC
                    vc.userData = userData
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                }
            }
        }
    }
    
}

