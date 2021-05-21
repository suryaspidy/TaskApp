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
    var ifTaskAddOrDelete: ((_ isUpdated: Bool) -> Void)?
    var ifCurrentIsUnFinished: Bool = true
    
    @IBOutlet weak var finishOrCurrentTaskBtn: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var taskSearchArea: UISearchBar!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = categoryType?.categoryName

        itemArray = DBHandler.loadTaskItems(specificCategory: (categoryType?.categoryName)!)
        tableView.register(UINib(nibName: Constants.taskCellNibName, bundle: nil), forCellReuseIdentifier: Constants.taskCellIdentifier)
        taskSearchArea.placeholder = NSLocalizedString("SEARCH_BOX_PLACEHOLDER_UNFINISHED", comment: "UnFinished tasks serach box area")
        tableView.dataSource = self
        taskSearchArea.delegate = self
        tableView.delegate = self
        
    }
    
    
    @IBAction func addTaskBtnPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: Constants.addTaskSequeID, sender: self)
        
    }
    
    @IBAction func finishedTaskBtnPressed(_ sender: UIBarButtonItem) {
        if ifCurrentIsUnFinished {
            finishOrCurrentTaskBtn.image = UIImage(systemName: "chevron.backward")
            ifCurrentIsUnFinished = false
            itemArray = DBHandler.finishedTaskItems(specificCategory: (categoryType?.categoryName!)!)
            taskSearchArea.text = ""
            taskSearchArea.placeholder = NSLocalizedString("SEARCH_BOX_PLACEHOLDER_FINISHED", comment: "Finished tasks search box area")
            tableView.reloadData()
        }else{
            finishOrCurrentTaskBtn.image = UIImage(systemName: "checkmark")
            itemArray = DBHandler.loadTaskItems(specificCategory: (categoryType?.categoryName)!)
            taskSearchArea.text = ""
            taskSearchArea.placeholder = NSLocalizedString("SEARCH_BOX_PLACEHOLDER_UNFINISHED", comment: "UnFinished tasks serach box area")
            tableView.reloadData()
            ifCurrentIsUnFinished = true
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.addTaskSequeID {
            let destionationVc = segue.destination as! AddNewItem
            destionationVc.categoryType = categoryType
            destionationVc.typeOfAddedElement = AddType.Task
            destionationVc.isTaskUpdated = { [self] input in
                itemArray = DBHandler.loadTaskItems(specificCategory: (categoryType?.categoryName)!)
                ifTaskAddOrDelete?(true)
                tableView.reloadData()
                
            }
        } else if segue.identifier == Constants.taskSelected {
            let destinationVc = segue.destination as! TaskDetailVc
            destinationVc.categoryName = categoryType?.categoryName
            let selectedPosition = tableView.indexPathForSelectedRow!.row
            destinationVc.taskName = itemArray[selectedPosition].taskName
            destinationVc.elementPosition = selectedPosition
            destinationVc.taskDatas = itemArray
            destinationVc.isTaskChangeFinised = { [self] input in
                itemArray = DBHandler.loadTaskItems(specificCategory: (categoryType?.categoryName)!)
                ifTaskAddOrDelete?(true)
                tableView.reloadData()
            }
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
        let action1 = UIAlertAction(title: NSLocalizedString("EDIT_ALERT_BTN", comment: "Edit Button"), style: .destructive) {[self] (action) in
            
            var textFieldAreaForUpdate = UITextField()
            
            let confirmEditAlert = UIAlertController(title: NSLocalizedString("CATEGORY_EDIT_TITLE_NAME", comment: "Edit alert title"), message: NSLocalizedString("TASK_EDIT_DESC", comment: "Edit describe text"), preferredStyle: .alert)
            let confirmEditAction = UIAlertAction(title: NSLocalizedString("EDIT_ALERT_BTN", comment: "Edit Btn"), style: .destructive) { (action) in
                if textFieldAreaForUpdate.text?.isEmpty == true{
                    let emptyValAlert = UIAlertController(title: NSLocalizedString("EMPTY_VAL_DESC", comment: "If you give empty string it throws alert title"), message: "", preferredStyle: .alert)
                    let emptyValAction = UIAlertAction(title: NSLocalizedString("CANCEL_THE_EMPTY_ALERT", comment: "Cancel the alert when empty value occuried"), style: .cancel, handler: nil)
                    emptyValAlert.addAction(emptyValAction)
                    present(emptyValAlert, animated: true, completion: nil)
                }
                else{
                    DBHandler.updateTaskItems(taskName: textFieldAreaForUpdate.text!, indexPathVal: elementPosition, arr: itemArray)
                    itemArray = DBHandler.loadTaskItems(specificCategory: (categoryType?.categoryName)!)
                    tableView.reloadData()
                    
                }
            }
            let confirmEditCancelAction = UIAlertAction(title: NSLocalizedString("CANCEL_ALERT_BTN", comment: "Cancel the edit option"), style: .cancel, handler: nil)
            
            confirmEditAlert.addAction(confirmEditAction)
            confirmEditAlert.addAction(confirmEditCancelAction)
            
            confirmEditAlert.addTextField { (textField) in
                textField.text = itemArray[elementPosition].taskName
                textFieldAreaForUpdate = textField
                
            }
            
            present(confirmEditAlert, animated: true, completion: nil)
            
        }
        
        //MARK:- Delete Actions
        let action2 = UIAlertAction(title: NSLocalizedString("DELETE_ALERT_BTN", comment: "Delete button"), style: .destructive) { [self] (code) in
            let confirmDeleteAlert = UIAlertController(title: NSLocalizedString("TASK_DELETE_TITLE_NAME", comment: "Delete alert"), message: NSLocalizedString("TASK_DELETE_DESC", comment: "Delete desc message"), preferredStyle: .alert)
            let confirmDeleteAction = UIAlertAction(title: NSLocalizedString("DELETE_ALERT_BTN", comment: "Delete button"), style: .destructive) { (action) in
                DBHandler.deleteTaskItems(indexPathVal: elementPosition, arr: itemArray)
                itemArray = DBHandler.loadTaskItems(specificCategory: (categoryType?.categoryName)!)
                ifTaskAddOrDelete?(true)
                tableView.reloadData()
            }
            let confirmDeleteCancelAction = UIAlertAction(title: NSLocalizedString("CANCEL_ALERT_BTN", comment: "Cancel delete action"), style: .cancel, handler: nil)
            
            confirmDeleteAlert.addAction(confirmDeleteAction)
            confirmDeleteAlert.addAction(confirmDeleteCancelAction)
            
            present(confirmDeleteAlert, animated: true, completion: nil)
        }
        
        
        
        let action3 = UIAlertAction(title: NSLocalizedString("CANCEL_ALERT_BTN", comment: "Cancel all option"), style: .cancel, handler: nil)
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
        performSegue(withIdentifier: Constants.taskSelected, sender: self)
    }
}

extension TaskVc: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let str = searchBar.text! + text
        if ifCurrentIsUnFinished{
            itemArray = DBHandler.filterUnfinishedTask(str: str, categoryName: (categoryType?.categoryName)!)
        }else{
            itemArray = DBHandler.filterFinishedTask(str: str, categoryName: (categoryType?.categoryName)!)
        }
        tableView.reloadData()
        return true
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        if ifCurrentIsUnFinished{
            itemArray = DBHandler.loadTaskItems(specificCategory: (categoryType?.categoryName)!)
        }
        else{
            itemArray = DBHandler.finishedTaskItems(specificCategory: (categoryType?.categoryName)!)
        }
        tableView.reloadData()
    }
     
}

