//
//  SecondTabbarVC.swift
//  BaseProject
//
//  Created by Vengile on 06/07/2017.
//  Copyright © 2017 Wave. All rights reserved.
//

import UIKit

class SecondTabbarVC: BaseViewController {

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
		self.UpdateTitle(title: "Home Screen")
		self.tabBarController?.tabBar.isHidden = false
		
//		let mainProject = self.GetViewFromProject(nameViewController: "AllProjectsViewController")
		
//		self.navigationController?.pushViewController(mainProject, animated: false)
	}

}


//MARK : Cell
//MARK :

class MainTenanceCell: UITableViewCell {
	@IBOutlet var imgview_Main : UIImageView!
	@IBOutlet var imgview_Shadow : UIImageView!
	@IBOutlet var Btn_Maintenance : UIButton!
	@IBOutlet var Btn_ImageChoose : UIButton!
    
    @IBOutlet var Btn_Camera : UIButton!
}

class EnterInfoCell: UITableViewCell {
	@IBOutlet var Lbl_Heading : UILabel!
	@IBOutlet var TF_Info : UITextView!
}

class PickerCell: UITableViewCell {
	@IBOutlet var Lbl_Heading : UILabel!
	@IBOutlet var lbl_PickerValue : UILabel!
	@IBOutlet var Btn_Picker : UIButton!
	@IBOutlet var View_Picker : UIView!
}

class SwitchChooseCell: UITableViewCell {
	@IBOutlet var Lbl_Heading : UILabel!
	@IBOutlet var switch_Main : UISwitch!
}

class BottomButtonsCell: UITableViewCell {
	@IBOutlet var Btn_First : UIButton!
	@IBOutlet var Btn_Middel : UIButton!
	@IBOutlet var Btn_Last : UIButton!
	
	@IBOutlet var ImgView_First : UIImageView!
	@IBOutlet var ImgView_Middel : UIImageView!
	@IBOutlet var ImgView_Last : UIImageView!
}

class ListRowCell: UITableViewCell {
	@IBOutlet var Lbl_Heading : UILabel!
}

class ButtonCell: UITableViewCell {
	@IBOutlet var Btn_Cell : UIButton!
}

class ImageTextFildCell: UITableViewCell {
	@IBOutlet var Lbl_Heading : UILabel!
	@IBOutlet var lbl_PickerValue : UILabel!
	@IBOutlet var Btn_Picker : UIButton!
	@IBOutlet var View_Picker : UIView!
}


class LinktoOnlinePriceCell: UITableViewCell {
	@IBOutlet var Btn_Link : UIButton!
}





class MenuImageCell: UITableViewCell {
	@IBOutlet var lbl_Title : UILabel!
	@IBOutlet var imgview_Main : UIImageView!
}


class ProjectHeadingCell: UITableViewCell {
	@IBOutlet var lbl_Title : UILabel!
	@IBOutlet var imgview_Main : UIImageView!
	@IBOutlet var imgview_Shadow : UIImageView!
	
	@IBOutlet var Btn_ImageChoose : UIButton!
	@IBOutlet var Btn_Camera : UIButton!
}


class BudgetComponentCell: UITableViewCell {
	
}


class TwoTFCell: UITableViewCell {
	@IBOutlet var lbl_Title_One : UILabel!
	@IBOutlet var lbl_Title_Two : UILabel!
	
	@IBOutlet var Tv_One : UITextField!
	@IBOutlet var Tv_Two : UITextField!
}

class BudgetsummaryHeading: UITableViewCell {
	
}

class BudgetComponentPriceCell: UITableViewCell {
	@IBOutlet var lbl_PartName : UILabel!
	@IBOutlet var lbl_Price : UILabel!
}


class BudgetTotalCell: UITableViewCell {
	@IBOutlet var lbl_Heading : UILabel!
	@IBOutlet var lbl_Price : UILabel!
}



class BudgetComponentPriceRedCell: UITableViewCell {
	@IBOutlet var lbl_PartName : UILabel!
	@IBOutlet var lbl_Price : UILabel!
}


