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
    
//    func writeDataToBase(from array: [Claus]) -> [NSManagedObject] {
//
//        var articles: [NSManagedObject] = []
//
//        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
//            return [NSManagedObject()]
//        }
//        let managedContext = appDelegate.persistentContainer.viewContext
//
//
//        for item in array {
//
//            let entity = NSEntityDescription.entity(forEntityName: "Claus", in: managedContext)!
//            let article = NSManagedObject(entity: entity, insertInto: managedContext)
//
//            article.setValue(item.id, forKeyPath: "id")
//            article.setValue(item.index, forKeyPath: "index")
//            article.setValue(item.title, forKeyPath: "title")
//            article.setValue(item.content_url, forKeyPath: "content_url")
//            article.setValue(item.image_medium, forKeyPath: "image_medium")
//            article.setValue(item.image_thumb, forKeyPath: "image_thumb")
//            article.setValue(item.nameImageMedium, forKey: "nameImageMedium")
//            article.setValue(item.nameImageThumb, forKey: "nameImageThumb")
//            article.setValue(item.contentText, forKey: "contentText")
//
//            do {
//                try managedContext.save()
//                articles.append(article)
//            } catch let error as NSError {
//                print("Could not save. \(error), \(error.userInfo)")
//            }
//        }
//        return articles
//
//    }
}
