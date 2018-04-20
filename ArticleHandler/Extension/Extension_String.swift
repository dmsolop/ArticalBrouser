//
//  Extension_String.swift
//  ArticleHandler
//
//  Created by Mac on 16.04.2018.
//  Copyright © 2018 dmtsolop. All rights reserved.
//

import Foundation

extension String {
    
    func sliceFrom(start: String, to: String) -> String? {
        
        if let endIndex = self.range(of: to)?.lowerBound,
            let startIndex = self.range(of: start)?.upperBound {
            return String(self [startIndex..<endIndex])
        }
        return nil
    }
}
