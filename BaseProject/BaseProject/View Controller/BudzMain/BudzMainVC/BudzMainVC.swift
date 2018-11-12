//
//  BudzMainVC.swift
//  BaseProject
//
//  Created by MAC MINI on 02/10/2017.
//  Copyright © 2017 Wave. All rights reserved.
//

import UIKit
import MapKit
import Stripe


class BudzMainVC: BaseViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var switch_distance: UISwitch!
    @IBOutlet weak var tableView_Budz   : UITableView!
    @IBOutlet weak var tableView_Filter : UITableView!
    
    @IBOutlet weak var serch_btn: UIButton!
    @IBOutlet weak var budz_add_new: UIImageView!
    @IBOutlet weak var share_img: UIImageView!
    @IBOutlet weak var search_img: UIImageView!
    @IBOutlet weak var FilterTopValue: NSLayoutConstraint!
    
    @IBOutlet weak var mapView_Budz: MKMapView!
        
    @IBOutlet var view_New_Popup : UIView!
    @IBOutlet var view_New_Pruchase_Popup : UIView!
    
    @IBOutlet var view_Search : UIView!
    @IBOutlet var txtField_Search : UITextField!
    
    var refreshControl: UIRefreshControl!
    
    var array_filter = [[String : String]]()
    
    var array_Budz = [BudzMap]()

    var filterValue = ""
    
    var tagSearch = ""
    
    var isKeyWordSearch:Bool = false
    var searchedValue = ""
    
    fileprivate var shouldLoadMore = true
    var pageNumber = 0
    var isFilterOpen = false
    override func viewDidLoad() {
        super.viewDidLoad()
        self.RegisterXib()
        self.switch_distance.transform = CGAffineTransform(scaleX: 0.80, y: 0.75)
        share_img.image = #imageLiteral(resourceName: "shareWhite").withRenderingMode(.alwaysTemplate)
        share_img.tintColor = UIColor.init(hex: "932a88")
        
        search_img.image = #imageLiteral(resourceName: "SearchWhite").withRenderingMode(.alwaysTemplate)
        search_img.tintColor = UIColor.init(hex: "932a88")
        
        
        budz_add_new.image = #imageLiteral(resourceName: "add_new_bdz_tomy").withRenderingMode(.alwaysTemplate)
        budz_add_new.tintColor = UIColor.init(hex: "932a88")
        
        serch_btn.setImage(#imageLiteral(resourceName: "SearchWhite").withRenderingMode(.alwaysTemplate), for: .normal)
        serch_btn.tintColor = UIColor.init(hex: "932a88")
        
        
        mapView_Budz.delegate = self
        mapView_Budz.isExclusiveTouch = false
        self.view_Search.isHidden = true
        switch_distance.addTarget(self, action: #selector(switchChanged), for: UIControlEvents.valueChanged)
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(self.RefreshAPICall) , for: UIControlEvents.valueChanged)
        self.tableView_Budz.addSubview(refreshControl)
        self.ReloadArray()
         self.GetBudMap(page: 0)
        // Do any additional setup after loading the view.
        let topSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
        topSwipe.direction = .up
        view.addGestureRecognizer(topSwipe)
    }
    
    @objc func handleSwipes(_ sender:UISwipeGestureRecognizer) {
        if (sender.direction == .up) {
            if isFilterOpen{
                isFilterOpen = false
                self.hideFilter()
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.enableMenu()
        self.tabBarController?.tabBar.isHidden = false
       self.view_New_Popup.isHidden = true
        self.txtField_Search.text = ""
       self.view_New_Pruchase_Popup.isHidden = true
        self.view_Search.isHidden = true
        if self.appdelegate.isShownPremioumpopup{
            self.appdelegate.isShownPremioumpopup  = false
            if DataManager.sharedInstance.user?.showBudzPopup == 1{
                let next = self.GetView(nameViewController: "PaymentPopupViewController", nameStoryBoard: "BudzStoryBoard") as! PaymentPopupViewController
//                self.navigationController?.pushViewController(next, animated: true)
            }
        }else{
             self.hideLoading()
        }
    }
    
    
    func RefreshAPICall(sender:AnyObject){
         self.playSound(named: "refresh")
        refreshControl.endRefreshing()
        self.pageNumber = 0
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            self.GetBudMap(page: 0)
            
        })
        
    }

    
    func switchChanged(mySwitch: UISwitch) {
        GetBudMap(page: 0)
    }
    
    func GetBudMap(page : Int){
        self.showLoading()
        var urlMain = ""
        var value = false
        if self.switch_distance != nil {
            if self.switch_distance.isOn {
                value = true
            }
        }
        if value{
           urlMain =  WebServiceName.get_budz_map.rawValue + "lat=" + "\(DataManager.sharedInstance.user_locaiton?.latitude ?? 0.0)"
            urlMain = urlMain + "&lng=" + "\(DataManager.sharedInstance.user_locaiton?.longitude ?? 0.0)" + "&skip=" + String(page) + self.filterValue
        }else{
            urlMain  =     WebServiceName.get_budz_map.rawValue + "lat=" + "\(String(describing: (DataManager.sharedInstance.getPermanentlySavedUser()!.userlat)))"
            urlMain = urlMain + "&lng=" + "\(String(describing: (DataManager.sharedInstance.getPermanentlySavedUser()!.userlng)))" + "&skip=" + String(page) + self.filterValue
        }
        
        print(urlMain)
        if self.tagSearch.count > 0 {
            isKeyWordSearch = true
            searchedValue = tagSearch
            urlMain = urlMain + "&query=" + tagSearch
        }else if self.txtField_Search.text!.count > 2 {
            
            let escapedString = self.txtField_Search.text!.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
            isKeyWordSearch = true
            searchedValue = escapedString!
            urlMain = urlMain + "&query=" + escapedString!
        }else {
            isKeyWordSearch = false
            searchedValue = ""
        }
        
        NetworkManager.GetCall(UrlAPI: urlMain) { (successResponse, messageResponse, MainResponse) in
            self.hideLoading()
            print(successResponse)
            print(messageResponse)
            print(MainResponse)
            if successResponse {
                if (MainResponse["status"] as! String) == "success" {
                    let mainData = MainResponse["successData"] as! [[String : Any]]
                    if page > 0{
                    }else{
                        self.array_Budz.removeAll()
                    }
                    for indexObj in mainData {
                        self.array_Budz.append(BudzMap.init(json: indexObj as [String : AnyObject] ))
                    }
                    self.shouldLoadMore = !mainData.isEmpty
                    self.pageNumber = page

                    
                }else {
                    if (MainResponse["errorMessage"] as! String) == "Session Expired" {
                        DataManager.sharedInstance.logoutUser()
                        self.ShowLogoutAlert()
                    }
                }
            }else {
                  self.ShowErrorAlert(message:messageResponse)
            }
            self.dropPin()
            
            
            if self.array_Budz.count == 0
            {
                self.tableView_Budz.setEmptyMessage()
            }else {
                self.tableView_Budz.restore()
            }
            self.tableView_Budz.reloadData()
        }
    }
    
    func RegisterXib(){
        self.tableView_Budz.register(UINib(nibName: "BudzMainMapCell", bundle: nil), forCellReuseIdentifier: "BudzMainMapCell")
        
        self.tableView_Filter.register(UINib(nibName: "BudzFilterCell", bundle: nil), forCellReuseIdentifier: "BudzFilterCell")
        
         self.tableView_Filter.tag = -1000
        
        self.tableView_Filter.isUserInteractionEnabled = true
    
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
   
}

//MARK:
//MARK: Button Actions
//MARK:

extension BudzMainVC {
    
    @IBAction func ShowMenu(sender : UIButton){
        self.menuContainerViewController.setMenuState(MFSideMenuStateLeftMenuOpen, completion: nil)
    }
    
    @IBAction func Show_PopUp(sender : UIButton){
        self.view_New_Popup.isHidden = false
        self.tabBarController?.tabBar.isHidden = true
        self.tableView_Budz.frame.size.height = tableView_Budz.frame.height + 50.0
        
    }
    
    
    @IBAction func Hide_PopUp(sender : UIButton){
        self.view_New_Popup.isHidden = true
        self.tabBarController?.tabBar.isHidden = false
        self.tableView_Budz.frame.size.height = tableView_Budz.frame.height - 50.0
    }
    
    
    @IBAction func CreateNew_BudzMap (sender : UIButton){
        self.view_New_Popup.isHidden = true
         self.PushViewWithIdentifier(name: "NewBudzMapViewController")
    }
    
    @IBAction func ShowInApp_BudzMap (sender : UIButton){
        self.view_New_Popup.isHidden = true
//        view_New_Pruchase_Popup.isHidden = false
        let next = self.GetView(nameViewController: "PaymentPopupViewController", nameStoryBoard: "BudzStoryBoard") as! PaymentPopupViewController
        next.NotAsPopUp = true
        self.navigationController?.pushViewController(next, animated: true)
    }
    
    
    @IBAction func Hide_InApp_PopUp(sender : UIButton){
        view_New_Pruchase_Popup.isHidden = true
        self.Payment()
    }
    
    
    //MARK : Payment
    func Payment() {
        // Payment
        let addCardViewController = STPAddCardViewController()
        addCardViewController.delegate = self
        let navigationController = UINavigationController(rootViewController: addCardViewController)
        present(navigationController, animated: true)
    }
    
    func ReloadArray(){
        self.array_filter.removeAll()
        
        
        var dataDict = [String : String]()
        dataDict["image"] = "DispensaryIcon"
        dataDict["name"] = "Dispensary"
        dataDict["value"] = "0"
        
        var dataDict2 = [String : String]()
        dataDict2["image"] = "MedicalIcon"
        dataDict2["name"] = "Medical"
        dataDict2["value"] = "0"
        
        var dataDict3 = [String : String]()
        dataDict3["image"] = "CannabitesIcon"
        dataDict3["name"] = "Cannabites"
        dataDict3["value"] = "0"
        
        var dataDict4 = [String : String]()
        dataDict4["image"] = "EntertainmentIcon"
        dataDict4["name"] = "Entertainment"
        dataDict4["value"] = "0"
        
        var dataDict5 = [String : String]()
        dataDict5["image"] = "EventsIcon"
        dataDict5["name"] = "Events"
        dataDict5["value"] = "0"
        var dataDict6 = [String : String]()
        dataDict6["image"] = "OthersIcon"
        dataDict6["name"] = "Other"
        dataDict6["value"] = "0"
        self.array_filter.append(dataDict)
        self.array_filter.append(dataDict2)
        self.array_filter.append(dataDict3)
        self.array_filter.append(dataDict4)
        self.array_filter.append(dataDict5)
        self.array_filter.append(dataDict6)
        
        
        self.tableView_Filter.reloadData()
    }
    
    
    @IBAction func ShowFilterView(sender : UIButton){
        isFilterOpen = true
        UIView.animate(withDuration: 0.5, animations: {
            self.FilterTopValue.constant = 0
            self.view.layoutIfNeeded()
        })
    }
    
    func hideFilter() {
        self.filterValue = "&type="
        for  indexObj in 0..<self.array_filter.count {
            let cellIndex = self.tableView_Filter.cellForRow(at: IndexPath.init(row: indexObj, section: 0)) as! BudzFilterCell
            if cellIndex.switch_Main.isOn {
                
                if self.filterValue.count > 0 {
                    self.filterValue = self.filterValue + ","
                }
                if cellIndex.lbl_Main.text == "Dispensary" {
                    self.filterValue = self.filterValue + "1"
                }else if cellIndex.lbl_Main.text == "Medical" {
                    self.filterValue = self.filterValue + "2"
                }else if cellIndex.lbl_Main.text == "Cannabites" {
                    self.filterValue = self.filterValue + "3"
                }else if cellIndex.lbl_Main.text == "Entertainment" {
                    self.filterValue = self.filterValue + "4"
                }else if cellIndex.lbl_Main.text == "Events" {
                    self.filterValue = self.filterValue + "5"
                }else if cellIndex.lbl_Main.text == "Other" {
                    self.filterValue = self.filterValue + "9"
                }
            }
        }
        UIView.animate(withDuration: 0.5, animations: {
            self.FilterTopValue.constant = -360
            self.view.layoutIfNeeded()
            self.GetBudMap(page: 0)
        })
    }
    
    @IBAction func hideFilterView(sender : UIButton){
         self.hideFilter()
    }
}

//MARK:Stripe
extension BudzMainVC : STPAddCardViewControllerDelegate {
    func addCardViewControllerDidCancel(_ addCardViewController: STPAddCardViewController) {
        dismiss(animated: true)
    }
    
    func addCardViewController(_ addCardViewController: STPAddCardViewController, didCreateToken token: STPToken, completion: @escaping STPErrorBlock) {
        dismiss(animated: true)
        print(token)
        self.view.showLoading()
        NetworkManager.PostCall(UrlAPI:WebServiceName.add_subscription.rawValue, params: ["stripe_token" : token.tokenId as AnyObject]) { (isSuccess, StringResponse, ResponseObject) in
            self.view.hideLoading()
            print(ResponseObject)
            let new_vc = self.storyboard?.instantiateViewController(withIdentifier: "NewBudzMapViewController") as! NewBudzMapViewController
            new_vc.isSubscribed = true
            var data : [String : AnyObject] = ResponseObject["successData"] as! [String : AnyObject]
            new_vc.sub_user_id = "\(String(describing: (data["id"] as? NSNumber)!.intValue)))"
            self.navigationController?.pushViewController(new_vc, animated: false)
        }
    }
}


//MARK: TableView Delegate
//MARK:
extension BudzMainVC {
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView.tag == -1000 {
            return 40
        }
        return 100
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == -1000 {
            return self.array_filter.count
        }
        return self.array_Budz.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView.tag == -1000 {
            return self.FilterCell(tableView, cellForRowAt: indexPath)
            
        }else {
            return self.MainCell(tableView, cellForRowAt: indexPath)
        }
    }
    
  
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        
        if tableView.tag != 1000 {
//            isKeyWordSearch = false
//            searchedValue = ""
            if isKeyWordSearch {
                let viewPush = self.storyboard?.instantiateViewController(withIdentifier: "DispensaryDetailVC") as! DispensaryDetailVC
                viewPush.chooseBudzMap = self.array_Budz[indexPath.row]
                viewPush.sendValueKey = searchedValue
                self.navigationController?.pushViewController(viewPush, animated: true)
            }else {
                let viewPush = self.storyboard?.instantiateViewController(withIdentifier: "DispensaryDetailVC") as! DispensaryDetailVC
                viewPush.chooseBudzMap = self.array_Budz[indexPath.row]
                self.navigationController?.pushViewController(viewPush, animated: true)
            }
           
        }
        
    }
    
    
    func MainCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell:BudzMainMapCell = (tableView.dequeueReusableCell(withIdentifier: "BudzMainMapCell") as?
            BudzMainMapCell)!
        
        cell.lblName.text = self.array_Budz[indexPath.row].title
        cell.lblDistance.text = String(self.array_Budz[indexPath.row].distance) + " Mi"
        cell.lblreview.text = String(self.array_Budz[indexPath.row].reviews.count).FloatWholeValue() + " Reviews"
        cell.lblType.text = self.array_Budz[indexPath.row].budzMapType.title
        if self.array_Budz[indexPath.row].is_organic == "0" {
            cell.imgviewOrganic.isHidden = true
        }else {
            cell.imgviewOrganic.isHidden = false
        }
        
        if self.array_Budz[indexPath.row].is_delivery == "0" {
            cell.imgviewDelivery.isHidden = true
        }else {
            cell.imgviewDelivery.isHidden = false
        }
        
        
      
        
        cell.imgviewStar1.image = #imageLiteral(resourceName: "starUnfilled")
        cell.imgviewStar2.image = #imageLiteral(resourceName: "starUnfilled")
        cell.imgviewStar3.image = #imageLiteral(resourceName: "starUnfilled")
        cell.imgviewStar4.image = #imageLiteral(resourceName: "starUnfilled")
        cell.imgviewStar5.image = #imageLiteral(resourceName: "starUnfilled")
        if Double(self.array_Budz[indexPath.row].rating_sum)! < 1 {
            if Double(self.array_Budz[indexPath.row].rating_sum)! >= 0.1 {
                 cell.imgviewStar1.image = #imageLiteral(resourceName: "half_star")
                
            }
        }else if Double(self.array_Budz[indexPath.row].rating_sum)! < 2 {
            cell.imgviewStar1.image = #imageLiteral(resourceName: "starFilled")
            if Double(self.array_Budz[indexPath.row].rating_sum)! >= 1.1 {
                cell.imgviewStar2.image = #imageLiteral(resourceName: "half_star")
                
            }
        }else  if Double(self.array_Budz[indexPath.row].rating_sum)! < 3 {
            cell.imgviewStar1.image = #imageLiteral(resourceName: "starFilled")
            cell.imgviewStar2.image = #imageLiteral(resourceName: "starFilled")
            if Double(self.array_Budz[indexPath.row].rating_sum)! >= 2.1 {
                cell.imgviewStar3.image = #imageLiteral(resourceName: "half_star")
                
            }
        }else  if Double(self.array_Budz[indexPath.row].rating_sum)! < 4 {
            cell.imgviewStar1.image = #imageLiteral(resourceName: "starFilled")
            cell.imgviewStar2.image = #imageLiteral(resourceName: "starFilled")
            cell.imgviewStar3.image = #imageLiteral(resourceName: "starFilled")
            if Double(self.array_Budz[indexPath.row].rating_sum)! >= 3.1 {
                cell.imgviewStar4.image = #imageLiteral(resourceName: "half_star")
                
            }
        }else  if Double(self.array_Budz[indexPath.row].rating_sum)! < 5 {
            cell.imgviewStar1.image = #imageLiteral(resourceName: "starFilled")
            cell.imgviewStar2.image = #imageLiteral(resourceName: "starFilled")
            cell.imgviewStar3.image = #imageLiteral(resourceName: "starFilled")
            cell.imgviewStar4.image = #imageLiteral(resourceName: "starFilled")
            if Double(self.array_Budz[indexPath.row].rating_sum)! >= 4.1 {
                cell.imgviewStar5.image = #imageLiteral(resourceName: "half_star")
                
            }
        }else  {
            cell.imgviewStar1.image = #imageLiteral(resourceName: "starFilled")
            cell.imgviewStar2.image = #imageLiteral(resourceName: "starFilled")
            cell.imgviewStar3.image = #imageLiteral(resourceName: "starFilled")
            cell.imgviewStar4.image = #imageLiteral(resourceName: "starFilled")
               cell.imgviewStar5.image = #imageLiteral(resourceName: "starFilled")
        }
        
        switch Int(self.array_Budz[indexPath.row].business_type_id)! {
        case 1 ,2:
            cell.imgviewType.image = UIImage.init(named: BudzIcon.Dispencery.rawValue)
            break
        
        case 3:
            cell.imgviewType.image = UIImage.init(named: BudzIcon.Cannabites.rawValue)
            break
        case 4:
            cell.imgviewType.image = UIImage.init(named: BudzIcon.Entertainment.rawValue)
            break
        case 5:
            cell.imgviewType.image = UIImage.init(named: BudzIcon.Event.rawValue)
            break
        case 6:
            cell.imgviewType.image = UIImage.init(named: BudzIcon.Medical.rawValue)
            break
        case 7:
            cell.imgviewType.image = UIImage.init(named: BudzIcon.Medical.rawValue)
            break
        case 9:
            cell.imgviewType.image = UIImage.init(named: BudzIcon.Others.rawValue)
            break
        default:
            cell.imgviewType.image = UIImage.init(named: BudzIcon.Medical.rawValue)
                break
            
        }
        
        
        if self.array_Budz[indexPath.row].is_featured == 1 {
            cell.view_BG.backgroundColor = UIColor.black
            cell.view_featured.isHidden = false
            cell.view_DottedLine.isHidden = false
        }
        else{
            cell.view_BG.backgroundColor = UIColor.init(red: (35/255), green: (35/255), blue: (35/255), alpha: 1.0)
            cell.view_featured.isHidden = true
            cell.view_DottedLine.isHidden = true
        }
        
        if self.array_Budz[indexPath.row].logo != ""{
        cell.imgviewUser.moa.url = WebServiceName.images_baseurl.rawValue + self.array_Budz[indexPath.row].logo.RemoveSpace()
        }else{
            cell.imgviewUser.image =  #imageLiteral(resourceName: "leafCirclePink")
        }


        cell.imgviewType.RoundView()
        cell.imgviewUser.RoundView()
        
        cell.view_featured.roundCorners(corners: [.topLeft, .bottomLeft], radius: 10)
        cell.selectionStyle = .none
        return cell
    }

    
    
    
    func FilterCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "BudzFilterCell") as! BudzFilterCell
        
        cell.lbl_Main.text = self.array_filter[indexPath.row]["name"]
        cell.imgView_Main.image = UIImage.init(named: self.array_filter[indexPath.row]["image"]!)
        
        
        cell.selectionStyle = .none
        return cell
    }

    
}
//MARK:
//MARK: Map View
//MARK:

