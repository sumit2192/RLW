//
//  parentModel.swift
//  Real Life Words
//
//  Created by Mac on 02/06/20.
//  Copyright © 2020 Invito Softwares. All rights reserved.
//

import UIKit

class parentModel: NSObject {

    var name : String?
    var email: String?
    var password: String?
    init (_ response: [String: String]){
        self.name = response["name"] ?? Constant().BLANK
        self.email = response["email"] ?? Constant().BLANK
        self.password = response["password"] ?? Constant().BLANK

    }
}

class childModel: NSObject {
    
    var name : String?
    var parent_email: String?
    var password: String?
    var image: Data?
    var child_id : Int?
    init (_ response: [String: Any]){
        self.name = response["name"] as? String
        self.parent_email = response["parent_email"] as? String
        self.image = response["image"] as? Data
        self.password = response["password"] as? String
        self.child_id = response["child_id"] as? Int

    }
}

class wordModel: NSObject {
    var font_color: String?
    var font_name: String?
    var name: String?
    var parent_email: String?
    var sign: Data?
    var user_name: String?
    var word_id: Int?
    init (_ response: [String: Any]){
        self.font_color = response["font_color"] as? String
        self.font_name = response["font_name"] as? String
        self.name = response["name"] as? String
        self.parent_email = response["parent_email"] as? String
        self.user_name = response["user_name"] as? String
        self.sign = response["sign"] as? Data
        self.word_id = response["word_id"] as? Int

    }
}

class rewardModel: NSObject {
    var reward_id: Int?
    var reward_Type: String?
    var reward_Text: String?
    var reward_Image: Data?
    
    init (_ response: [String: Any]){
        self.reward_Type = response["reward_Type"] as? String
        self.reward_Text = response["reward_Text"] as? String
        self.reward_Image = response["reward_Image"] as? Data
        self.reward_id = response["reward_id"] as? Int

    }
}
