//
//  TagsViewController.swift
//  BaseProject
//
//  Created by MN on 18/04/2018.
//  Copyright © 2018 Wave. All rights reserved.
//

import UIKit

class TagsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource{

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionview: UICollectionView!
    @IBOutlet weak var doneButton:UIButton!
    @IBOutlet weak var noRecordFound: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchTextIcon: UIImageView!
    @IBOutlet weak var mediaCollectionViewHeightContraint: NSLayoutConstraint!
    var index = [Int]()
    var selectedTags = [PostUser]()
    var tags = [PostUser]()
    var forSearch = [PostUser]()
    var delegate: PostFeedViewController?
    var repostDelegate: RepostViewController?
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 50
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.separatorStyle = .none
        tableView.isHidden = false
        noRecordFound.isHidden = true
        if selectedTags.count != 0{
            collectionview.reloadData()
        }
        self.tableView.reloadData()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
//        getTagsList()
        colloectionViewHieght()
        self.tags = (self.tags.sorted{$0.first_name! < $1.first_name!})
        self.forSearch = self.tags
        if self.selectedTags.count != 0{
            collectionview.reloadData()
        }
        searchTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)),
                            for: UIControlEvents.editingChanged)
        searchTextField.addTarget(self, action: #selector(self.textFieldDidEnd(_:)),
                                  for: UIControlEvents.editingDidEnd)
    }
    func colloectionViewHieght(){
        mediaCollectionViewHeightContraint.constant =  selectedTags.count != 0 ? 80 : 0
    }
    
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if !(searchTextField.text?.isEmpty)!{
            tags = (self.forSearch.filter { ($0.first_name?.localizedCaseInsensitiveContains(searchTextField.text!))!})
            
            if tags.count == 0{
                self.tableView.isHidden = true
                self.noRecordFound.isHidden = false
                self.noRecordFound.text = "No Record Found"
                self.noRecordFound.font = UIFont.init(name: self.noRecordFound.font.fontName, size: 17.0)
            }
            self.searchTextIcon.image = #imageLiteral(resourceName: "cross")
        }else{
           self.searchTextIcon.image = #imageLiteral(resourceName: "SearchGray")
            self.noRecordFound.isHidden = true
                self.tableView.isHidden = false
                tags = forSearch
        }
        tableView.reloadData()
    }
    @objc func textFieldDidEnd(_ textField: UITextField) {
        
        print(forSearch)
        if !(searchTextField.text?.isEmpty)!{
            if tags.count == 0{
                self.tableView.isHidden = true
                self.noRecordFound.isHidden = false
                self.noRecordFound.text = "No Record Found"
                 self.noRecordFound.font = UIFont.init(name: self.noRecordFound.font.fontName, size: 17.0)
            }
        }else{
            self.noRecordFound.isHidden = true
            self.tableView.isHidden = false
             tags = forSearch
        }
        tableView.reloadData()
    }
    func tagAdded(index: Int!){
        selectedTags.append(tags[index])
        self.forSearch.remove(at: self.forSearch.index(where: { $0.first_name == tags[index].first_name})!)
        tags.remove(at: index)
        tableView.reloadData()
        collectionview.reloadData()
        colloectionViewHieght()
    }
    
    func tagRemoved(index: Int!){
        if searchTextField.text != ""{
            forSearch.append(selectedTags[index])
        }else{
        tags.append(selectedTags[index])
        forSearch = tags
        tags = tags.sorted{$0.first_name! < $1.first_name!}
        }
        selectedTags.remove(at: index)
        tableView.reloadData()
        collectionview.reloadData()
        colloectionViewHieght()
    }
    @IBAction func onClickCross(sender: UIButton!){
        self.searchTextIcon.image = #imageLiteral(resourceName: "SearchGray")
        self.searchTextField.text = ""
        self.searchTextField.resignFirstResponder()
        self.searchTextField.endEditing(true) 
    }
    @IBAction func dissmissView(sender: UIButton!){
        searchTextField.endEditing(true)
        if selectedTags.count != 0{
    if repostDelegate == nil{
        delegate?.withTagsArray = selectedTags
        delegate?.tagView.isHidden = false 
        delegate?.tagCollectionView.reloadData()
            if selectedTags.count > 3{
                delegate?.letMoretags = false
                delegate?.moreTagButtonWidth.constant = 50
                delegate?.moreTagButton.setTitle((String(selectedTags.count - 3) + " more"), for: .normal)
            }else{
                delegate?.moreTagButtonWidth.constant = 0
            }
            }else{
                repostDelegate?.withTagsArray = selectedTags
                repostDelegate?.tagView.isHidden = false
                repostDelegate?.tagCollectionView.reloadData()
                if selectedTags.count > 3{
                    repostDelegate?.letMoretags = false
                    repostDelegate?.moreTagButtonWidth.constant = 50
                    repostDelegate?.moreTagButton.setTitle((String(selectedTags.count - 3) + " more"), for: .normal)
                }else{
                    repostDelegate?.moreTagButtonWidth.constant = 0
                }
            }
    }
        self.dismiss(animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectedTags.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "tagsSelectedCell", for: indexPath) as! TagsCollectionViewCell    
        cell.profileImage.image = #imageLiteral(resourceName: "ic_discuss_question_profile")
        if selectedTags[indexPath.row].image_path?.range(of:"http") != nil {
            if let url = URL(string: selectedTags[indexPath.row].image_path!){
                cell.profileImage.af_setImage(withURL: url)
            }
            
        }else{
            var imagePath: String
            if selectedTags[indexPath.row].image_path?.range(of:"/") != nil{
                imagePath = selectedTags[indexPath.row].image_path!
            }else{
                imagePath = selectedTags[indexPath.row].avatar!
            }
            if let url = URL(string: WebServiceName.images_baseurl.rawValue + imagePath){
                cell.profileImage.af_setImage(withURL: url)
            }
        }
        if (selectedTags[indexPath.row].special_icon?.characters.count)! > 6 {
            cell.profileImageTop.isHidden = false
            var linked = URL(string: WebServiceName.images_baseurl.rawValue + (selectedTags[indexPath.row].special_icon?.RemoveSpace())!.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!
            cell.profileImageTop.af_setImage(withURL: linked)
        }else {
            cell.profileImageTop.isHidden = true
        }
        cell.removeTagsButtonAction = {[unowned self] in
            self.tagRemoved(index: indexPath.row)
        }
        cell.nameuser.text = selectedTags[indexPath.row].first_name
     return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tags.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tagscell", for: indexPath) as! TagsTableViewCell
        cell.nameLabel.text = tags[indexPath.row].first_name
         cell.profileImage.sd_addActivityIndicator()
         cell.profileImage.sd_setShowActivityIndicatorView(true)
        cell.profileImage.sd_showActivityIndicatorView()
        if tags[indexPath.row].image_path?.range(of:"http") != nil {
            if let url = URL(string: tags[indexPath.row].image_path!){
                cell.profileImage.sd_setImage(with: url,placeholderImage : #imageLiteral(resourceName: "user_placeholder_Budz"), completed: nil)
            }
        }else{
            
            var imagePath: String
            if   tags[indexPath.row].image_path?.range(of:"/") != nil{
                imagePath = tags[indexPath.row].image_path!
            }else{
                if let avater = tags[indexPath.row].avatar{
                      imagePath = avater
                }else{
                    imagePath = ""
                }
              
            }
            if let url = URL(string: WebServiceName.images_baseurl.rawValue + imagePath){
                 cell.profileImage.sd_setImage(with: url,placeholderImage : #imageLiteral(resourceName: "user_placeholder_Budz"), completed: nil)
            }
        }
        if (tags[indexPath.row].special_icon?.characters.count)! > 6 {
            cell.profileImageTop.isHidden = false
            var linked = URL(string: WebServiceName.images_baseurl.rawValue + (tags[indexPath.row].special_icon?.RemoveSpace())!.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!
             cell.profileImageTop.sd_setImage(with: linked,placeholderImage : #imageLiteral(resourceName: "user_placeholder_Budz"), completed: nil)
        }else {
            cell.profileImageTop.isHidden = true
        }
        cell.addTagsButtonAction = {[unowned self] in
            self.tagAdded(index: indexPath.row)
      }
        return cell
    }
    

}
