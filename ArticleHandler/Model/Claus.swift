//
//  Claus.swift
//  ArticleHandler
//
//  Created by Mac on 12.04.2018.
//  Copyright © 2018 dmtsolop. All rights reserved.
//

import UIKit
import CoreData

extension CodingUserInfoKey {
    static let context = CodingUserInfoKey(rawValue: "context")
}

@objc(Claus)
class Claus: NSManagedObject, Decodable {

    private static let sequenceGenerator = OpenSequence()

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case content_url
        case image_medium
        case image_thumb
    }
    
    
    public required convenience init (from decoder: Decoder) throws {
        
        guard let contextUserInfoKey = CodingUserInfoKey.context else {
            fatalError("Failed to decode Article!")
        }
        guard let managedObjectContext = decoder.userInfo[contextUserInfoKey] as? NSManagedObjectContext else {
            fatalError("Failed to decode Article!")
        }
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        let originalID = try values.decode (Int16.self, forKey: .id)
        
        guard let entity = NSEntityDescription.entity(forEntityName: "Claus", in: managedObjectContext) else {
                fatalError("Failed to decode Article!")
        }
        
        self.init(entity: entity, insertInto: managedObjectContext)
        
        id = originalID
        title = try values.decode (String.self, forKey:  .title)
        content_url = try values.decode (URL.self, forKey: .content_url)
        image_medium = try values.decode (URL.self, forKey: .image_medium)
        image_thumb = try values.decode (URL.self, forKey: .image_thumb)
        index = Claus.sequenceGenerator.next()!
        
        do {
              try managedObjectContext.save();
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }

}
