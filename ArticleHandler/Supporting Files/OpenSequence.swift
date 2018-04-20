//
//  OpenSequence.swift
//  ArticleHandler
//
//  Created by Mac on 16.04.2018.
//  Copyright © 2018 dmtsolop. All rights reserved.
//

import UIKit

class OpenSequence:  Sequence, IteratorProtocol {
        var state: Int16
    
    init(seed: Int16 = 0) {
        state = seed
    }
    //TODO make this deferred
    func next() -> Int16? {
        state = state + 1
        return (state - 1)
    }
    
    
}
