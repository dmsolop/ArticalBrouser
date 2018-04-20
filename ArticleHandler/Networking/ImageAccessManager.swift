//
//  ImageAccessManager.swift
//  ArticleHandler
//
//  Created by Mac on 15.04.2018.
//  Copyright © 2018 dmtsolop. All rights reserved.
//

import UIKit

class ImageAccessManager {
    
    
    private var downloadTask: URLSessionDownloadTask?
    var documentsUrl: URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
    
    func saveImage(urlString: URL, session: URLSession) -> String? {
        
        let stringFromURL =  urlString.path
        let fileName = unicumNameByMD5(string: stringFromURL)
        let fileURL = documentsUrl.appendingPathComponent(fileName)
//        if FileManager.default.fileExists(atPath: fileURL.path) {
//        }
        
        self.downloadTask = session.downloadTask(
            with: urlString as URL, completionHandler: { url, response, error in
                
                if error == nil,
                    let url = url,
                    let imageData = NSData(contentsOf: url) {
                        DispatchQueue.global(qos: .userInitiated).async {
                            try? imageData.write(to: fileURL, options: .atomic)
                        }
                } else {
                    print("Error saving image : \(String(describing: error?.localizedDescription))")
                }
        })
        self.downloadTask!.resume()
        return fileName
    }
    
    func load(fileName: String) -> UIImage? {
        let fileURL = documentsUrl.appendingPathComponent(fileName)
        do {
            let imageData = try Data(contentsOf: fileURL)
            return UIImage(data: imageData as Data)
        } catch {
            print("Error loading image : \(error.localizedDescription)")
        }
        return nil
    }
    
    fileprivate func unicumNameByMD5(string: String) -> String {
        let messageData = string.data(using:.utf8)!
        var digestData = Data(count: Int(CC_MD5_DIGEST_LENGTH))
        
        _ = digestData.withUnsafeMutableBytes {digestBytes in
            messageData.withUnsafeBytes {messageBytes in
                CC_MD5(messageBytes, CC_LONG(messageData.count), digestBytes)
            }
        }
        
        return digestData.base64EncodedString()
    }
    
    
}
