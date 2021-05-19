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
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
            destinationVc.delegate = self
        }
        else if segue.identifier == Constants.addCategorySequeID{
            let destinationVc = segue.destination as! AddNewCategoryVc
            destinationVc.delegate = self
        }
    }
    
    
    
    @IBAction func addCategoryBtnPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: Constants.addCategorySequeID, sender: self)
        
//        let vc = storyboard?.instantiateViewController(identifier: Constants.addCategoryStoryBoardId) as! AddNewCategoryVc
//        vc.delegate = self
//        navigationController?.pushViewController(vc, animated: true)
        
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
        let action1 = UIAlertAction(title: "Edit", style: .destructive) {[self] (action) in
            
            var textFieldAreaForUpdate = UITextField()
            
            let confirmEditAlert = UIAlertController(title: "Edit", message: "Please Change the text", preferredStyle: .alert)
            let confirmEditAction = UIAlertAction(title: "Edit", style: .destructive) { (action) in
                if textFieldAreaForUpdate.text?.isEmpty == true{
                    let emptyValAlert = UIAlertController(title: "Please Enter Correct Values", message: "", preferredStyle: .alert)
                    let emptyValAction = UIAlertAction(title: "Go back", style: .default) { (action) in
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
            let confirmEditCancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
            
            confirmEditAlert.addAction(confirmEditAction)
            confirmEditAlert.addAction(confirmEditCancelAction)
            
            confirmEditAlert.addTextField { (textField) in
                textField.text = categoryData[elementPosition].categoryName
                textFieldAreaForUpdate = textField
                
            }
            
            present(confirmEditAlert, animated: true, completion: nil)
            
        }

        //MARK:- Delete Actions
        let action2 = UIAlertAction(title: "Delete", style: .destructive) { [self] (code) in
            let confirmDeleteAlert = UIAlertController(title: "Confirm", message: "Once you delete the category you did not get again", preferredStyle: .alert)
            let confirmDeleteAction = UIAlertAction(title: "Delete", style: .default) { (action) in
                DBHandler.deleteCategoryItem(indexPathVal: elementPosition, arr: categoryData)
                categoryData = DBHandler.loadCategoryItems()
                collectionView.reloadData()
            }
            let confirmDeleteCancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            
            confirmDeleteAlert.addAction(confirmDeleteAction)
            confirmDeleteAlert.addAction(confirmDeleteCancelAction)
            
            present(confirmDeleteAlert, animated: true, completion: nil)
        }
        
        
        
        let action3 = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(action1)
        alert.addAction(action2)
        alert.addAction(action3)

        present(alert, animated: true, completion: nil)
    }
    
    
}

extension CategoryVc: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let noOfCategories = categoryData.count
        return noOfCategories
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.groupCellIdendifier, for: indexPath) as! GroupViewCell
        let name = String(describing: categoryData[indexPath.row].categoryName!)
        let noOfTasks = DBHandler.loadTaskItems(specificCategory: categoryData[indexPath.row].categoryName!)
        cell.categoryNameArea.text = name
        cell.taskCount.text = "\(noOfTasks.count)"
        cell.tag = indexPath.row
        cell.mainView.tag = indexPath.row
        addGestureForUpdate(viewCell: cell, noOfSelectedElement: indexPath.row)
        return cell
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


extension CategoryVc: NewCategoryAdded{
    func isCategoryListUpdated(isUpdate: Bool) {
        if isUpdate{
            categoryData = DBHandler.loadCategoryItems()
            collectionView.reloadData()
        }
    }
    
    
    
}

extension CategoryVc: CountOfTaskChanged{
    func isTaskListUpdated(isUpdate: Bool) {
        if isUpdate{
            categoryData = DBHandler.loadCategoryItems()
            collectionView.reloadData()
        }
    }
    
}
