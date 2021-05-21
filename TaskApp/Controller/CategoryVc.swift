//
//  CategoryVc.swift
//  TaskApp
//
//  Created by surya-zstk231 on 17/05/21.
//

import UIKit
import CoreData

class CategoryVc: UIViewController, UICollectionViewDelegate{
    
    
    var categoryData = [Categories]()
    var noOfSelectedPosition = 0
    var intForAddDummyCell = 0
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = NSLocalizedString("GROUP_PAGE_TITLE", comment: "Category page title")
        print(Constants.dataFilePath)
        categoryData = DBHandler.loadCategoryItems()
        collectionView.register(UINib(nibName: Constants.groupCellNibName, bundle: nil), forCellWithReuseIdentifier: Constants.groupCellIdendifier)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        

    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        noOfSelectedPosition = indexPath.row
        performSegue(withIdentifier: Constants.goToTaskPage, sender: self)
       
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == Constants.goToTaskPage{
            let destinationVc = segue.destination as! TaskVc
            destinationVc.categoryType = categoryData[noOfSelectedPosition]
            destinationVc.ifTaskAddOrDelete = {[self] input in
                categoryData = DBHandler.loadCategoryItems()
                collectionView.reloadData()
            }
        }
        else if segue.identifier == Constants.addCategorySequeID{
            let destinationVc = segue.destination as! AddNewItem
            destinationVc.typeOfAddedElement = AddType.Category
            destinationVc.isNewCatergoryUpdated = { input in
                self.categoryData = DBHandler.loadCategoryItems()
                self.collectionView.reloadData()
            }
        }
    }
    
    
    
    @IBAction func addCategoryBtnPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: Constants.addCategorySequeID, sender: self)
    }
    
    func addGestureForUpdate(viewCell: UICollectionViewCell,noOfSelectedElement: Int){
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(categoryCellLongPressed(_:)))
        longPressGesture.minimumPressDuration = 1
        viewCell.addGestureRecognizer(longPressGesture)
    }
    
    @objc func categoryCellLongPressed(_ sender: UITapGestureRecognizer){
        let elementPosition:Int = sender.view!.tag
        let alert = UIAlertController(title: "\(String(describing: categoryData[elementPosition].categoryName!))", message: "", preferredStyle: .actionSheet)
        
        
        //MARK:- Update Actions
        let action1 = UIAlertAction(title: NSLocalizedString("EDIT_ALERT_BTN", comment: "Edit Button"), style: .destructive) {[self] (action) in
            
            var textFieldAreaForUpdate = UITextField()
            
            let confirmEditAlert = UIAlertController(title: NSLocalizedString("CATEGORY_EDIT_TITLE_NAME", comment: "Edit alert title"), message: NSLocalizedString("CATEGORY_EDIT_DESC", comment: "Edit describe text"), preferredStyle: .alert)
            let confirmEditAction = UIAlertAction(title: NSLocalizedString("EDIT_ALERT_BTN", comment: "Edit Btn"), style: .destructive) { (action) in
                if textFieldAreaForUpdate.text?.isEmpty == true{
                    let emptyValAlert = UIAlertController(title: NSLocalizedString("EMPTY_VAL_DESC", comment: "If you give empty string it throws alert title"), message: "", preferredStyle: .alert)
                    let emptyValAction = UIAlertAction(title: NSLocalizedString("CANCEL_THE_EMPTY_ALERT", comment: "Cancel the alert when empty value occuried"), style: .cancel) { (action) in
                        return
                    }
                    
                    emptyValAlert.addAction(emptyValAction)
                    present(emptyValAlert, animated: true, completion: nil)
                }
                else{
                    DBHandler.updateCategoryItem(categoryName: textFieldAreaForUpdate.text!, indexPathVal: elementPosition, arr: categoryData)
                    categoryData = DBHandler.loadCategoryItems()
                    collectionView.reloadData()
                    
                }
            }
            let confirmEditCancelAction = UIAlertAction(title: NSLocalizedString("CANCEL_ALERT_BTN", comment: "Cancel the edit option"), style: .cancel, handler: nil)
            
            confirmEditAlert.addAction(confirmEditAction)
            confirmEditAlert.addAction(confirmEditCancelAction)
            
            confirmEditAlert.addTextField { (textField) in
                textField.text = categoryData[elementPosition].categoryName
                textFieldAreaForUpdate = textField
                
            }
            
            present(confirmEditAlert, animated: true, completion: nil)
            
        }

        //MARK:- Delete Actions
        let action2 = UIAlertAction(title: NSLocalizedString("DELETE_ALERT_BTN", comment: "Delete button"), style: .destructive) { [self] (code) in
            let confirmDeleteAlert = UIAlertController(title: NSLocalizedString("CATEGORY_DELETE_TITLE_NAME", comment: "Delete alert"), message: NSLocalizedString("CATEGORY_DELETE_DESC", comment: "Delete desc message"), preferredStyle: .alert)
            let confirmDeleteAction = UIAlertAction(title: NSLocalizedString("DELETE_ALERT_BTN", comment: "Delete button"), style: .destructive) { (action) in
                DBHandler.deleteCategoryItem(indexPathVal: elementPosition, arr: categoryData)
                categoryData = DBHandler.loadCategoryItems()
                collectionView.reloadData()
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

extension CategoryVc: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let noOfCategories = categoryData.count
        if noOfCategories == 1{
            
            return 2
        }
        return noOfCategories
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print(categoryData.count)
        if categoryData.count == 1{
            if intForAddDummyCell == 0{
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.groupCellIdendifier, for: indexPath) as! GroupViewCell
                let name = String(describing: categoryData[0].categoryName!)
                let noOfTasks = DBHandler.loadTaskItems(specificCategory: categoryData[0].categoryName!)
                cell.categoryNameArea.text = name
                cell.taskCount.text = "\(noOfTasks.count)"
                print("1")
                cell.tag = 0
                cell.mainView.tag = 0
                addGestureForUpdate(viewCell: cell, noOfSelectedElement: indexPath.row)
                intForAddDummyCell = 1
                return cell
            }else if intForAddDummyCell == 1 {
                let cellDummy = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.groupCellIdendifier, for: indexPath) as! GroupViewCell
                cellDummy.isUserInteractionEnabled = false
                cellDummy.mainView.backgroundColor = .none
                cellDummy.taskCount.textColor = .systemGray6
                cellDummy.categoryNameArea.textColor = .systemGray6
                print("2")
                intForAddDummyCell = 0
                return cellDummy
            }
            
        }
        
        else if categoryData.count != 1{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.groupCellIdendifier, for: indexPath) as! GroupViewCell
        let name = String(describing: categoryData[indexPath.row].categoryName!)
        let noOfTasks = DBHandler.loadTaskItems(specificCategory: categoryData[indexPath.row].categoryName!)
        cell.categoryNameArea.text = name
        cell.taskCount.text = "\(noOfTasks.count)"
            cell.mainView.backgroundColor = .white
        cell.taskCount.textColor = .black
        cell.categoryNameArea.textColor = .black
        cell.isUserInteractionEnabled = true
        cell.tag = indexPath.row
        cell.mainView.tag = indexPath.row
        addGestureForUpdate(viewCell: cell, noOfSelectedElement: indexPath.row)
        return cell
        }
        return UICollectionViewCell()
    }
    
}


extension CategoryVc: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var size = 0
        if UIDevice.current.orientation.isLandscape {
            size = Int((collectionView.frame.width/3)-1)
        } else {
            size = Int((collectionView.frame.width/2)-1)
        }
        
        return CGSize(width: size, height: size)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    
    
}
