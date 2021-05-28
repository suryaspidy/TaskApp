//
//  CategoryVc.swift
//  TaskApp
//
//  Created by surya-zstk231 on 17/05/21.
//

import UIKit
import CoreData

class CategoryVc: UIViewController, UICollectionViewDelegate{
    
    
    @IBOutlet weak var categoryNavNewAddBtn: UIBarButtonItem!
    @IBOutlet weak var categoryNavThemeBtn: UIBarButtonItem!
    var categoryData = [Categories]()
    var noOfSelectedPosition = 0
    var intForAddDummyCell = 0
    let label = UILabel()
    var activeTheme = UserDefaults.standard.string(forKey: "currentTheme")
    var theme:Theme? = nil
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        colourHandler()
        title = NSLocalizedString("GROUP_PAGE_TITLE", comment: "Category page title")
        print(Constants.dataFilePath)
        categoryData = DBHandler.loadCategoryItems()
        collectionView.register(UINib(nibName: Constants.groupCellNibName, bundle: nil), forCellWithReuseIdentifier: Constants.groupCellIdendifier)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
  
    }
    
    func colourHandler(){
        
        activeTheme = UserDefaults.standard.string(forKey: "currentTheme")
        print(activeTheme!)
        if activeTheme == "White" {
            theme = Theme.light
        } else{
            theme = Theme.dark
        }
        
        collectionView.backgroundColor = theme?.backgroundColour
        view.backgroundColor = theme?.backgroundColour
        
        categoryNavNewAddBtn.tintColor = theme?.textColour
        categoryNavThemeBtn.tintColor = theme?.textColour
        categoryNavThemeBtn.title = activeTheme
        
    }
    
    func dummyLabelAdd(){
        label.frame = CGRect(x: (view.frame.width/2)-100, y: (view.frame.height/2)-20, width: 200, height: 40)
        label.text = "Your category is empty"
        label.textAlignment = .center
        view.addSubview(label)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        noOfSelectedPosition = indexPath.row
        performSegue(withIdentifier: Constants.goToTaskPage, sender: self)
       
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == Constants.goToTaskPage{
            let destinationVc = segue.destination as! TaskVc
            destinationVc.categoryType = categoryData[noOfSelectedPosition]
            destinationVc.theme = theme
            destinationVc.ifTaskAddOrDelete = {[self] input in
                categoryData = DBHandler.loadCategoryItems()
                collectionView.reloadData()
            }
        }
        else if segue.identifier == Constants.addCategorySequeID{
            let destinationVc = segue.destination as! AddNewItem
            destinationVc.typeOfAddedElement = AddType.Category
            destinationVc.theme = theme
            destinationVc.isNewCatergoryUpdated = { [self] input in
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
    
    @IBAction func themeBtnPressed(_ sender: UIBarButtonItem) {
        if UserDefaults.standard.string(forKey: "currentTheme") == "White"{
            UserDefaults.standard.set("Black", forKey: "currentTheme")
        }else {
            UserDefaults.standard.set("White", forKey: "currentTheme")
        }
        
        colourHandler()
        
        collectionView.reloadData()
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
                cell.tag = 0
                cell.collectionViewCellColourHander(theme: theme!)
                addGestureForUpdate(viewCell: cell, noOfSelectedElement: indexPath.row)
                intForAddDummyCell = 1
                return cell
            }else if intForAddDummyCell == 1 {
                let cellDummy = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.groupCellIdendifier, for: indexPath) as! GroupViewCell
                cellDummy.isUserInteractionEnabled = false
                cellDummy.forDummyCell(theme: theme!)
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
        cell.collectionViewCellColourHander(theme: theme!)
        cell.isUserInteractionEnabled = true
        cell.tag = indexPath.row
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
