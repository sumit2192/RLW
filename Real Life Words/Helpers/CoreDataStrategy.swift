//
//  CoreDataStrategy.swift
//  Strategy-Persistence
//
//  Created by Zafar on 2/14/20.
//  Copyright © 2020 Zafar. All rights reserved.
//

import UIKit
import CoreData

class CoreDataStrategy: PersistenceStrategy{

    var title: String = "Core Data Strategy"
    
    // MARK: - Create Parent
    func addParent(Entity: String, data: [String:String]) -> parentModel? {
        
        let itemEntity = NSEntityDescription.insertNewObject(forEntityName: Entity, into: context) as! Parents
        itemEntity.email = data["email"]
        itemEntity.password = data["password"]
        itemEntity.name = data["name"]
        do {
            try context.save()
        } catch {
            print(error)
            return nil
        }
        
        return parentModel(data)
        
    }
    // MARK: - Read Parent
    
    func getParent(Entity: String) -> [parentModel]{
        var arrayofParent : [parentModel] = []
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Entity)
        
        do {
            let result = try context.fetch(fetchRequest)
            
            if result.count == 0{
                return arrayofParent
            }else{
                for data in result as! [NSManagedObject] {
                    let userData: [String: String] = [
                        "name": data.value(forKey: "name")as! String,
                        "email": data.value(forKey: "email")as! String,
                        "password":data.value(forKey: "password")as! String,
                    ]
                    arrayofParent.append(parentModel(userData))
                    
                }
                return arrayofParent
            }
            
        } catch {
            print("Couldn't get items from Core Data")
            return arrayofParent
        }
    }
    
    // MARK: - Create Child
    func addChild(Entity: String, data: [String:Any]) -> childModel? {
        
        let itemEntity = NSEntityDescription.insertNewObject(forEntityName: Entity, into: context) as! Children
        itemEntity.name = data["name"] as? String
        itemEntity.child_id = Int16(data["child_id"] as! Int)
        itemEntity.parent_email = data["parent_email"] as? String
        itemEntity.password = data["password"] as? String
        itemEntity.image = data["image"] as? Data
        do {
            try context.save()
        } catch {
            print(error)
            return nil
        }
        
        return childModel(data)
    }

    // MARK: - Read Child
    func getChild(Entity: String, predicate: NSPredicate) -> [childModel]{
        var arrayofChild : [childModel] = []
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Entity)
        fetchRequest.predicate = predicate
        do {
            let result = try context.fetch(fetchRequest)
            if result.count == 0{
                return arrayofChild
            }else{
                for data in result as! [NSManagedObject] {
                    let userData: [String: Any] = [
                        "name": data.value(forKey: "name")as! String,
                        "parent_email": data.value(forKey: "parent_email")as! String,
                        "password":data.value(forKey: "password")as! String,
                        "image": data.value(forKey: "image")as! Data,
                        "child_id": data.value(forKey: "child_id")as! Int
                    ]
                    arrayofChild.append(childModel(userData))
                    
                }
                return arrayofChild
            }
            
        } catch {
            print("Couldn't get items from Core Data")
            return arrayofChild
        }
    }

    // MARK: - Create Word
    func addWord(Entity: String, data: [String:Any]) -> wordModel? {
        
        let itemEntity = NSEntityDescription.insertNewObject(forEntityName: Entity, into: context) as! Words
        itemEntity.font_color = data["font_color"] as? String
        itemEntity.font_name = data["font_name"] as? String
        itemEntity.name = data["name"] as? String
        itemEntity.parent_email = data["parent_email"] as? String
        itemEntity.user_name = data["user_name"] as? String
        itemEntity.sign = data["sign"] as? Data
        itemEntity.word_id = Int16(data["word_id"] as! Int)
        itemEntity.same_word_id = Int16(data["same_word_id"] as! Int)
        itemEntity.opp_word_id = Int16(data["opp_word_id"] as! Int)
        itemEntity.type = Int16(data["type"] as! Int)
        do {
            try context.save()
        } catch {
            print(error)
            return nil
        }
        
        return wordModel(data)
    }
    
    // MARK: - Read Word
    func getWord(Entity: String, predicate: NSPredicate?) -> [wordModel]{
        var arrayofWord : [wordModel] = []
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Entity)
        if predicate != nil {
            fetchRequest.predicate = predicate
        }
        
        
        do {
            let result = try context.fetch(fetchRequest)
            if result.count == 0{
                return arrayofWord
            }else{
                for data in result as! [NSManagedObject] {
                    let wordData: [String: Any] = [
                        "font_color": data.value(forKey: "font_color")as! String,
                        "font_name": data.value(forKey: "font_name")as! String,
                        "name":data.value(forKey: "name")as! String,
                        "parent_email":data.value(forKey: "parent_email")as! String,
                        "user_name":data.value(forKey: "user_name")as! String,
                        "sign": data.value(forKey: "sign")as! Data,
                        "word_id": data.value(forKey: "word_id")as! Int,
                        "same_word_id": data.value(forKey: "same_word_id")as! Int,
                        "opp_word_id": data.value(forKey: "opp_word_id")as! Int,
                        "type": data.value(forKey: "type")as! Int
                    ]
                    arrayofWord.append(wordModel(wordData))
                    
                }
                return arrayofWord
            }
            
        } catch {
            print("Couldn't get items from Core Data")
            return arrayofWord
        }
    }

    // MARK: - Create Rewards
    func addReward(Entity: String, data: [String:Any]) -> rewardModel? {
        
        let itemEntity = NSEntityDescription.insertNewObject(forEntityName: Entity, into: context) as! Reward_List
        itemEntity.reward_Type = data["reward_Type"] as? String
        itemEntity.reward_Text = data["reward_Text"] as? String
        itemEntity.reward_Image = data["reward_Image"] as? Data
        itemEntity.reward_id = Int16(data["reward_id"] as! Int)
        do {
            try context.save()
        } catch {
            print(error)
            return nil
        }
        
        return rewardModel(data)
    }
    
    // MARK: - Read Word
    func getRewards(Entity: String, predicate: NSPredicate?) -> [rewardModel]{
        var arrayofReward : [rewardModel] = []
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Entity)
        fetchRequest.predicate = predicate
        do {
            let result = try context.fetch(fetchRequest)
            if result.count == 0{
                return arrayofReward
            }else{
                for data in result as! [NSManagedObject] {
                    let Data: [String: Any] = [
                        "reward_Type": data.value(forKey: "reward_Type")as! String,
                        "reward_Text": data.value(forKey: "reward_Text")as! String,
                        "reward_Image": data.value(forKey: "reward_Image")as! Data,
                        "reward_id": data.value(forKey: "reward_id")as! Int
                    ]
                    arrayofReward.append(rewardModel(Data))
                    
                }
                return arrayofReward
            }
            
        } catch {
            print("Couldn't get items from Core Data")
            return arrayofReward
        }
    }
    
    // MARK: - Add Game
    func addGame(Entity: String, data: [String:Any]) -> gameModel? {
        
        let itemEntity = NSEntityDescription.insertNewObject(forEntityName: Entity, into: context) as! Games
        itemEntity.cue_id =  Int16(data["cue_id"] as! Int)
        itemEntity.game_id = Int16(data["game_id"] as! Int)
        itemEntity.option_id = Int16(data["option_id"] as! Int)
        itemEntity.reward_id = Int16(data["reward_id"] as! Int)
        itemEntity.user_id = Int16(data["user_id"] as! Int)
        itemEntity.vis_id = Int16(data["vis_id"] as! Int)
        itemEntity.viw_id = Int16(data["viw_id"] as! Int)
        itemEntity.words = data["words"] as? String
        do {
            try context.save()
        } catch {
            print(error)
            return nil
        }
        
        return gameModel(data) 
    }
      // MARK: - Read Game
    
    func getGame(Entity: String, predicate: NSPredicate) -> [gameModel]{
        var arrayofGame : [gameModel] = []
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Entity)
        fetchRequest.predicate = predicate
        
        do {
            let result = try context.fetch(fetchRequest)
            if result.count == 0{
                return arrayofGame
            }else{
                for data in result as! [NSManagedObject] {
                    let gameData: [String: Any] = [
                        "cue_id": data.value(forKey: "cue_id")as! Int,
                        "game_id": data.value(forKey: "game_id")as! Int,
                        "option_id":data.value(forKey: "option_id")as! Int,
                        "reward_id":data.value(forKey: "reward_id")as! Int,
                        "user_id":data.value(forKey: "user_id")as! Int,
                        "vis_id": data.value(forKey: "vis_id")as! Int,
                        "viw_id": data.value(forKey: "viw_id")as! Int,
                        "words": data.value(forKey: "words")as! String
                    ]
                    arrayofGame.append(gameModel(gameData))
                    
                }
                return arrayofGame
            }
            
        } catch {
            print("Couldn't get items from Core Data")
            return arrayofGame
        }
    }
    
    // MARK: - Add Summary
    func addSummary(Entity: String, data: [String:Any]) -> summaryModel? {
        
        let itemEntity = NSEntityDescription.insertNewObject(forEntityName: Entity, into: context) as! Summary
        itemEntity.game_id = Int16(data["game_id"] as! Int)
        itemEntity.child_id = Int16(data["child_id"] as! Int)
        itemEntity.attempts = Int16(data["attempts"] as! Int)
        itemEntity.right_ans = Int16(data["right_ans"] as! Int)
        itemEntity.wrong_ans = Int16(data["wrong_ans"] as! Int)
        do {
            try context.save()
        } catch {
            print(error)
            return nil
        }
        
        return summaryModel(data)
    }
    
      // MARK: - Read Summary
      // MARK:-
    func getSummary(Entity: String, predicate: NSPredicate) -> [summaryModel]{
        var arrayOfSummary : [summaryModel] = []
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Entity)
        fetchRequest.predicate = predicate
        
        do {
            let result = try context.fetch(fetchRequest)
            if result.count == 0{
                return arrayOfSummary
            }else{
                for data in result as! [NSManagedObject] {
                    let gameData: [String: Any] = [
                        "game_id": data.value(forKey: "game_id")as! Int,
                        "child_id":data.value(forKey: "child_id")as! Int,
                        "attempts":data.value(forKey: "attempts")as! Int,
                        "right_ans":data.value(forKey: "right_ans")as! Int,
                        "wrong_ans": data.value(forKey: "wrong_ans")as! Int
                    ]
                    arrayOfSummary.append(summaryModel(gameData))
                    
                }
                return arrayOfSummary
            }
            
        } catch {
            print("Couldn't get items from Core Data")
            return arrayOfSummary
        }
    }
    // MARK: - Update
    func editItem(Entity: String, predicate: NSPredicate, newData: Any, dataType: String, dataKey: String, success: @escaping () -> ()) {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Entity)
        fetchRequest.predicate = predicate
        
        do {
            let result = try context.fetch(fetchRequest)
            
            let objectToUpdate = result[0] as! NSManagedObject
            switch dataType {
            case Constant().DataType.STRING:
                objectToUpdate.setValue(newData as! String, forKey: dataKey)
            case Constant().DataType.INT:
                objectToUpdate.setValue(newData as! Int, forKey: dataKey)
            default:
                objectToUpdate.setValue(newData as! String, forKey: dataKey)
            }
            do {
                try context.save()
                success()
            } catch {
                print(error)
                Utility.showToast(controller: appDel.topController()!, message: "Something went wrong.", seconds: 1.0)
            }
        } catch {
            print(error)
            Utility.showToast(controller: appDel.topController()!, message: "Something went wrong.", seconds: 1.0)
            return
        }
    }
    
    // MARK: - Delete
    func deleteItem(Entity: String, predicate: NSPredicate, success: @escaping () -> ()) {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Entity)
        fetchRequest.predicate = predicate
        
        do {
            let result = try context.fetch(fetchRequest)
            
            if let objectToDelete = result.first as? NSManagedObject {
                context.delete(objectToDelete)
                
                do {
                    try context.save()
                    success()
                } catch {
                    print(error)
                }
            }
        } catch {
            print(error)
        }
    }
}

