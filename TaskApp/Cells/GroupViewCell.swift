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
        parentView.layer.borderColor = UIColor.red.cgColor
        parentView.layer.borderWidth = 1
        parentView.backgroundColor = theme.shadowColour
        
        mainView.backgroundColor = theme.backgroundColour
        
        categoryNameArea.backgroundColor = theme.backgroundColour
        categoryNameArea.textColor = theme.textColour
        
        taskCount.backgroundColor = theme.backgroundColour
        taskCount.textColor = theme.textColour
    }
    
    func forDummyCell(theme: Theme){
        parentView.backgroundColor = theme.shadowColour
        mainView.backgroundColor = theme.backgroundColour
        parentView.layer.borderColor = theme.backgroundColour.cgColor
        taskCount.textColor = theme.backgroundColour
        categoryNameArea.textColor = theme.backgroundColour
        
        taskCount.backgroundColor = theme.backgroundColour
        categoryNameArea.backgroundColor = theme.backgroundColour
    }

    
}
