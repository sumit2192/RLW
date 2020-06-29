//
//  PersistenceStrategy.swift
//  Strategy-Persistence
//
//  Created by Zafar on 2/14/20.
//  Copyright © 2020 Zafar. All rights reserved.
//

import Foundation

protocol PersistenceStrategy: class {
    var title: String { get }
    
    func addParent(Entity: String, data: [String:String]) -> parentModel?
    func getParent(Entity: String) -> [parentModel]
    
    func addChild(Entity: String, data: [String:Any]) -> childModel?
    func getChild(Entity: String, predicate: NSPredicate) -> [childModel]
    
    func addWord(Entity: String, data: [String:Any]) -> wordModel?
    func getWord(Entity: String, predicate: NSPredicate?) -> [wordModel]
    
    func addReward(Entity: String, data: [String:Any]) -> rewardModel?
    func getRewards(Entity: String, predicate: NSPredicate?) -> [rewardModel]
    
    func addGame(Entity: String, data: [String:Any]) -> gameModel?
    func getGame(Entity: String, predicate: NSPredicate) -> [gameModel]
    
    func editItem(Entity: String, predicate: NSPredicate, newData: Any, dataType: String, dataKey: String, success: @escaping () -> ())
    func deleteItem(Entity: String, predicate: NSPredicate, success: @escaping () -> ())
    
}