class InvoicesPartsCell: UITableViewCell {
	
}


class PartsOrderCell: UITableViewCell {
	@IBOutlet var lbl_PartName : UILabel!
	@IBOutlet var imgView_Box : UIImageView!
}

class LineCell: UITableViewCell {
	
}

class ActivityHeadingCell: UITableViewCell {
	
}

class ActivityListingDataCell: UITableViewCell {
	@IBOutlet var lbl_PartName	: UILabel!
	@IBOutlet var lbl_Scheduled	: UILabel!
	@IBOutlet var imgView_Box		: UIImageView!
	
	@IBOutlet var btn_Detail		: UIButton!
}

class AddPhoto: UITableViewCell {
	@IBOutlet var btn_choosePhoto		: UIButton!
    @IBOutlet var imgMain		: UIImageView!
}

class PhotoChooseCell: UITableViewCell {
	@IBOutlet var imgView_Main		: UIImageView!
	@IBOutlet var btn_choosePhoto		: UIButton!
}

class MenuHeaderCell: UITableViewCell {
    @IBOutlet var lbl_Name : UILabel!
       @IBOutlet var imageMain : UIImageView!
}

class MenuCell: UITableViewCell {
	@IBOutlet var lbl_Name : UILabel!
}

class MenuListCell: UITableViewCell {
	@IBOutlet var lbl_Name : UILabel!
}


class PartsInfoCell: UITableViewCell {
    @IBOutlet var lbl_Name : UILabel!
    @IBOutlet var lbl_Dis : UILabel!
    
    @IBOutlet var viewMain : UIView!
    
    @IBOutlet var lbl_Name_Heading : UILabel!
    @IBOutlet var lbl_Dis_Heading : UILabel!
    
}


class TwoDatePickerCell: UITableViewCell {
	@IBOutlet var Lbl_Heading : UILabel!
	@IBOutlet var lbl_PickerValue : UILabel!
	@IBOutlet var Btn_Picker : UIButton!
	@IBOutlet var View_Picker : UIView!
	
	@IBOutlet var Lbl_Heading_2 : UILabel!
	@IBOutlet var lbl_PickerValue_2 : UILabel!
	@IBOutlet var Btn_Picker_2 : UIButton!
	@IBOutlet var View_Picker_2 : UIView!
}


class TwoPickerCell: UITableViewCell {
	@IBOutlet var Lbl_Heading : UILabel!
	@IBOutlet var lbl_PickerValue : UILabel!
	@IBOutlet var Btn_Picker : UIButton!
	@IBOutlet var View_Picker : UIView!
	
	@IBOutlet var Lbl_Heading_2 : UILabel!
	@IBOutlet var lbl_PickerValue_2 : UILabel!
	@IBOutlet var Btn_Picker_2 : UIButton!
	@IBOutlet var View_Picker_2 : UIView!
}

class ModelYearcell: UITableViewCell {
    @IBOutlet var Lbl_Heading : UILabel!
    @IBOutlet var lbl_PickerValue : UILabel!
    @IBOutlet var Btn_Picker : UIButton!
    @IBOutlet var View_Picker : UIView!
    
    @IBOutlet var Lbl_Heading_2 : UILabel!
    @IBOutlet var TF_Main : UITextField!
    @IBOutlet var Btn_Picker_2 : UIButton!
    @IBOutlet var View_Picker_2 : UIView!
}



class NorecordFoundCell: UITableViewCell {
 
}



class TextAndPickercell: UITableViewCell {
    @IBOutlet var Lbl_Heading : UILabel!
    
    @IBOutlet var Tf_Main : UITextView!
    @IBOutlet var View_Picker : UIView!
    
    @IBOutlet var Lbl_Heading_2 : UILabel!
    @IBOutlet var lbl_PickerValue_2 : UILabel!
    @IBOutlet var Btn_Picker_2 : UIButton!
    @IBOutlet var View_Picker_2 : UIView!
}

