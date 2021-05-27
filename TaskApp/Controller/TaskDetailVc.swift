//
//  TaskDetailVc.swift
//  TaskApp
//
//  Created by surya-zstk231 on 19/05/21.
//

import UIKit

class TaskDetailVc: UIViewController {

    @IBOutlet weak var categoryTextArea: UILabel!
    @IBOutlet weak var taskTextArea: UILabel!
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var bottomView: UIView!
    var categoryName: String?
    var taskName: String?
    var elementPosition: Int?
    var taskDatas = [Tasks]()
    var theme:Theme? = nil
    
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var finishBtn: UIButton!
    @IBOutlet weak var mainView: UIView!
    
    var isTaskChangeFinised: ((_ isChanged: Bool) ->Void)?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addBackGroundViewGesture()
        taskDetailColourHandler()

        categoryTextArea.text = categoryName
        taskTextArea.text = taskName
        backBtn.setTitle(NSLocalizedString("DETAIL_GO_BACK_BTN", comment: "Cancel for detail operation"), for: .normal)
        finishBtn.setTitle(NSLocalizedString("ADD_DETAIL_BTN", comment: "Done for task add to finish"), for: .normal)
    }
    
    func taskDetailColourHandler(){
        backBtn.backgroundColor = theme?.textColour
        backBtn.setTitleColor(theme?.backgroundColour, for: .normal)
        backBtn.layer.cornerRadius = backBtn.frame.height/2
        
        finishBtn.backgroundColor = theme?.textColour
        finishBtn.setTitleColor(theme?.backgroundColour, for: .normal)
        finishBtn.layer.cornerRadius = finishBtn.frame.height/2
        
        mainView.backgroundColor = theme?.backgroundColour
        mainView.layer.borderWidth = 2
        mainView.layer.borderColor = theme?.textColour.cgColor
        mainView.layer.cornerRadius = mainView.frame.height/8
        
        categoryTextArea.textColor = theme?.textColour
        categoryTextArea.backgroundColor = theme?.backgroundColour
        
        taskTextArea.textColor = theme?.textColour
        taskTextArea.backgroundColor = theme?.backgroundColour
    }
    
    func addBackGroundViewGesture(){
        let tapGesture1 = UITapGestureRecognizer(target: self, action: #selector(backgroundTapped))
        let tapGesture2 = UITapGestureRecognizer(target: self, action: #selector(backgroundTapped))
        
        bottomView.addGestureRecognizer(tapGesture1)
        topView.addGestureRecognizer(tapGesture2)
    }
    
    @objc func backgroundTapped(){
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func backBtnPresed(_ sender: UIButton) {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func finishTaskBtnPressed(_ sender: UIButton) {
        let alert = UIAlertController(title: NSLocalizedString("CONFIRM_FINISH_TASK_ALERT_TITLE", comment: "Finish task alert title"), message: NSLocalizedString("CONFIRM_FINISH_TASK_ALERT_MESSAGE", comment: "Finish task alert message"), preferredStyle: .actionSheet)
        let action1 = UIAlertAction(title: NSLocalizedString("CONFIRM_FINISH_ALERT_FINISH_DONE_BTN", comment: "Finish done button"), style: .default) { [self] (action) in
            DBHandler.finishTask(indexPathVal: elementPosition!, arr: taskDatas)
            isTaskChangeFinised?(true)
            presentingViewController?.dismiss(animated: true, completion: nil)
        }
        let action2 = UIAlertAction(title: NSLocalizedString("CONFIRM_FINISH_ALERT_CANCEL_BTN", comment: "Cancel finish alert button"), style: .cancel, handler: nil)
        
        alert.addAction(action1)
        alert.addAction(action2)
        
        present(alert, animated: true, completion: nil)
    }
    
}
