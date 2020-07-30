//
//  DataManager.swift
//  PorpertyMgr
//
//  Created by Mac on 02/03/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import KRProgressHUD
import Alamofire
import SwiftyJSON
import Foundation

class DataManager: NSObject {

    //*****!!-------------------------!!***** For Post Api ***** !!------------------------!!*****//
    /**
     @discussion:    function to call the service for JSON response
     @paramters:     (url:String,viewcontroller : UIViewController!, parameters:[String:AnyObject]?, completionHandler: @escaping (_ data: JSON?, NSError?) -> ())
     @return: Nil
     */
    class func alamofirePostRequestWithDictionary(url:String,viewcontroller : UIViewController?, parameters:[String:AnyObject]?, completionHandler: @escaping (_ data: JSON?, NSError?,NSDictionary) -> ()) {
        print ( url)
        KRProgressHUD.show()
        if  Utility.isInternetAvailable() == true {
            
            var header : HTTPHeaders
//            if let auth = DEFAULTS.string(forKey: Constant().UD_ACCESS_TOKEN) {
//               header = ["Content-Type": "application/json",
//                                            "Accept": "application/json",
//                                            "Authorization" : auth]
//            }
//            else {
//                header  = ["Content-Type": "application/json",
//                "Accept": "application/json"]
//            }
//
            header  = ["Content-Type": "application/json",
                       "Accept": "application/json"]
            
            AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: header).responseJSON { (response) in
                switch response.result {
                case .success:
                    KRProgressHUD.dismiss()
                    if let data = response.value{
                        print(response.value!)
                        let json = JSON(data)
                        KRProgressHUD.dismiss()
                        completionHandler(json, nil, response.value as! NSDictionary)
                        
                    }
                break
                case .failure( _):
                    
                    KRProgressHUD.dismiss()
                    Utility.showAlertMessage(title: Constant().TITLE, message: (response.value.debugDescription), view: viewcontroller!)
            }


            }
        }else {
            KRProgressHUD.dismiss()
           
            Utility.showAlertMessage(title: Constant().TITLE, message: Constant().MESSAGE, view: viewcontroller!)
        }
    }
    
    //*****!!-------------------------!!***** !!--------!! ***** !!------------------------!!*****//
    //*****!!-------------------------!!***** For Post Api With image in multipart ***** !!------------------------!!*****//
    /**
     @discussion:    function to call the service for JSON response
     @paramters:    (url:String,viewcontroller : UIViewController!, parameters:[String:AnyObject]?,imageData: Data?,key:String, completionHandler: @escaping (_ data: JSON?, NSError?) -> ())
     @return: Nil
     */
/*    class func alamofirePostRequestWithImage(url:String,viewcontroller : UIViewController!, parameters:[String:AnyObject]?,imageData: Data?,key:String, completionHandler: @escaping (_ data: JSON?, NSError?) -> ()) {
        print(parameters as Any)
        KRProgressHUD.show()
        
        if  Utility.isInternetAvailable() == true {
            var header: HTTPHeaders = [:]
            if let auth = DEFAULTS.string(forKey: Constant().UD_ACCESS_TOKEN) {
                header = ["Content-type": "multipart/form-data",
                          "Authorization" : auth]
            }
            AF.upload(multipartFormData: { multipartFormData in
                for (key, value) in parameters!{
                    multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
                }
                 if let data = imageData{
                     multipartFormData.append(data, withName: (key), fileName: Utility.randomString(length: 20) + ".png", mimeType: "image/png")
                 }
                 
             },to: url).response { resp in
                     
               // print(resp.data!)
                let jsonObject = JSON(resp.value! ?? "")
                KRProgressHUD.dismiss()
                completionHandler(jsonObject, nil)
                     
            }
            
        }else {
            KRProgressHUD.dismiss()
            Utility.showAlertMessage(title: Constant().TITLE , message: "Please check Internet Connection", view: viewcontroller)
            
        }
    }*/
}







