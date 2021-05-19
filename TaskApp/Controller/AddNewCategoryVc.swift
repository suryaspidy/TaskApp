//
//  AddNewCategoryVc.swift
//  TaskApp
//
//  Created by surya-zstk231 on 17/05/21.
//

import UIKit
import CoreData
protocol NewCategoryAdded {
    func isCategoryListUpdated(isUpdate: Bool)
}

class AddNewCategoryVc: UIViewController {
    let context = Constants.context
    var delegate: NewCategoryAdded?
    var storedCategoryData = [Categories]()

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
            delegate?.isCategoryListUpdated(isUpdate: true)
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
