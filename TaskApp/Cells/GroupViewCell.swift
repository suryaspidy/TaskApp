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
        // Initialization code
        mainView.layer.cornerRadius = 20
//        mainView.layer.shadowColor = UIColor.green.cgColor
//        mainView.layer.shadowOpacity = 1
//        mainView.layer.shadowOffset = .zero
//        mainView.layer.shadowRadius = 20
    }

}
