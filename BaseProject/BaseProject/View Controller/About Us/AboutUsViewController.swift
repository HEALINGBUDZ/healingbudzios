//
//  AboutUsViewController.swift
//  BaseProject
//
//  Created by Vengile on 15/06/2017.
//  Copyright © 2017 Wave. All rights reserved.
//

import UIKit

class AboutUsViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

	override func viewWillAppear(_ animated: Bool) {
		
		self.navigationController?.isNavigationBarHidden = false;
		self.UpdateTitle(title: "About Us")
		
		self.AddMenuButton();
	}
    
}
