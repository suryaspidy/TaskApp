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
    var theme:Theme? = nil

    @IBOutlet weak var customView: UIView!
    @IBOutlet weak var newCategoryNameField: UITextField!
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        finishBtn.layer.cornerRadius = finishBtn.frame.height/2

        addItemPageColourHandler()
        descLabel.text = NSLocalizedString("ADD_ITEM_DESC", comment: "It's add new item describe text")
        finishBtn.setTitle(NSLocalizedString("ADD_DONE_BTN", comment: "It's add new item done botton"), for: .normal)
        addBackGroundViewGesture()
        newCategoryNameField.becomeFirstResponder()
        
    }
    
    func addItemPageColourHandler(){
        descLabel.backgroundColor = theme?.backgroundColour
        descLabel.textColor = theme?.textColour
        
        customView.backgroundColor = theme?.backgroundColour
//        customView.layer.borderColor = theme?.textColour.cgColor
        customView.layer.borderWidth = 2
        customView.layer.cornerRadius = customView.frame.height/15
        customView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        customView.layer.shadowColor = theme?.textColour.cgColor
        customView.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        customView.layer.shadowOpacity = 1.0
        customView.layer.shadowRadius = 5
        
        newCategoryNameField.backgroundColor = theme?.backgroundColour
        newCategoryNameField.textColor = theme?.textColour
        newCategoryNameField.layer.shadowColor = theme?.textColour.cgColor
        newCategoryNameField.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        newCategoryNameField.layer.shadowOpacity = 1.0
        newCategoryNameField.layer.shadowRadius = 3.0
        newCategoryNameField.layer.masksToBounds = false
        
        
        
        finishBtn.backgroundColor = theme?.textColour
        finishBtn.setTitleColor(theme?.backgroundColour, for: .normal)
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
