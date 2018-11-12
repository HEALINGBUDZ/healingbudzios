//
//  filtersViewController.swift
//  BaseProject
//
//  Created by MAC MINI on 02/04/2018.
//  Copyright © 2018 Wave. All rights reserved.
//

import UIKit
var wallSelectedFilter = 0
class filterView: UIView {
    var selectedIndex = 0
    var showReportMenu :Bool = false
    var filtersList:[String]! = ["Newest","Most Liked"]
    {
        didSet
        {
            
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
        
        //custom logic goes here
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func applyFilter(_ sender: Any)
    {
        
    }
    
}
extension filterView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        
            return self.filtersList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
    
            let  cell = tableView.dequeueReusableCell(withIdentifier: "FilterCell", for: indexPath) as? FilterCell
        if selectedIndex == indexPath.row
        {
            cell?.imgRadioIcon.image = #imageLiteral(resourceName: "CircleS")
            cell?.imgBackGroun.backgroundColor = UIColor.darkGray
            cell?.imgYellowSeprator.isHidden=false
            
        }
        else
        {
            cell?.imgRadioIcon.image = #imageLiteral(resourceName: "CircleE")
            cell?.imgBackGroun.backgroundColor = UIColor.clear
            cell?.imgYellowSeprator.isHidden=true
        }
        cell?.lblDescription.textColor = .white
        cell?.lblDescription.text = filtersList[indexPath.row]
        cell?.selectionStyle = .none
        return cell!
    }
}

extension filterView: UITableViewDelegate   {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
            selectedIndex = indexPath.row
//            wallSelectedFilter = indexPath.row
            tableView.reloadData()
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        

    }
}
