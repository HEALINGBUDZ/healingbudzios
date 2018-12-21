//
//  EventTicktesCell.swift
//  BaseProject
//

//  Copyright © 2018 Wave. All rights reserved.
//

import UIKit
import ActiveLabel

class EventTicktesCell: UITableViewCell {
    var tickt : Ticktes?
    
    @IBOutlet weak var image_top: NSLayoutConstraint!
    @IBOutlet weak var heading_hight: NSLayoutConstraint!
    @IBOutlet weak var heading: UILabel!
    var chooseBudzMap = BudzMap()
    var baseVc : BaseViewController?
    @IBOutlet weak var btnShare: UIButton!
    @IBOutlet weak var link: ActiveLabel!
    @IBOutlet weak var btn_delete: UIButton!
    @IBOutlet weak var edit_height: NSLayoutConstraint!
    @IBOutlet weak var img_edit: UIImageView!
    @IBOutlet weak var edit_display: UIView!
    @IBOutlet weak var btn_edit: UIButton!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var img_btn: UIButton!
    @IBOutlet weak var img_viewMain: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setData()  {
        self.title.text = self.tickt?.title
        self.price.text = self.tickt?.price
        self.link.applyTag(baseVC: baseVc! , mainText: (self.tickt?.purchase_ticket_url)!)
        let url = WebServiceName.images_baseurl.rawValue  + (self.tickt?.image)!
        self.img_viewMain.sd_setIndicatorStyle(.white)
        self.img_viewMain.sd_addActivityIndicator()
        self.img_viewMain.sd_setImage(with: URL.init(string: url), placeholderImage : #imageLiteral(resourceName: "ic_doctor_icon"), completed: nil)
        self.link.text = self.tickt?.purchase_ticket_url
        self.img_edit.image?.withRenderingMode(.alwaysTemplate)
        self.img_edit.image = #imageLiteral(resourceName: "ic_edit").withRenderingMode(.alwaysTemplate)
        self.img_edit.tintColor = .white
        if(self.chooseBudzMap.user_id != Int((DataManager.sharedInstance.getPermanentlySavedUser()?.ID)!)!){
            self.edit_height.constant = 0
            self.edit_display.isHidden = true
        }else {
            self.edit_height.constant = 40
            self.edit_display.isHidden = false
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func onClickImgBtn(_ sender: Any) {
        if (self.tickt?.image.count)! > 0{
           self.baseVc?.showImagess(attachments: [(self.tickt?.image)!])
        }
    }
    @IBAction func onClickShareBtn(_ sender: Any) {
        var parmas = [String: Any]()
        parmas["id"] = self.tickt?.id
        parmas["type"] = "Budz Ticket"
        parmas["budzNotSahre"] = "1"
        let link : String = Constants.ShareLinkConstant + "get-budz?business_id=\(self.chooseBudzMap.id)&business_type_id=\(self.chooseBudzMap.budzMapType.idType)"
        ///\(String(describing: self.tickt?.id))/\(String(describing: self.tickt?.sub_user_id))
        self.baseVc?.OpenShare(params:parmas,link: link, content:self.chooseBudzMap.title)
    }
    
}
