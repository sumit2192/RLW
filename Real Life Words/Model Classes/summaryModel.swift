//
//  summaryModel.swift
//  Real Life Words
//
//  Created by webHex on 24/07/20.
//  Copyright © 2020 Invito Softwares. All rights reserved.
//

import UIKit

class summaryModel: NSObject {

    var game_id: Int?
    var child_id: Int?
    var attempts: Int?
    var right_ans: Int?
    var wrong_ans: Int?
    init (_ response: [String: Any]){
        
        self.game_id = response["game_id"] as? Int
        self.child_id = response["child_id"] as? Int
        self.attempts = response["attempts"] as? Int
        self.right_ans = response["right_ans"] as? Int
        self.wrong_ans = response["wrong_ans"] as? Int

    }
}
