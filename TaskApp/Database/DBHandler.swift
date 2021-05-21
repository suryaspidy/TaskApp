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
        let predicateQurry = NSPredicate(format:"isFinish == false && parentCategory.categoryName MATCHES %@", specificCategory as CVarArg)
        //let predicateQurry2 = NSPredicate(format: "isFinish == %d", false)

        request.predicate = predicateQurry
        //request.predicate = predicateQurry2
        do{
            let arrOfTasks = try Constants.context.fetch(request)
            return(arrOfTasks)
        }catch{
            print("Error in loadItem func \(error)")
            return []
        }
    }
    
    static func finishedTaskItems(specificCategory: String) -> [Tasks]{
        let request: NSFetchRequest<Tasks> = Tasks.fetchRequest()
        let predicateQurry = NSPredicate(format:"isFinish == true && parentCategory.categoryName MATCHES %@", specificCategory as CVarArg)
//        let predicateQurry2 = NSPredicate(format: "isFinish == %d", true)

        request.predicate = predicateQurry
//        request.predicate = predicateQurry2
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
    
    
    static func deleteCategoryItem(indexPathVal: Int, arr: [Categories]){
        Constants.context.delete(arr[indexPathVal])
        self.saveItems()
    }
    
    static func updateCategoryItem(categoryName: String,indexPathVal: Int, arr: [Categories]){
        arr[indexPathVal].categoryName = categoryName
        self.saveItems()
    }
    
    static func deleteTaskItems(indexPathVal: Int, arr: [Tasks]){
        Constants.context.delete(arr[indexPathVal])
        self.saveItems()
    }
    
    static func updateTaskItems(taskName: String,indexPathVal: Int, arr: [Tasks]){
        arr[indexPathVal].taskName = taskName
        self.saveItems()
    }
    
    static func finishTask(indexPathVal: Int, arr: [Tasks]){
        arr[indexPathVal].isFinish = true
        self.saveItems()
    }
    
    static func filterUnfinishedTask(str: String,categoryName: String) -> [Tasks]{
        let request: NSFetchRequest<Tasks> = Tasks.fetchRequest()
        let condition1 = NSPredicate(format: "isFinish == false &&taskName CONTAINS[cd] %@", str)
        let condition2 = NSPredicate(format: "parentCategory.categoryName MATCHES %@", categoryName)
        let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [condition1,condition2])
        request.predicate = predicate
        
        do{
            let arr = try Constants.context.fetch(request)
            return arr
        } catch{
            print(error)
        }
        return []
    }
    
    static func filterFinishedTask(str: String,categoryName: String) -> [Tasks]{
        let request: NSFetchRequest<Tasks> = Tasks.fetchRequest()
        let condition1 = NSPredicate(format: "isFinish == true &&taskName CONTAINS[cd] %@", str)
        let condition2 = NSPredicate(format: "parentCategory.categoryName MATCHES %@", categoryName)
        let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [condition1,condition2])
        request.predicate = predicate
        
        do{
            let arr = try Constants.context.fetch(request)
            return arr
        } catch{
            print(error)
        }
        return []
    }
}
