//
//  CompleteProfileVC.swift
//  BaseProject
//

//  Copyright © 2018 Wave. All rights reserved.
//

import UIKit

class CompleteProfileVC: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func get_free_budz_map(_ sender: Any) {

        let move = self.GetView(nameViewController: "NewBudzMapViewController", nameStoryBoard: "Main") as! NewBudzMapViewController
        move.afterCompleting = 1
        self.navigationController?.pushViewController(move, animated: true)
    }
    
    @IBAction func view_reward_section(_ sender: Any) {
        
        let rewards_vc = self.GetView(nameViewController: "MyRewardsVC", nameStoryBoard: "Rewards") as! MyRewardsVC
        rewards_vc.afterCompleting = 1
        self.navigationController?.pushViewController(rewards_vc, animated: true)
    }
    @IBAction func view_my_profile(_ sender: Any) {
        self.afterCompletionBase = 1
        self.OpenProfileVC(id: (DataManager.sharedInstance.getPermanentlySavedUser()?.ID)!)
    }
    @IBAction func Remember_Me(_ sender: Any) {
        self.ShowMenuBaseView()
    }
}
