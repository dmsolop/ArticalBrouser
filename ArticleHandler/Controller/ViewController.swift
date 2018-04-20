//
//  ViewController.swift
//  ArticleHandler
//
//  Created by Mac on 12.04.2018.
//  Copyright © 2018 dmtsolop. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    let queryManager = QueryManager()
    let dataBaseManager = DataBaseManager()
    let titleText = "Smart news"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = titleText
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if dataBaseManager.fetchRequestCount() == 0 {
            self.webRequest()
        }
    }
    
    func webRequest() {
        queryManager.getRequestResults { results, errorMessage in
            self.tableView.reloadData()
            print(errorMessage)
        }
    }
    
    func handlerOfTypeDevices(_ article: Claus? = nil) -> (CGFloat, CGFloat, String?) {
        let model = UIDevice.current.model
        
        if model == "iPhone" {
            return (55.0, 17.0, article?.nameImageThumb)
        } else {
            return (275.0, 30.0, article?.nameImageMedium)
        }
    }
    
    //MARK: - Action
    @IBAction func refreshArticles(_ sender: UIBarButtonItem) {
        tableView.reloadData()
    }
    
    @IBAction func editOrderArticles(_ sender: UIBarButtonItem) {
        tableView.isEditing = !tableView.isEditing
    }
    
    //MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let indexPath = sender as! IndexPath
        if segue.identifier == "ShowContent",
            let destinationVC = segue.destination as? ContentViewController,
            let article = dataBaseManager.fetchRequest(index: indexPath.row) {
                destinationVC.article = article
            }
        }

}

// MARK: - UITableViewDelegate and UITableViewDataSource

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataBaseManager.fetchRequestCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: ArticleCell = tableView.dequeueReusableCell(withIdentifier: String(describing:ArticleCell.self), for: indexPath) as! ArticleCell
        
        if let article = dataBaseManager.fetchRequest(index: indexPath.row) {
            cell.configure(article: article, handlerDevices: handlerOfTypeDevices(_:))
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return handlerOfTypeDevices().0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "ShowContent", sender: indexPath)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {

        let direction = sourceIndexPath < destinationIndexPath ? 1 : -1
        
        for i in stride(from: sourceIndexPath.row + direction, to: destinationIndexPath.row + direction, by: direction) {
            let indexPath = IndexPath(row: i, section: 0)
            let cell  = tableView.cellForRow(at: indexPath) as! ArticleCell
            cell.updateDataIndex(indexPath: i - direction)
        }
        
        let indexPath = IndexPath(row: sourceIndexPath.row, section: 0)
        let cell  = tableView.cellForRow(at: indexPath) as! ArticleCell
        cell.updateDataIndex(indexPath: destinationIndexPath.row)

        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        guard let persistanceContext = appDelegate?.persistentContainer.viewContext else { return }

        do {
            try persistanceContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}
