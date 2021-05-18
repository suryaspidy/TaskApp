//
//  CategoryVc.swift
//  TaskApp
//
//  Created by surya-zstk231 on 17/05/21.
//

import UIKit
import CoreData

class CategoryVc: UIViewController, UICollectionViewDelegate {
    
    let context = Constants.context
    
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
        }
    }
    
    
    
    @IBAction func addCategoryBtnPressed(_ sender: UIBarButtonItem) {
        
        performSegue(withIdentifier: Constants.addCategorySequeID, sender: self)
    }
    
    
    
}

extension CategoryVc: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let noOfCategories = categoryData.count
        return noOfCategories
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.groupCellIdendifier, for: indexPath) as! GroupViewCell
        let name = "\(String(describing: categoryData[indexPath.row].categoryName!))"
        let noOfTasks = DBHandler.loadTaskItems(specificCategory: categoryData[indexPath.row].categoryName!)
        cell.categoryNameArea.text = name
        cell.taskCount.text = "\(noOfTasks.count)"
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

