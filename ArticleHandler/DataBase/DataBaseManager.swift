//
//  DataBaseManager.swift
//  ArticleHandler
//
//  Created by Mac on 15.04.2018.
//  Copyright © 2018 dmtsolop. All rights reserved.
//

import UIKit
import CoreData

class DataBaseManager {
    
    
    
    func fetchRequestCount() -> Int {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return 0 }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<Claus>(entityName: "Claus")
        do {
            return try managedContext.count(for: fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            return 0
        }
    }
    
    func fetchRequest(index: Int) -> Claus? {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { fatalError() }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest2 = NSFetchRequest<NSFetchRequestResult>(entityName: "Claus") //NSFetchRequestResult
        fetchRequest2.predicate = NSPredicate ( format: "index == %d", index)
        
        do {
            let set = try managedContext.fetch(fetchRequest2) as! [Claus]
            
            if set.count == 1 {
                set[0].value(forKey: "title")
                return set[0]
            }
            return nil
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            fatalError()
        }
    }

}
