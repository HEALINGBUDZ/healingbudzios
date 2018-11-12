//
//  ViewController.swift
//  BaseProject
//
//  Created by Vengile on 14/06/2017.
//  Copyright © 2017 Wave. All rights reserved.
//

import UIKit
import Darwin
import CoreLocation

class ViewController: BaseViewController , CLLocationManagerDelegate  {

    var locationManager: CLLocationManager!
	@IBOutlet var TF_Name		: UITextField!
	@IBOutlet var TF_Password : UITextField!
	
	override func viewDidLoad() {
		super.viewDidLoad()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if (appDelegate.keywords.count == 0 ){
            self.GetKeywords(completion: {
                print(appDelegate.keywords)
            })
        }
        NotificationCenter.default.addObserver(self, selector: #selector(self.getNotificationCount), name: NSNotification.Name(rawValue: "NewNotification"), object: nil)
        self.locationManager = CLLocationManager()
        locationManager.requestAlwaysAuthorization()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startMonitoringSignificantLocationChanges()
        locationManager.startUpdatingLocation()
	}
    
    func getNotificationCount(){
        print("Called Notify")
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        DataManager.sharedInstance.setLocation(loaciton: locValue)
    }

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}

	override func viewWillAppear(_ animated: Bool) {
		self.navigationController?.isNavigationBarHidden = true
	}


	@IBAction func LoginAction(sender : UIButton){
        self.PushViewWithIdentifier(name: "EmailLoginViewController")
	}
    
    @IBAction func OnClickExit(_ sender: Any) {
        exit(0);
    }  
}

