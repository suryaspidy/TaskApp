//
//  TaskViewCell.swift
//  TaskApp
//
//  Created by surya-zstk231 on 17/05/21.
//

import UIKit

class TaskViewCell: UITableViewCell {

    @IBOutlet weak var parentView: UIView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var taskNameArea: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        mainView.layer.cornerRadius = 20
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func tableViewCellColurHandler(theme: Theme){
        parentView.backgroundColor = theme.shadowColour
        mainView.backgroundColor = theme.backgroundColour
        
        taskNameArea.backgroundColor = theme.backgroundColour
        taskNameArea.textColor = theme.textColour
    }
    
}
