//
//  EditAnswerViewController.swift
//  BaseProject
//
//  Created by macbook on 29/11/2017.
//  Copyright © 2017 Wave. All rights reserved.
//

import UIKit
import ActiveLabel

class EditAnswerViewController: BaseViewController {
    
    // Textview
    @IBOutlet var lbl_Answer_Count : UILabel!
    @IBOutlet var txtView_Answer : UITextView!
    let constantCountString = "/2500 characters"
    
    @IBOutlet var lbl_Question : ActiveLabel!
    
    
    var arrayDummyText = ["aaa", "ddd"]
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.lbl_Answer_Count.text = "0" + constantCountString
        
        let customType = ActiveType.custom(pattern: "\\scannabis oil\\b")
        
        lbl_Question.customColor[customType] = Constants.kTagColor
        lbl_Question.enabledTypes = [customType]
        
        self.lbl_Question.text = "I'm using cannabis oil for muscle pain therapy and i'm unsure if I should warm if before rubbing it on the affected areas."
        //  self.ShowImageView()
    }
    
}

//MARK:
//MARK: Text View
extension EditAnswerViewController : UITextViewDelegate{
    
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return true
    }
    
    @IBAction func GoBack(sender : UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func UpdateAnswer(sender : UIButton){
        self.navigationController?.popViewController(animated: true)
    }
}



