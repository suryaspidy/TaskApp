//
//  GroupViewCell.swift
//  TaskApp
//
//  Created by surya-zstk231 on 17/05/21.
//

import UIKit

class GroupViewCell: UICollectionViewCell {

    @IBOutlet weak var parentView: UIView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var categoryNameArea: UILabel!
    @IBOutlet weak var taskCount: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        mainView.layer.cornerRadius = 20
    }
    
    func collectionViewCellColourHander(theme: Theme){
        parentView.backgroundColor = theme.shadowColour
        
        mainView.backgroundColor = theme.backgroundColour
        
        categoryNameArea.backgroundColor = theme.backgroundColour
        categoryNameArea.textColor = theme.textColour
        
        taskCount.backgroundColor = theme.backgroundColour
        taskCount.textColor = theme.textColour
    }
    
    func forDummyCell(theme: Theme){
        parentView.backgroundColor = theme.shadowColour
        mainView.backgroundColor = theme.shadowColour
        taskCount.textColor = theme.shadowColour
        categoryNameArea.textColor = theme.shadowColour
        
        taskCount.backgroundColor = theme.shadowColour
        categoryNameArea.backgroundColor = theme.shadowColour
    }

    
}
