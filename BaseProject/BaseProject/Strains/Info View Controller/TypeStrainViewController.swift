//
//  TypeStrainViewController.swift
//  BaseProject
//
//  Created by macbook on 31/10/2017.
//  Copyright © 2017 Wave. All rights reserved.
//

import UIKit
import  KUIPopOver



class TypeStrainViewController: BaseViewController , KUIPopOverUsable {

    @IBOutlet weak var infoLabel: UILabel!
    var text: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        self.infoLabel.text = text
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var contentSize: CGSize {
        if self.text.contains("Hybrid") && self.text.contains("Indica") && self.text.contains("Indica"){
            
            return CGSize(width: UIScreen.main.bounds.size.width - 20, height: 140.0)
        }else if self.text.contains("Sativa") {
            
            return CGSize(width: UIScreen.main.bounds.size.width - 20, height: 240.0)
        }else if self.text.contains("Vote"){
            return CGSize(width: UIScreen.main.bounds.size.width - 20, height: 150.0)
        }else if self.text.contains("Indica"){
            
            return CGSize(width: UIScreen.main.bounds.size.width - 20, height: 240.0)
        }else if self.text.contains("laboratory"){
            
            return CGSize(width: UIScreen.main.bounds.size.width - 70, height: 80.0)
        }else{
            return CGSize(width: UIScreen.main.bounds.size.width - 20, height: 240.0)
        }
    }
    
    var popOverBackgroundColor: UIColor?{
        return  UIColor.init(hex: "FFFFFF")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    
    
    @IBAction func DismissInfo(sender : UIButton){
        self.dismiss(animated: true) { 
            
        }
    }

   
}
