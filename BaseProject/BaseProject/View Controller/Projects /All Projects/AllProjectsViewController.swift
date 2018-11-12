//
//  AllProjectsViewController.swift
//  BaseProject
//
//  Created by Vengile on 20/06/2017.
//  Copyright © 2017 Wave. All rights reserved.
//

import UIKit

class AllProjectsViewController: BaseViewController {

	
    
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
		self.UpdateTitle(title: "")
		self.AddMenuButton();
        
	}

}
