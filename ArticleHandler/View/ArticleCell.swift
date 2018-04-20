//
//  ArticleCell.swift
//  ArticleHandler
//
//  Created by Mac on 12.04.2018.
//  Copyright © 2018 dmtsolop. All rights reserved.
//

import UIKit
import CoreData

class ArticleCell: UITableViewCell {
    
    let imageAccessManager = ImageAccessManager()

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var articleImage: UIImageView!
    var article : Claus? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(article: Claus, handlerDevices: (Claus?)->(CGFloat, CGFloat, String?)) {
        self.article = article
        
        if let title = self.article!.title {
         titleLabel.text = title
        }
        if let fileName = handlerDevices(article).2 {
            articleImage.image = imageAccessManager.load(fileName: fileName)
        }
        
        titleLabel.font = titleLabel.font.withSize(handlerDevices(nil).1)
    }

    func updateDataIndex(indexPath: Int) {
        article!.index = Int16(indexPath)
    }

}
