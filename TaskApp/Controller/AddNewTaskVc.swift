//
//  AddNewTaskVc.swift
//  TaskApp
//
//  Created by surya-zstk231 on 17/05/21.
//

import UIKit
import CoreData
protocol NewTaskAdded {
    func isTaskListUpdated(isUpdate: Bool)
}

class AddNewTaskVc: UIViewController {
    
    @IBOutlet weak var customView: UIView!
    let context = Constants.context

    @IBOutlet weak var newTaskNameField: UITextField!
    var categoryType: Categories?
    
    var delegate: NewTaskAdded?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        newTaskNameField.becomeFirstResponder()
        customView.layer.cornerRadius = customView.frame.height/10

    }
    
    @IBAction func addTaskDoneBtnPressed(_ sender: UIButton) {
        if newTaskNameField.text?.isEmpty == false{
            let addValueInTask = Tasks(context: context)
            addValueInTask.taskName = newTaskNameField.text
            addValueInTask.isFinish = false
            addValueInTask.parentCategory = categoryType
            DBHandler.saveItems()
            delegate?.isTaskListUpdated(isUpdate: true)
            newTaskNameField.text = ""
            presentingViewController?.dismiss(animated: true, completion: nil)
            
            
        }else{
            let alert = UIAlertController(title: "Alert", message: "Please enter your task name", preferredStyle: .alert)
            let action = UIAlertAction(title: "Done", style: .cancel, handler: nil)
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        }
    }
    
    
}
