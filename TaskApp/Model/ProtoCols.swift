//
//  ProtoCols.swift
//  TaskApp
//
//  Created by surya-zstk231 on 19/05/21.
//

import Foundation

protocol CountOfTaskChanged{
    func isTaskListUpdated(isUpdate: Bool)
}

protocol NewCategoryAdded {
    func isCategoryListUpdated(isUpdate: Bool)
}

protocol NewTaskAdded {
    func isTaskListUpdated(isUpdate: Bool)
}
