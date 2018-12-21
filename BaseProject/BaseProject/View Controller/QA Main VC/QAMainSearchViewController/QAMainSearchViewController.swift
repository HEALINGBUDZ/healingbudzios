//
//  QAMainSearchViewController.swift
//  BaseProject
//
//  Created by macbook on 28/11/2017.
//  Copyright © 2017 Wave. All rights reserved.
//

import UIKit
import MBProgressHUD
class QAMainSearchViewController: BaseViewController , UITableViewDelegate , UITableViewDataSource {
    @IBOutlet weak var tblViewSearch: UITableView!
    @IBOutlet weak var filterViewHeight_constraint: NSLayoutConstraint!
    @IBOutlet weak var txtFldSearch: UITextField!
    var hud =   MBProgressHUD()
    @IBOutlet weak var uiImage_cross: UIImageView!
    var gloablArray = [[String: Any]]()
    @IBOutlet weak var viewFilter: UIView! 
    @IBOutlet weak var searchResultsView: UIView!
    var searchArray:[QA] = []
    //SearchWhite
    //Cross_White
    var isAutoSearch : Bool = false
    var isFromRewardSection : Bool = false
    var pageNumber = 0
    fileprivate var shouldLoadMore = true
    var isFilterOpen = false
    @IBOutlet weak var qaSwitch: UISwitch!
    @IBOutlet weak var bmSwitch: UISwitch!
    @IBOutlet weak var straintsSwitch: UISwitch!
    @IBOutlet weak var usersSwitch: UISwitch!
    func textFieldDidEndEditing(_ textField: UITextField) {
        if !self.txtFldSearch.text!.isEmpty{
            self.search(querry: self.txtFldSearch.text! , page: 0)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        txtFldSearch.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        self.tblViewSearch.register(UINib(nibName: "GlobalSearchCell", bundle: nil), forCellReuseIdentifier: "GlobalSearchCell")
        self.tblViewSearch.indicatorStyle = .default
        self.tblViewSearch.isHidden = true
        self.txtFldSearch.delegate = self
        self.filterViewHeight_constraint.constant = 0
        
        if isFromRewardSection{
            self.qaSwitch.isOn = false
            self.bmSwitch.isOn = false
            self.straintsSwitch.isOn = false
            self.usersSwitch.isOn = true
            self.search(querry: "", page: 0)
        }      
        let topSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
        topSwipe.direction = .up
        view.addGestureRecognizer(topSwipe)
        
        
        qaSwitch.addTarget(self, action: #selector(switchIsChanged(mySwitch:)), for: .valueChanged)
        bmSwitch.addTarget(self, action: #selector(switchIsChanged(mySwitch:)), for: .valueChanged)
        straintsSwitch.addTarget(self, action: #selector(switchIsChanged(mySwitch:)), for: .valueChanged)
        usersSwitch.addTarget(self, action: #selector(switchIsChanged(mySwitch:)), for: .valueChanged)
        
        
    }
    
    @objc func switchIsChanged(mySwitch: UISwitch) {
        self.search(querry: self.txtFldSearch.text!, page: 0)
    }

    @objc func handleSwipes(_ sender:UISwipeGestureRecognizer) {
        if (sender.direction == .up) {
            if isFilterOpen{
                isFilterOpen = false
                self.tblViewSearch.isScrollEnabled = true
                self.tblViewSearch.isUserInteractionEnabled = true
                self.filterViewHeight_constraint.constant = 0
                UIView.animate(withDuration: 0.5) {
                     self.tblViewSearch.alpha = 1.0
                    self.view.layoutIfNeeded()
                    if !self.txtFldSearch.text!.isEmpty{
//                        self.search(querry: self.txtFldSearch.text!, page: 0)
                    }
                    
                }
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for view in self.view.subviews{
            if  view != self.viewFilter{
                if isFilterOpen{
                    isFilterOpen = false
                    self.tblViewSearch.isScrollEnabled = true
                    self.tblViewSearch.isUserInteractionEnabled = true
                    self.filterViewHeight_constraint.constant = 0
                    UIView.animate(withDuration: 0.5) {
                         self.tblViewSearch.alpha = 1.0
                        self.view.layoutIfNeeded()
                        if !self.txtFldSearch.text!.isEmpty{
//                            self.search(querry: self.txtFldSearch.text!, page: 0)
                        }
                        
                    }
                }
            }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    
    @IBAction func HideView(sender : UIButton){
        self.view.removeFromSuperview()
    }
    //MARK: - Search Methods
    @objc func textFieldDidChange(_ textField: UITextField) {
   
    }
    
    @IBAction func onClickBack(_ sender: Any) {
        self.Back()
    }
    @IBAction func onClickHome(_ sender: Any) {
        self.GotoHome()
    }
    @IBAction func onClickSearch(_ sender: Any) {
        if !self.txtFldSearch.text!.isEmpty{
            self.txtFldSearch.resignFirstResponder()
            self.txtFldSearch.text! = ""
            self.gloablArray.removeAll()
            self.tblViewSearch.restore()
            self.tblViewSearch.reloadData()
            self.uiImage_cross.image = #imageLiteral(resourceName: "SearchWhite")
        }else {
            self.txtFldSearch.becomeFirstResponder()
        }
    }
    override func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.txtFldSearch.resignFirstResponder()
        self.isAutoSearch = false
        self.search(querry: textField.text! , page: 0)
        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newText = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        let numberOfChars = newText.count
        if numberOfChars>0{
            self.uiImage_cross.image = #imageLiteral(resourceName: "Cross_White")
            self.isAutoSearch = false
            self.search(querry: newText, page: 0)
        }else {
            self.uiImage_cross.image = #imageLiteral(resourceName: "SearchWhite")
        }
        return true
    }
    
    func Loading() {
        hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.contentColor = UIColor.init(hex: "FFFFFF")
        hud.bezelView.color = UIColor.clear
        hud.backgroundColor = UIColor.black.withAlphaComponent(0.0)
        hud.bezelView.style = .solidColor
        hud.label.text = "Loading.."
        hud.mode = .indeterminate
    }
    func hide_Loading()  {
        MBProgressHUD.hide(for: self.view, animated: true)
    }
    
    func search(querry : String , page : Int) {
        var filterString = ""
        if self.qaSwitch.isOn{
            (filterString.isEmpty) ? filterString.append("q,a"):filterString.append(",q,a")
        }
        if self.bmSwitch.isOn{
            (filterString.isEmpty) ? filterString.append("bm"):filterString.append(",bm")
        }
        if self.straintsSwitch.isOn{
            (filterString.isEmpty) ? filterString.append("s"):filterString.append(",s")
        }
        if self.usersSwitch.isOn{
            (filterString.isEmpty) ? filterString.append("u"):filterString.append(",u")
        }
        if filterString.isEmpty{
            filterString = "q,a,bm,s,u"
        }
        let url = WebServiceName.globle_search.rawValue + "?query=\(querry)&zip_code=\(String(describing: DataManager.sharedInstance.getPermanentlySavedUser()!.zipcode))&state=\(String(describing: DataManager.sharedInstance.getPermanentlySavedUser()!.address))&skip=\(page)&filter=\(filterString)"
        print(url)
        if !self.isAutoSearch{
            self.Loading()
        }
        NetworkManager.GetCall(UrlAPI: url.RemoveSpace(), completion: { (success, messageResponse, dataResponse) in
             self.hideLoading()
            print("paramaMain ==> \(dataResponse)")
            print("paramaMain ==> \(messageResponse)")
           
            if success{
                self.searchResultsView.isHidden = false
                if let success = dataResponse["successData"] as? [String: Any]{
                    if page == 0 {
                        self.gloablArray.removeAll()
                    }
                    if let global = success["sub_users"] as? [[String: Any]]{
                        for index in global{
                           var newIndex =  index
                            newIndex["s_type"] = "bm"
                            newIndex["is_premium"] = "is_premium"
                           self.gloablArray.append(newIndex)
                        }
                    }
                    if let global = success["records"] as? [[String: Any]]{
                        for index  in global{
                            if let type = index["s_type"] as? String , let id  = index["id"] as? Int {
                                if type == "u" && "\(id)" == DataManager.sharedInstance.user?.ID {
                                    print("Same user ")
                                }else{
                                    self.gloablArray.append(index)
                                }
                            }
                        }
                        self.shouldLoadMore = !global.isEmpty
                    }
                    
                    self.pageNumber = page
                    self.tblViewSearch.isHidden = false
                    if self.gloablArray.count == 0 {
                        self.tblViewSearch.setEmptyMessage("No Record Found!", color: UIColor.init(hex: "979797"))
                    }else{
                        self.tblViewSearch.restore()
                    }
                    self.tblViewSearch.reloadData()
                }
            }
            self.hide_Loading()
            
        })
    }
    //MARK: table view data source/delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.gloablArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblViewSearch.dequeueReusableCell(withIdentifier: "GlobalSearchCell", for: indexPath) as! GlobalSearchCell
        cell.selectionStyle = .none
         cell.imgView.image = #imageLiteral(resourceName: "noimage")
         cell.imgView.roundViewRemove()
         cell.imgView.contentMode = .scaleAspectFit
        cell.lblDescription.applyTag(baseVC: self , mainText: ((self.gloablArray[indexPath.row]["description"] as? String)?.RemoveHTMLTag()) ?? "")
        cell.ui_feature_for_adz.isHidden = true
        cell.ui_feature_for_adz.roundCorners(corners: [.topLeft, .bottomLeft], radius: 10)
        cell.lblDescription.text = (self.gloablArray[indexPath.row]["description"] as? String)?.RemoveHTMLTag()
        cell.lblName.applyTag(baseVC: self , mainText:  ((self.gloablArray[indexPath.row]["title"] as? String)?.RemoveHTMLTag())!)
        cell.lblName.text = (self.gloablArray[indexPath.row]["title"] as? String)?.RemoveHTMLTag()
        cell.lblDescription.textColor = UIColor.init(hex: "979797")
        print(self.gloablArray[indexPath.row]["s_type"] as! String)
        switch (self.gloablArray[indexPath.row]["s_type"] as! String) {
        case "bm":
            cell.imgView.image = #imageLiteral(resourceName: "leafCirclePink")
            cell.lblName.textColor = UIColor.init(hex: "942a89")
            if let val = self.gloablArray[indexPath.row]["is_premium"] as? String{
                if val != "null"{
                     cell.ui_feature_for_adz.isHidden = false
                    
                }else {
                    cell.ui_feature_for_adz.isHidden = true
                }
                
            }else {
                cell.ui_feature_for_adz.isHidden = true
            }
        case "a":
            cell.imgView.image = #imageLiteral(resourceName: "Tab0")
            cell.lblName.textColor = UIColor.init(hex: "0082cb")
        case "q":
            cell.imgView.image = #imageLiteral(resourceName: "Tab0")
            cell.lblName.textColor = UIColor.init(hex: "0082cb")
        case "s":
            cell.imgView.image = #imageLiteral(resourceName: "Tab3")
            cell.lblName.textColor = UIColor.init(hex: "f5c52f")
        case "u":
            cell.imgView.contentMode = .scaleToFill
            cell.imgView.sd_showActivityIndicatorView()
            cell.imgView.startAnimating()
            if let user =  self.gloablArray[indexPath.row]["user"] as? [String : Any]{
                if let img_path = user["image_path"] as? String {
                    if img_path.contains("facebook.com") || img_path.contains("google.com"){
                       cell.imgView.sd_setImage(with: URL.init(string: img_path), placeholderImage :#imageLiteral(resourceName: "ic_feed_user") , completed: nil)
                    }else{
                         cell.imgView.sd_setImage(with: URL.init(string: WebServiceName.images_baseurl.rawValue + img_path), placeholderImage :#imageLiteral(resourceName: "ic_feed_user") , completed: nil)
                    }
                }else if let avatar = user["avatar"] as? String {
                    cell.imgView.sd_setImage(with: URL.init(string: WebServiceName.images_baseurl.rawValue + avatar.RemoveSpace()),placeholderImage :#imageLiteral(resourceName: "ic_feed_user") ,  completed: nil)
                }else{
                    cell.imgView.image = #imageLiteral(resourceName: "ic_feed_user")
                }
            }else{
                cell.imgView.image = #imageLiteral(resourceName: "ic_feed_user")
            }
            cell.imgView.RoundView()
            cell.lblName.textColor = UIColor.init(hex: "979797")
      
        default:
            cell.imgView.image = #imageLiteral(resourceName: "noimage")
            cell.lblName.textColor = UIColor.init(hex: "979797")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch (self.gloablArray[indexPath.row]["s_type"] as! String) {
        case "bm":
            let viewpush = self.GetView(nameViewController: "DispensaryDetailVC", nameStoryBoard: StoryBoardConstant.Main) as! DispensaryDetailVC
            viewpush.budz_map_id = "\(self.gloablArray[indexPath.row]["id"] as! Int)"
            viewpush.sendValueKey = self.txtFldSearch.text!
            self.navigationController?.pushViewController(viewpush, animated: true)
        case "a","q":
            let DetailQuestionVc = self.GetView(nameViewController: "DetailQAViewController", nameStoryBoard: StoryBoardConstant.QA) as! DetailQAViewController
            DetailQuestionVc.QuestionID = String(self.gloablArray[indexPath.row]["id"] as! Int)
            DetailQuestionVc.isFromProfile = false
            self.navigationController?.pushViewController(DetailQuestionVc, animated: true)
        case "s":
            let detailView = self.GetView(nameViewController: "StrainDetailViewController", nameStoryBoard: StoryBoardConstant.Main) as! StrainDetailViewController
            detailView.IDMain = "\(self.gloablArray[indexPath.row]["id"] as! Int)"
            self.navigationController?.pushViewController(detailView, animated: true)
        case "u":
            self.OpenProfileVC(id: "\(self.gloablArray[indexPath.row]["id"] as! Int)")
        default: break
        }
    }
    //MARK: - Methods
    
    @IBAction func onTapShowFilters(_ sender: Any) {
        isFilterOpen = true
        self.tblViewSearch.isScrollEnabled = false
        self.tblViewSearch.isUserInteractionEnabled = false
        self.filterViewHeight_constraint.constant = 230
        UIView.animate(withDuration: 0.5) {
             self.tblViewSearch.alpha = 0.2
            self.view.layoutIfNeeded()
        }
    }
    @IBAction func onTapCloseFilters(_ sender: Any) {
        isFilterOpen =  false
        self.tblViewSearch.isScrollEnabled = true
        self.tblViewSearch.isUserInteractionEnabled = true
        self.filterViewHeight_constraint.constant = 0
        UIView.animate(withDuration: 0.5) {
             self.tblViewSearch.alpha = 1.0
            self.view.layoutIfNeeded()
            if !self.txtFldSearch.text!.isEmpty{
//                 self.search(querry: self.txtFldSearch.text!, page: 0)
            }
           
        }
    }
    
}

extension QAMainSearchViewController: UIScrollViewDelegate  {
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
            self.search(querry: self.txtFldSearch.text! ,page: pageNumber +  1)
        }
    }
}
