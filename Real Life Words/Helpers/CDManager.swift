//
//  CDManager.swift
//  Real Life Words
//
//  Created by Mac on 12/06/20.
//  Copyright © 2020 Invito Softwares. All rights reserved.
//

import UIKit
import CoreData

class CDManager: NSObject {
    
    func fetchDataFrom(table: String?, predicateFormat: String?, completion:  @escaping(_ status : Int) -> Void){
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: table!)
        if predicateFormat != ""{
            let predicate = NSPredicate(format: predicateFormat!)
            request.predicate = predicate
        }
        request.returnsObjectsAsFaults = false
        do{
            let obj = try context.fetch(request)
            if obj.count == 0{
                completion(0)// Data Not Found
            }else{
                completion(1)// Data Found
            }
        }catch{
            print(error.localizedDescription)
        }
        
    }
    
    func deleteDataFromtable(table:String?, predicateFormat: String?, completion:  @escaping(_ status : Int) -> Void) {
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: table!)
        if predicateFormat != ""{
            let predicate = NSPredicate(format: predicateFormat!)
            request.predicate = predicate
        }
        request.returnsObjectsAsFaults = false
        do{
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                context.delete(data)
                try context.save()
                completion(0)
            }
        }catch{
            completion(1)
            print(error.localizedDescription)
        }
    }

}
