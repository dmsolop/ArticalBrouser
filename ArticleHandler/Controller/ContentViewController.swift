//
//  ContentViewController.swift
//  ArticleHandler
//
//  Created by Mac on 19.04.2018.
//  Copyright © 2018 dmtsolop. All rights reserved.
//

import UIKit
import CoreData

class ContentViewController: UIViewController {

    @IBOutlet weak var myWebView: UIWebView!
    var article: Claus?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myWebView.loadRequest(URLRequest(url: (article?.content_url)!))
    }

 

}
