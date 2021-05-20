//
//  AddNewCategoryVc.swift
//  TaskApp
//
//  Created by surya-zstk231 on 17/05/21.
//

import UIKit
import CoreData


class AddNewCategoryVc: UIViewController {
    
    let context = Constants.context
//    var delegate: NewCategoryAdded?   //For using delegate
    var storedCategoryData = [Categories]()
    var isNewCatergoryUpdated: ((_ isUpdate: Bool) -> Void)?

    @IBOutlet weak var customView: UIView!
    @IBOutlet weak var newCategoryNameField: UITextField!
    override func viewDidLoad() {
        
        super.viewDidLoad()

        newCategoryNameField.becomeFirstResponder()
        customView.layer.cornerRadius = customView.frame.height/10
        
    }
    
    @IBAction func addCategoryDoneBtnPressed(_ sender: UIButton) {
        if newCategoryNameField.text?.isEmpty == false{
            let addValueInCategory = Categories(context: context)
            addValueInCategory.categoryName = newCategoryNameField.text
            DBHandler.saveItems()
            
            
//            delegate?.isCategoryListUpdated(isUpdate: true)  //For using delegate
            
            
            isNewCatergoryUpdated?(true)
            newCategoryNameField.text = ""
            presentingViewController?.dismiss(animated: true, completion: nil)
            
            
        }else{
            let alert = UIAlertController(title: "Alert", message: "Please enter your category name", preferredStyle: .alert)
            let action = UIAlertAction(title: "Done", style: .cancel, handler: nil)
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
            
            
        }
    }
  

}
