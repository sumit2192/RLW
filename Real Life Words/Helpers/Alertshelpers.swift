//
//  Alertshelpers.swift
//  PorpertyMgr
//
//  Created by Mac on 05/03/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
   
     func ShowAlert(message : String){
        let alertController = UIAlertController(title: Constant().TITLE, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
     }
    
    func ShowAlertWithPop(message : String){
        let alertController = UIAlertController(title: Constant().TITLE, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default) { (UIAlertAction) in
            
        }
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }
  
}
