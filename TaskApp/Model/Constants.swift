//
//  Constants.swift
//  TaskApp
//
//  Created by surya-zstk231 on 17/05/21.
//

import UIKit

struct Constants{
    static let groupCellNibName = "GroupViewCell"
    static let groupCellIdendifier = "GroupCellID"
    static let addCategorySequeID = "addCategory"
    static let addCategoryStoryBoardId = "addCategory"
    
    static let goToTaskPage = "categoryItemTapped"
    static let goToFinishedTasksPage = "finishedTasks"
    static let taskSelected = "tableViewTapped"
    
    static let taskCellNibName = "TaskViewCell"
    static let taskCellIdentifier = "TaskCellID"
    static let addTaskSequeID = "addTask"
    
    static let newCategoryAdded = "newCategoryVcToCategoryVc"
    
    static let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    static let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
}


struct Theme {
    let textColour: UIColor
    let backgroundColour: UIColor
    
    static let light = Theme(textColour: .black, backgroundColour: .white)
    static let dark = Theme(textColour: .white, backgroundColour: .black)
}
