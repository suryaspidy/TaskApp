//
//  FinishedTasksVc.swift
//  TaskApp
//
//  Created by surya-zstk231 on 19/05/21.
//

import UIKit

class FinishedTasksVc: UIViewController {

    
    @IBOutlet weak var tableView: UITableView!
    var finishedTaskes = [Tasks]()
    var categoryName: String?
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UINib(nibName: Constants.taskCellNibName, bundle: nil), forCellReuseIdentifier: Constants.taskCellIdentifier)
        finishedTaskes = DBHandler.finishedTaskItems(specificCategory: categoryName!)
        tableView.dataSource = self
    }
    

}

extension FinishedTasksVc: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let noOfCells = finishedTaskes.count
        return noOfCells
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.taskCellIdentifier, for: indexPath) as! TaskViewCell
        cell.taskNameArea.text = "\(finishedTaskes[indexPath.row].taskName!)"
        return cell
    }
    
    
}
