//
//  gameModel.swift
//  Real Life Words
//
//  Created by Mac on 15/06/20.
//  Copyright © 2020 Invito Softwares. All rights reserved.
//

import UIKit

class gameModel: NSObject {
    
    var cue_id: Int?
    var game_id: Int?
    var option_id: Int?
    var reward_id: Int?
    var user_id: Int?
    var vis_id: Int?
    var viw_id: Int?
    var words: String?
    
    init (_ response: [String: Any]){
        self.cue_id = response["cue_id"] as? Int
        self.game_id = response["game_id"] as? Int
        self.option_id = response["option_id"] as? Int
        self.reward_id = response["reward_id"] as? Int
        self.user_id = response["user_id"] as? Int
        self.vis_id = response["vis_id"] as? Int
        self.viw_id = response["viw_id"] as? Int
        self.words = response["words"] as? String

    }
}

