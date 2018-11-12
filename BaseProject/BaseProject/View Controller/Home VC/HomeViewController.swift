//
//  HomeViewController.swift
//  BaseProject
//
//  Created by macbook on 29/08/2017.
//  Copyright © 2017 Wave. All rights reserved.
//

import UIKit
import MapKit

class HomeViewController: BaseViewController ,CLLocationManagerDelegate {

    @IBOutlet weak var Lbl_budz_feed_count: UILabel!
    @IBOutlet weak var Lbl_shout_out_count: UILabel!
    @IBOutlet weak var View_budzfeed_notification_badge: CircleView!
    @IBOutlet weak var View_shout_out_notification_badge: CircleView!
    var MainViewSearch = UIViewController()
    let locationManager = CLLocationManager()
    
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
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        }
        
        self.RefreshData {
            // Update UI
            self.UpdateUI(user: DataManager.sharedInstance.getPermanentlySavedUser()!)
        }
    }
    
    func UpdateUI(user : User) {
        if user.shout_outs_count.intValue == 0{
            self.View_shout_out_notification_badge.isHidden = true
        }else{
            self.View_shout_out_notification_badge.isHidden = false
            self.Lbl_shout_out_count.text = "\(user.shout_outs_count.intValue)"
        }
        
        if user.notifications_count.intValue == 0{
            self.View_budzfeed_notification_badge.isHidden = true
        }else{
            self.View_budzfeed_notification_badge.isHidden = false
            self.Lbl_budz_feed_count.text = "\(user.notifications_count.intValue)"
        }
    }
    
    
    @IBAction func ShowMenu(sender : UIButton){
        self.menuContainerViewController.setMenuState(MFSideMenuStateLeftMenuOpen, completion: nil)
        
    }
    @IBAction func ShowShoutOut_Action(sender : UIButton){
        self.PushViewWithStoryBoard(nameViewController: "ShoutOutListVC", nameStoryBoard: "ShoutOut")
    }

    
    @IBAction func ShowBudzFeed(sender : UIButton){
        
       let mainView =  self.GetView(nameViewController: "MainBudzFeedViewController", nameStoryBoard: "BudzStoryBoard")
        
        self.navigationController?.pushViewController(mainView, animated: true)
    }
    
    @IBAction func ShowSearchUpper(sender : UIButton){
        self.MainViewSearch = self.GetView(nameViewController: "QAMainSearchViewController", nameStoryBoard: "QAStoryBoard")
        self.navigationController?.pushViewController(self.MainViewSearch, animated: true)
        
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        DataManager.sharedInstance.user?.userCurrentlat = String(describing: locations.last!.coordinate.latitude)
        DataManager.sharedInstance.user?.userCurrentlng = String(describing: locations.last!.coordinate.longitude)
        DataManager.sharedInstance.saveUserPermanentally()
        self.locationManager.stopUpdatingLocation() 
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error \(error)")
    }
    
}
