//
//  UserData.swift
//  LoadfromJSON
//
//  Created by Ajay Gandecha on 12/15/19.
//  Copyright © 2019 Ajay Gandecha. All rights reserved.
//

import Foundation

struct WordData: Codable {
    
    var word_id: Int
    var sign: String
    var name: String

}

struct RewardData: Codable {
    
    var reward_id: Int
    var reward_Type: String
    var reward_Text: String
    var reward_Image: String

}

