//
//  AddNewTaskVc.swift
//  TaskApp
//
//  Created by surya-zstk231 on 17/05/21.
//

import UIKit
import CoreData

class AddNewTaskVc: UIViewController {
    
    @IBOutlet weak var customView: UIView!
    let context = Constants.context

    @IBOutlet weak var newTaskNameField: UITextField!
    var categoryType: Categories?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customView.layer.cornerRadius = customView.frame.height/10

        // Do any additional setup after loading the view.
    }
    
    @IBAction func addTaskDoneBtnPressed(_ sender: UIButton) {
        if newTaskNameField.text?.isEmpty == false{
            let addValueInTask = Tasks(context: context)
            addValueInTask.taskName = newTaskNameField.text
            addValueInTask.parentCategory = categoryType
            DBHandler.saveItems()
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
