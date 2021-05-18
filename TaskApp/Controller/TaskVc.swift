//
//  TaskVc.swift
//  TaskApp
//
//  Created by surya-zstk231 on 17/05/21.
//

import UIKit
import CoreData

class TaskVc: UIViewController {
    
    let context = Constants.context
    var itemArray = [Tasks]()
    var categoryType: Categories?

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = categoryType?.categoryName

        itemArray = DBHandler.loadTaskItems(specificCategory: (categoryType?.categoryName)!)
        
        tableView.register(UINib(nibName: Constants.taskCellNibName, bundle: nil), forCellReuseIdentifier: Constants.taskCellIdentifier)
        tableView.dataSource = self
    }
    
    @IBAction func addTaskBtnPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: Constants.addTaskSequeID, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.addTaskSequeID {
            let destionationVc = segue.destination as! AddNewTaskVc
            destionationVc.categoryType = categoryType
        }
    }
    

}
extension TaskVc: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let noOfRows = itemArray.count
        return noOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.taskCellIdentifier, for: indexPath) as! TaskViewCell
        cell.taskNameArea.text = "\(String(describing: itemArray[indexPath.row].taskName!))"
        return cell
    }
    
    
}
