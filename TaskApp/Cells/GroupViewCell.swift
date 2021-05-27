//
//  GroupViewCell.swift
//  TaskApp
//
//  Created by surya-zstk231 on 17/05/21.
//

import UIKit

class GroupViewCell: UICollectionViewCell {

    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var categoryNameArea: UILabel!
    @IBOutlet weak var taskCount: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        mainView.layer.cornerRadius = 20
    }
    

    
}
