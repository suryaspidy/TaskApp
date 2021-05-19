//
//  TaskVc.swift
//  TaskApp
//
//  Created by surya-zstk231 on 17/05/21.
//

import UIKit
import CoreData
protocol CountOfTaskChanged{
    func isTaskListUpdated(isUpdate: Bool)
}

class TaskVc: UIViewController {
    
    let context = Constants.context
    var itemArray = [Tasks]()
    var categoryType: Categories?
    var delegate: CountOfTaskChanged?
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = categoryType?.categoryName

        itemArray = DBHandler.loadTaskItems(specificCategory: (categoryType?.categoryName)!)
        tableView.register(UINib(nibName: Constants.taskCellNibName, bundle: nil), forCellReuseIdentifier: Constants.taskCellIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    
    @IBAction func addTaskBtnPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: Constants.addTaskSequeID, sender: self)
    }
    
    @IBAction func finishedTaskBtnPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: Constants.goToFinishedTasksPage, sender: self)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.addTaskSequeID {
            let destionationVc = segue.destination as! AddNewTaskVc
            destionationVc.categoryType = categoryType
            destionationVc.delegate = self
        } else if segue.identifier == Constants.taskSelected {
            let destinationVc = segue.destination as! TaskDetailVc
            destinationVc.categoryName = categoryType?.categoryName
            let selectedPosition = tableView.indexPathForSelectedRow!.row
            destinationVc.taskName = itemArray[selectedPosition].taskName
            destinationVc.elementPosition = selectedPosition
            destinationVc.taskDatas = itemArray
            destinationVc.delegate = self
        } else if segue.identifier ==  Constants.goToFinishedTasksPage {
            let destinationVc = segue.destination as! FinishedTasksVc
            destinationVc.categoryName = categoryType?.categoryName
        }
    }
    
    func addGestureForUpdate(viewCell: UITableViewCell,noOfSelectedElement: Int){
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(categoryCellLongPressed(_:)))
        longPressGesture.minimumPressDuration = 1
        viewCell.addGestureRecognizer(longPressGesture)
        
    }
    
    @objc func categoryCellLongPressed(_ sender: UITapGestureRecognizer){
        let elementPosition:Int = sender.view!.tag
        let alert = UIAlertController(title: "\(String(describing: itemArray[elementPosition].taskName!))", message: "", preferredStyle: .actionSheet)
        
        //MARK:- Update Actions
        let action1 = UIAlertAction(title: "Edit", style: .destructive) {[self] (action) in
            
            var textFieldAreaForUpdate = UITextField()
            
            let confirmEditAlert = UIAlertController(title: "Edit", message: "Please Change the text", preferredStyle: .alert)
            let confirmEditAction = UIAlertAction(title: "Edit", style: .destructive) { (action) in
                if textFieldAreaForUpdate.text?.isEmpty == true{
                    let emptyValAlert = UIAlertController(title: "Please Enter Correct Values", message: "", preferredStyle: .alert)
                    let emptyValAction = UIAlertAction(title: "Go back", style: .default) { (action) in
                        return
                    }
                    
                    emptyValAlert.addAction(emptyValAction)
                    present(emptyValAlert, animated: true, completion: nil)
                }
                else{
                    DBHandler.updateTaskItems(taskName: textFieldAreaForUpdate.text!, indexPathVal: elementPosition, arr: itemArray)
                    itemArray = DBHandler.loadTaskItems(specificCategory: (categoryType?.categoryName)!)
                    tableView.reloadData()
                    
                }
            }
            let confirmEditCancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
            
            confirmEditAlert.addAction(confirmEditAction)
            confirmEditAlert.addAction(confirmEditCancelAction)
            
            confirmEditAlert.addTextField { (textField) in
                textField.text = itemArray[elementPosition].taskName
                textFieldAreaForUpdate = textField
                
            }
            
            present(confirmEditAlert, animated: true, completion: nil)
            
        }
        
        //MARK:- Delete Actions
        let action2 = UIAlertAction(title: "Delete", style: .destructive) { [self] (code) in
            let confirmDeleteAlert = UIAlertController(title: "Confirm", message: "Once you delete the category you did not get again", preferredStyle: .alert)
            let confirmDeleteAction = UIAlertAction(title: "Delete", style: .default) { (action) in
                DBHandler.deleteTaskItems(indexPathVal: elementPosition, arr: itemArray)
                itemArray = DBHandler.loadTaskItems(specificCategory: (categoryType?.categoryName)!)
                delegate?.isTaskListUpdated(isUpdate: true)
                tableView.reloadData()
            }
            let confirmDeleteCancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            
            confirmDeleteAlert.addAction(confirmDeleteAction)
            confirmDeleteAlert.addAction(confirmDeleteCancelAction)
            
            present(confirmDeleteAlert, animated: true, completion: nil)
        }
        
        
        
        let action3 = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(action1)
        alert.addAction(action2)
        alert.addAction(action3)

        present(alert, animated: true, completion: nil)
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
        cell.tag = indexPath.row
        addGestureForUpdate(viewCell: cell, noOfSelectedElement: indexPath.row)
        return cell
    }
    
}

extension TaskVc: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let alert = UIAlertController(title: "\(itemArray[indexPath.row].taskName!)", message: "", preferredStyle: .actionSheet)
//        let action1 = UIAlertAction(title: "Finish task", style: .default, handler: nil)
//        let action2 = UIAlertAction(title: "Back", style: .cancel, handler: nil)
//
//        alert.addAction(action1)
//        alert.addAction(action2)
//
//        present(alert, animated: true, completion: nil)
        
        performSegue(withIdentifier: Constants.taskSelected, sender: self)
    }
}

extension TaskVc: NewTaskAdded{
    func isTaskListUpdated(isUpdate: Bool) {
        if isUpdate{
            itemArray = DBHandler.loadTaskItems(specificCategory: (categoryType?.categoryName)!)
            delegate?.isTaskListUpdated(isUpdate: true)
            tableView.reloadData()
            
        }
    }
    
    
}
