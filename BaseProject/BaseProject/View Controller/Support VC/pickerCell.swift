//
//  pickerCell.swift
//  BaseProject
//
//  Created by MAC MINI on 23/10/2017.
//  Copyright © 2017 Wave. All rights reserved.
//

import UIKit

class pickerCell: UITableViewCell,UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet weak var textField_Picker: UITextField!
    
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        let pickerView = UIPickerView()
        pickerView.delegate = self
        //textField_Picker.textColor = UIColor.white
        textField_Picker.inputView = pickerView
        
        
        if DataManager.sharedInstance.supportOptionsArray.count > 0 {
            let  objUser =  DataManager.sharedInstance.supportOptionsArray[0] as SubUser
            self.textField_Picker.text = objUser.title
            DataManager.sharedInstance.supportSubID = objUser.id
            
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return DataManager.sharedInstance.supportOptionsArray.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
      
        let  objUser =  DataManager.sharedInstance.supportOptionsArray[row] as SubUser
        return objUser.title
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
      
        let  objUser =  DataManager.sharedInstance.supportOptionsArray[row] as SubUser
        
        textField_Picker.text = objUser.title
        
        DataManager.sharedInstance.supportSubID = objUser.id
        
        textField_Picker.textColor = UIColor.darkGray
    }
   
    

    
}
