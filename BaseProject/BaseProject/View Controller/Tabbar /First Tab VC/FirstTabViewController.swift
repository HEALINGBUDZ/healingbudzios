//
//  FirstTabViewController.swift
//  BaseProject
//
//  Created by macbook on 15/07/2017.
//  Copyright © 2017 Wave. All rights reserved.
//

import UIKit

class FirstTabViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.isNavigationBarHidden = true;
        self.tabBarController?.tabBar.isHidden = false
        
        _ = self.navigationController?.popToRootViewController(animated: true)
        
    }
    
}
