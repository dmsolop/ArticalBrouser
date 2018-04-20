//
//  QueryManager.swift
//  ArticleHandler
//
//  Created by Mac on 12.04.2018.
//  Copyright © 2018 dmtsolop. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class QueryManager {
    
    typealias JSONData = [String: Any]
    typealias QueryResult = ([Claus]?, String) -> ()
    
    let imageAccessManager = ImageAccessManager()
    
    var articles: [Claus] = []
    var errorMessage = ""
    
    let defaultSession = URLSession(configuration: .default)
    var dataTask: URLSessionDataTask?
    
    
    func getRequestResults(completion: @escaping QueryResult) {
      
        dataTask?.cancel()
        
        if var urlComponents = URLComponents(string: "http://madiosgames.com/api/v1/application/ios_test_task/articles") {
            
            guard let url = urlComponents.url else { return }
            
            let appDelegate = UIApplication.shared.delegate as? AppDelegate
            
            guard let persistanceContext = appDelegate?.persistentContainer.viewContext else { return }
            
            dataTask = defaultSession.dataTask(with: url) { data, response, error in
                defer { self.dataTask = nil }
                
                if let error = error {
                    self.errorMessage += "DataTask error: " + error.localizedDescription + "\n"
                } else if let data = data,
                    let response = response as? HTTPURLResponse,
                    response.statusCode == 200 {
                    
                    self.saveDownloadedResults(data, ctx: persistanceContext)
                    
                    DispatchQueue.main.async {
                        completion(self.articles, self.errorMessage)
                    }
                }
            }
            dataTask?.resume()
        }
    }
    
    fileprivate func saveDownloadedResults(_ data: Data, ctx : NSManagedObjectContext) {
        
        let decoder = JSONDecoder()
        
        if let context = CodingUserInfoKey.context {
            decoder.userInfo[context] = ctx
        }
        do {
            try ctx.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        
        self.articles = try! decoder.decode([Claus].self, from: data)

        for (_, article) in articles.enumerated() {
            article.nameImageMedium = imageAccessManager.saveImage(urlString: article.image_medium!, session: defaultSession)
            article.nameImageThumb = imageAccessManager.saveImage(urlString: article.image_thumb!, session: defaultSession)
            
            do {
                try ctx.save()
            } catch {
                print("Could not save. \(error), \(String(describing: error._userInfo))")
            }
        }
        
    }

}

