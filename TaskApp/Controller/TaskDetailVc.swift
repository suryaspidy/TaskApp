//
//  TaskDetailVc.swift
//  TaskApp
//
//  Created by surya-zstk231 on 19/05/21.
//

import UIKit

class TaskDetailVc: UIViewController {

    @IBOutlet weak var categoryTextArea: UILabel!
    @IBOutlet weak var taskTextArea: UILabel!
    
    var categoryName: String?
    var taskName: String?
    var elementPosition: Int?
    var taskDatas = [Tasks]()
    var delegate: NewTaskAdded?
    override func viewDidLoad() {
        super.viewDidLoad()

        categoryTextArea.text = categoryName
        taskTextArea.text = taskName
    }
    
    @IBAction func backBtnPresed(_ sender: UIButton) {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func finishTaskBtnPressed(_ sender: UIButton) {
        let alert = UIAlertController(title: "Add to finish", message: "You finish the task?", preferredStyle: .actionSheet)
        let action1 = UIAlertAction(title: "Done", style: .default) { [self] (action) in
            DBHandler.finishTask(indexPathVal: elementPosition!, arr: taskDatas)
            delegate?.isTaskListUpdated(isUpdate: true)
            presentingViewController?.dismiss(animated: true, completion: nil)
        }
        let action2 = UIAlertAction(title: "Back", style: .cancel, handler: nil)
        
        alert.addAction(action1)
        alert.addAction(action2)
        
        present(alert, animated: true, completion: nil)
    }
    
}
