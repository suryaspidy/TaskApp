//
//  AddNewCategoryVc.swift
//  TaskApp
//
//  Created by surya-zstk231 on 17/05/21.
//

import UIKit
import CoreData

enum AddType: String{
    case Task = "Task"
    case Category = "Category"
}

class AddNewItem: UIViewController {
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var finishBtn: UIButton!
    let context = Constants.context
    var storedCategoryData = [Categories]()
    var isTaskUpdated: ((_ isUpdated: Bool) -> Void)?
    var isNewCatergoryUpdated: ((_ isUpdate: Bool) -> Void)?
    var typeOfAddedElement: AddType?
    var categoryType: Categories?

    @IBOutlet weak var customView: UIView!
    @IBOutlet weak var newCategoryNameField: UITextField!
    override func viewDidLoad() {
        
        super.viewDidLoad()

        descLabel.text = NSLocalizedString("ADD_ITEM_DESC", comment: "It's add new item describe text")
        finishBtn.setTitle(NSLocalizedString("ADD_DONE_BTN", comment: "It's add new item done botton"), for: .normal)
        addBackGroundViewGesture()
        newCategoryNameField.becomeFirstResponder()
        
    }
    
    func addBackGroundViewGesture(){
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(backgroundTapped))
        mainView.addGestureRecognizer(tapGesture)
    }
    
    @objc func backgroundTapped(){
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    @IBAction func addCategoryDoneBtnPressed(_ sender: UIButton) {
        
        switch typeOfAddedElement {
        case .Category:
            if newCategoryNameField.text?.isEmpty == false{
                let addValueInCategory = Categories(context: context)
                addValueInCategory.categoryName = newCategoryNameField.text
                DBHandler.saveItems()
                isNewCatergoryUpdated?(true)
                newCategoryNameField.text = ""
                presentingViewController?.dismiss(animated: true, completion: nil)
            }else{
                let alert = UIAlertController(title: NSLocalizedString("ADD_EMPTY_ITEM_ALERT_TITLE_NAME", comment: "Empty new item add alert title name"), message: NSLocalizedString("ADD_EMPTY_ITEM_ALERT_DESC", comment: "Empty new item add alert desc"), preferredStyle: .alert)
                let action = UIAlertAction(title: NSLocalizedString("ADD_EMPTY_ITEM_GO_BACK_BTN", comment: "Done button"), style: .cancel, handler: nil)
                alert.addAction(action)
                present(alert, animated: true, completion: nil)
            }
        case .Task:
            if newCategoryNameField.text?.isEmpty == false{
                let addValueInTask = Tasks(context: context)
                addValueInTask.taskName = newCategoryNameField.text
                addValueInTask.isFinish = false
                addValueInTask.parentCategory = categoryType
                DBHandler.saveItems()
                isTaskUpdated?(true)
                newCategoryNameField.text = ""
                presentingViewController?.dismiss(animated: true, completion: nil)
                
                
            }else{
                let alert = UIAlertController(title: NSLocalizedString("ADD_EMPTY_ITEM_ALERT_TITLE_NAME", comment: "Empty new item add alert title name"), message: NSLocalizedString("ADD_EMPTY_ITEM_ALERT_DESC", comment: "Empty new item add alert desc"), preferredStyle: .alert)
                let action = UIAlertAction(title: NSLocalizedString("ADD_EMPTY_ITEM_GO_BACK_BTN", comment: "Done button"), style: .cancel, handler: nil)
                alert.addAction(action)
                present(alert, animated: true, completion: nil)
            }
        case .none:
            print(Error.self)
        }
        
        
    }
  

}
