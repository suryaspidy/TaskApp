//
//  DBHandler.swift
//  TaskApp
//
//  Created by surya-zstk231 on 17/05/21.
//

import UIKit
import CoreData

struct DBHandler {
    
    static func saveItems(){
        do {
            try Constants.context.save()
            print("Save succesfuly")
        } catch {
            print("Error in saveItem func \(error)")
        }
    }
    
    static func loadTaskItems(specificCategory: String) -> [Tasks]{
        let request: NSFetchRequest<Tasks> = Tasks.fetchRequest()
        let predicateQurry = NSPredicate(format:"parentCategory.categoryName MATCHES %@", specificCategory as CVarArg)

        request.predicate = predicateQurry
        do{
            let arrOfTasks = try Constants.context.fetch(request)
            return(arrOfTasks)
        }catch{
            print("Error in loadItem func \(error)")
            return []
        }
    }
    
    static func loadCategoryItems() -> [Categories]{
        let request: NSFetchRequest<Categories> = Categories.fetchRequest()

        do{
            let categoryData = try Constants.context.fetch(request)
            return categoryData
        }catch{
            print("Error in loadItem func \(error)")
            return []
        }
    }
}
