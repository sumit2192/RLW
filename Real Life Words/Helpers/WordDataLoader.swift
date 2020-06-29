//
//  DataLoader.swift
//  LoadfromJSON
//
//  Created by Ajay Gandecha on 12/15/19.
//  Copyright © 2019 Ajay Gandecha. All rights reserved.
//

import Foundation

public class WordDataLoader {
    
    @Published var wordData = [WordData]()
    @Published var rewardData = [RewardData]()
    
    init() {
        load()
        loadRewards()
        sort()
    }
    
    func load() {
        
        if let fileLocation = Bundle.main.url(forResource: "wordData", withExtension: "json") {
            
            // do catch in case of an error
            do {
                let data = try Data(contentsOf: fileLocation)
                let jsonDecoder = JSONDecoder()
                let dataFromJson = try jsonDecoder.decode([WordData].self, from: data)
                
                self.wordData = dataFromJson
            } catch {
                print(error)
            }
        }
    }
    
    func loadRewards() {
        
        if let fileLocation = Bundle.main.url(forResource: "RewardData", withExtension: "json") {
            
            // do catch in case of an error
            do {
                let data = try Data(contentsOf: fileLocation)
                let jsonDecoder = JSONDecoder()
                let dataFromJson = try jsonDecoder.decode([RewardData].self, from: data)
                
                self.rewardData = dataFromJson
            } catch {
                print(error)
            }
        }
    }
    
    func sort() {
        self.wordData = self.wordData.sorted(by: { $0.word_id < $1.word_id })
        self.rewardData = self.rewardData.sorted(by: { $0.reward_id < $1.reward_id })
    }
}