extension BudzMainVC: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {

        if annotation is MKUserLocation {
            return nil
        }

        let identifier = "MyPin"
        let currentAnnot:budzAnnotation = (annotation as?budzAnnotation)!

        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        annotationView?.canShowCallout = false
        annotationView = AnnotationView(annotation: annotation, reuseIdentifier: identifier)
            switch Int(currentAnnot.type!)! {
            case 1 :
                annotationView?.image = UIImage(named: "DispensaryMap")
                break

            case 3:
                annotationView?.image = UIImage(named: "CannbitesMap")
                break
            case 4:
                 annotationView?.image = UIImage(named: "ticketMap")
                break
            case 5:
                annotationView?.image = UIImage(named: "EventMap")
                break
            case 9:
                annotationView?.image = UIImage(named: "OtherPin")
                break
            default:
                annotationView?.image = UIImage(named: "MedicalMap")
                break
            }
         annotationView?.isDraggable = true
        return annotationView
    }

    
    func dropPin() {
        
        let allMapPins = self.mapView_Budz.annotations
        
        for indexObj in allMapPins{
            self.mapView_Budz.removeAnnotation(indexObj)
        }
        for indexValue in self.array_Budz {
            let newPin1 = budzAnnotation()
            let newlat = Double(indexValue.lat)!
            let newlng = Double(indexValue.lng)!
            newPin1.BudzMapData = indexValue
            let location = CLLocation(latitude: newlat, longitude: newlng)
            newPin1.type = indexValue.business_type_id
            let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            newPin1.title = indexValue.title
            mapView_Budz.setRegion(region, animated: true)
            newPin1.coordinate = location.coordinate
            mapView_Budz.addAnnotation(newPin1)
        }
    }

    func mapView(_ mapView: MKMapView,didSelect view: MKAnnotationView)
    {

        if view.annotation is MKUserLocation
        {
            return
        }
        let budzAnnotation = view.annotation as! budzAnnotation
        let views = Bundle.main.loadNibNamed("CustomCalloutView", owner: nil, options: nil)
        let calloutView = views?[0] as! CustomCalloutView
        calloutView.index = budzAnnotation.BudzMapData.id
        calloutView.onAnnotaionClck = { index in
           print("Test")
        }
        calloutView.lblType.text = budzAnnotation.BudzMapData.budzMapType.title
        calloutView.btnNewScreen.addTarget(self, action: #selector(BudzMainVC.openBudzDetail(sender:)), for: .touchUpInside)
        calloutView.btnNewScreen.isUserInteractionEnabled = true
        calloutView.btnNewScreen.becomeFirstResponder()
        calloutView.btnNewScreen.tag = budzAnnotation.BudzMapData.id
        calloutView.lblReview.text = "\(budzAnnotation.BudzMapData.reviews.count) Reviews"
        calloutView.lblName.text = budzAnnotation.BudzMapData.title
        calloutView.tag = budzAnnotation.BudzMapData.id
        calloutView.imgViewMain.moa.url = budzAnnotation.BudzMapData.logo.RemoveSpace()
        calloutView.imgViewMain.RoundView()

        calloutView.imgViewStar1.image = #imageLiteral(resourceName: "starUnfilled")
        calloutView.imgViewStar2.image = #imageLiteral(resourceName: "starUnfilled")
        calloutView.imgViewStar3.image = #imageLiteral(resourceName: "starUnfilled")
        calloutView.imgViewStar4.image = #imageLiteral(resourceName: "starUnfilled")
        calloutView.imgViewStar5.image = #imageLiteral(resourceName: "starUnfilled")
        calloutView.lblTime.text = budzAnnotation.BudzMapData.timeStatus
        if Double(budzAnnotation.BudzMapData.rating_sum)! < 2 {
            calloutView.imgViewStar1.image = #imageLiteral(resourceName: "starFilled")
        }else if Double(budzAnnotation.BudzMapData.rating_sum)! < 3 {
            calloutView.imgViewStar1.image = #imageLiteral(resourceName: "starFilled")
             calloutView.imgViewStar2.image = #imageLiteral(resourceName: "starFilled")
        }else if Double(budzAnnotation.BudzMapData.rating_sum)! < 4 {
            calloutView.imgViewStar1.image = #imageLiteral(resourceName: "starFilled")
            calloutView.imgViewStar2.image = #imageLiteral(resourceName: "starFilled")
            calloutView.imgViewStar3.image = #imageLiteral(resourceName: "starFilled")
        }else if Double(budzAnnotation.BudzMapData.rating_sum)! < 5 {
            calloutView.imgViewStar1.image = #imageLiteral(resourceName: "starFilled")
            calloutView.imgViewStar2.image = #imageLiteral(resourceName: "starFilled")
            calloutView.imgViewStar3.image = #imageLiteral(resourceName: "starFilled")
            calloutView.imgViewStar4.image = #imageLiteral(resourceName: "starFilled")
        }else {
            calloutView.imgViewStar1.image = #imageLiteral(resourceName: "starFilled")
            calloutView.imgViewStar2.image = #imageLiteral(resourceName: "starFilled")
            calloutView.imgViewStar3.image = #imageLiteral(resourceName: "starFilled")
            calloutView.imgViewStar4.image = #imageLiteral(resourceName: "starFilled")
            calloutView.imgViewStar5.image = #imageLiteral(resourceName: "starFilled")
        }
        calloutView.center = CGPoint(x: view.bounds.size.width / 2, y: -calloutView.bounds.size.height*0.52)
        view.addSubview(calloutView)
        view.tag = budzAnnotation.BudzMapData.id
        mapView.setCenter((view.annotation?.coordinate)!, animated: true)
    }
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        
        for subview in view.subviews
        {
            subview.removeFromSuperview()
        }
    }
    
    
    
    @objc func openBudzDetail(sender: UIButton)
    {
        var budzmap = BudzMap()
        for indexObj in self.array_Budz {
            if sender.tag == indexObj.id{
                budzmap = indexObj
                break
            }
        }
        let viewPush = self.storyboard?.instantiateViewController(withIdentifier: "DispensaryDetailVC") as! DispensaryDetailVC
        viewPush.chooseBudzMap = budzmap
        self.navigationController?.pushViewController(viewPush, animated: true)
    }
    @IBAction func CloseSearchAction(sender : UIButton){
        self.view_Search.isHidden = true
        self.txtField_Search.text = ""
        self.txtField_Search.resignFirstResponder()
        isKeyWordSearch = false
        searchedValue = ""
         self.GetBudMap(page: 0)
        
    }
    
    @IBAction func ShowSearchAction(sender : UIButton){
        self.view_Search.isHidden = false
        self.txtField_Search.becomeFirstResponder()
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text!.characters.count > 2 {
            self.GetBudMap(page: 0)
        }
  
    }
    
    @IBAction func Share(sender : UIButton){
        self.OpenShare()
    }
}

extension BudzMainVC: UIScrollViewDelegate  {
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        // Change 10.0 to adjust the distance from bottom
        if maximumOffset - currentOffset <= 10.0 {
            self.loadMore()
        }
    }
    
    fileprivate func loadMore() {
        if shouldLoadMore {
            self.GetBudMap(page: pageNumber +  1)
        }
    }
}
