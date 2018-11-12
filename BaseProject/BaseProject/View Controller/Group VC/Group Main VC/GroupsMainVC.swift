//
//  GroupsVC.swift
//  BaseProject
//
//  Created by Vengile on 16/06/2017.
//  Copyright © 2017 Wave. All rights reserved.
//

import UIKit


class GroupsMainVC: BaseViewController {
    
    
    
    
    
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
        self.UpdateTitle(title: "Main Collections")
        self.tabBarController?.tabBar.isHidden = false
        
        self.AddMenuButton();
    }

    
    @IBAction func ShowMenu(sender : UIButton){
        self.menuContainerViewController.setMenuState(MFSideMenuStateLeftMenuOpen, completion: nil)
        
    }

    
}

