//
//  MyJournalVC.swift
//  BaseProject
//
//  Created by MAC MINI on 06/11/2017.
//  Copyright © 2017 Wave. All rights reserved.
//

import UIKit

class MyJournalVC: BaseViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var collectionView_calendar: UICollectionView!
    @IBOutlet weak var LblNextMonth: UILabel!
    @IBOutlet weak var LblPreviousMonth: UILabel!
    @IBOutlet weak var LblCurrentMonth: UILabel!
    @IBOutlet weak var tableView_journal: UITableView!
    @IBOutlet weak var view_Calendar: UIView!
    @IBOutlet weak var view_journals: UIView!
    @IBOutlet weak var view_Tags: UIView!
    @IBOutlet weak var view_mainCalendar: UIView!
    @IBOutlet weak var view_mainTable: UIView!
    @IBOutlet weak var imgView_calendar: UIImageView!
    @IBOutlet weak var Lbl_calendar: UILabel!
    @IBOutlet weak var imgView_journal: UIImageView!
    @IBOutlet weak var Lbl_journal: UILabel!
    @IBOutlet weak var imgView_tags: UIImageView!
    @IBOutlet weak var Lbl_tags: UILabel!
    @IBOutlet weak var view_Search: UIView!
    
    var dateAddtion:Int?
    var daysArray:[Dictionary<String, String>] = []
    var dateNow = Date()
    var array_tbleJournal = [[String : Any]]()
    var array_tblTags = [[String : Any]]()
    
    var calendarViewShown = true
    var tagsViewShown = false
    var journalsViewShown = false
    var searchViewShown = false
    
    let monthNameFormatter = DateFormatter()
    let mainMonthFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        monthNameFormatter.dateFormat = "MMM"
        mainMonthFormatter.dateFormat = "MMMM yyyy"
        self.loadCalendar()
        self.ReloadData()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Button Actions
    
    @IBAction func previousBtn(_ sender: Any) {
        daysArray = self.previousPressed() as! [Dictionary<String, String>]
        collectionView_calendar.reloadData()
    }
    @IBAction func nextBtn(_ sender: Any) {
        daysArray = self.nextPressed() as! [Dictionary<String, String>]
        collectionView_calendar.reloadData()
    }
   
    @IBAction func Btn_search(_ sender: Any) {
        if searchViewShown {
            searchViewShown = false
            view_Search.isHidden = true
        }
        else{
            searchViewShown = true
            view_Search.isHidden = false
        }
        
    }
    @IBAction func Btn_Calendar(_ sender: Any) {
      journalsViewShown = false
      tagsViewShown = false
        calendarViewShown = true
        view_mainCalendar.isHidden = false
        view_mainTable.isHidden = true
        view_Calendar.backgroundColor = UIColor(red:0.463, green:0.765, blue:0.325, alpha:1.000)
        view_Tags.backgroundColor = UIColor.clear
        view_journals.backgroundColor = UIColor.clear
        Lbl_calendar.textColor = UIColor.white
        imgView_calendar.image = #imageLiteral(resourceName: "calendar_white")
        Lbl_tags.textColor = UIColor(red:0.773, green:0.773, blue:0.773, alpha:1.000)
        imgView_tags.image = #imageLiteral(resourceName: "tags_gray")
        Lbl_journal.textColor = UIColor(red:0.773, green:0.773, blue:0.773, alpha:1.000)
        imgView_journal.image = #imageLiteral(resourceName: "journal_gray")
    
    }
    
    @IBAction func Btn_Journals(_ sender: Any) {
        journalsViewShown = true
        tagsViewShown = false
        calendarViewShown = false
        tableView_journal.reloadData()
        view_mainCalendar.isHidden = true
        view_mainTable.isHidden = false
        view_journals.backgroundColor = UIColor(red:0.463, green:0.765, blue:0.325, alpha:1.000)
        view_Tags.backgroundColor = UIColor.clear
        view_Calendar.backgroundColor = UIColor.clear
        Lbl_journal.textColor = UIColor.white
        imgView_journal.image = #imageLiteral(resourceName: "journal_white")
        Lbl_tags.textColor = UIColor(red:0.773, green:0.773, blue:0.773, alpha:1.000)
        imgView_tags.image = #imageLiteral(resourceName: "tags_gray")
        Lbl_calendar.textColor = UIColor(red:0.773, green:0.773, blue:0.773, alpha:1.000)
        imgView_calendar.image = #imageLiteral(resourceName: "calendar_gray")
    }
    
    @IBAction func Btn_Tags(_ sender: Any) {
        tagsViewShown = true
        calendarViewShown = false
        journalsViewShown = false
        tableView_journal.reloadData()
        view_mainCalendar.isHidden = true
        view_mainTable.isHidden = false
        view_Tags.backgroundColor = UIColor(red:0.463, green:0.765, blue:0.325, alpha:1.000)
        view_Calendar.backgroundColor = UIColor.clear
        view_journals.backgroundColor = UIColor.clear
        Lbl_tags.textColor = UIColor.white
        imgView_tags.image = #imageLiteral(resourceName: "tags_white")
        Lbl_journal.textColor = UIColor(red:0.773, green:0.773, blue:0.773, alpha:1.000)
        imgView_journal.image = #imageLiteral(resourceName: "journal_gray")
        Lbl_calendar.textColor = UIColor(red:0.773, green:0.773, blue:0.773, alpha:1.000)
        imgView_calendar.image = #imageLiteral(resourceName: "calendar_gray")
        
    }
    
    //MARK: Load Calendar Method
    func loadCalendar() {
        dateAddtion = 0
        collectionView_calendar.delegate = self
        collectionView_calendar.dataSource = self
        let todayDate = Date()
        LblCurrentMonth.text = mainMonthFormatter.string(from: todayDate)
        let nextMonth = Calendar.current.date(byAdding: .month, value: 1, to: todayDate)
        LblNextMonth.text = monthNameFormatter.string(from: nextMonth!)
        let previousMonth = Calendar.current.date(byAdding: .month, value: -1, to: todayDate)
        LblPreviousMonth.text = monthNameFormatter.string(from: previousMonth!)
        let currentMonthStart = todayDate.firstDayOfMonth.weekDay
        print("\(currentMonthStart)")
        let totalDaysInCurrentMonth = todayDate.getDaysInMonth()
        print("\(totalDaysInCurrentMonth)")

        for i in 1...totalDaysInCurrentMonth{
            var dic = [String:AnyObject]()
            dic["type"] = "current" as AnyObject
            dic["date"] = String(i) as AnyObject
             print("array value is \(daysArray)")
            daysArray.append(dic as! [String : String])
            print("array value is \(daysArray)")
        }
        if currentMonthStart != 1 {
            let array = self.provideCalendarArray(previousArray: daysArray)
            daysArray = array as! [Dictionary<AnyHashable, Any>] as! [Dictionary<String, String>]
        }
        else{
            for i in 1...42-daysArray.count{
                var dic = [String:AnyObject]()
                dic["type"] = "current" as AnyObject
                dic["date"] = String(i) as AnyObject
                daysArray.append(dic as! [String : String])

            }
        }

    }
    
    @IBAction func Home_Btn(_ sender: Any) {
        self.GotoHome()
    }
    
    @IBAction func Back_Btn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

}
extension MyJournalVC{
    // MARK:  CollectionView Methods
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return daysArray.count;
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CalendarCell", for: indexPath) as? CalendarCell
      
        
        cell?.dateLbl.text = daysArray[indexPath.row]["date"] as! String
        if daysArray[indexPath.row]["type"] == "current" {
             cell?.backgroundColor = UIColor(red:0.894, green:0.894, blue:0.898, alpha:1.000)
            cell?.dateLbl.textColor = UIColor(red:0.322, green:0.322, blue:0.322, alpha:1.000)
            if indexPath.row == 3 || indexPath.row == 4 {
                cell?.imgView_edit.isHidden = false
                cell?.Lbl_editCount.isHidden = false
                cell?.backgroundColor = UIColor.orange
            }
            else{
                cell?.imgView_edit.isHidden = true
                cell?.Lbl_editCount.isHidden = true
                cell?.backgroundColor = UIColor(red:0.894, green:0.894, blue:0.898, alpha:1.000)
            }
            cell?.removeBorder()
        }
        else{
          cell?.backgroundColor = UIColor(white: 1, alpha: 0.2)
            cell?.dateLbl.textColor = UIColor.white
            cell?.drawBorderWithColor(color: UIColor(red:0.463, green:0.471, blue:0.475, alpha:1.000))
          
           
        }
        
        return cell!
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: CGFloat((collectionView.frame.size.width / 7)-2 ), height: CGFloat(45))
    }
    
    // MARK:  Method For Previous And Next Days Calculation
    func provideCalendarArray(previousArray:Array<Any>) -> Array<Any> {
        
        let todayDate = Date()
        let currentMonthStart = todayDate.firstDayOfMonth.weekDay
        let previousMonth = Calendar.current.date(byAdding: .month, value: -1, to: Date())
        let totalDaysPreviousMonth = previousMonth?.getDaysInMonth()
        var daysPreviousForLoop = totalDaysPreviousMonth!
        var previousDaysArray = [Int]()
        for _ in 1...currentMonthStart-1{
            previousDaysArray.append(daysPreviousForLoop)
            daysPreviousForLoop -= 1
        }
        let sortedPreviousArray = previousDaysArray.sorted()
        
        var tempArray :[Dictionary<String, String>] = []
        for i in sortedPreviousArray {
            var dic:Dictionary = [String:AnyObject]()
            dic["type"] = "previous" as AnyObject
            dic["date"] = String(i) as AnyObject
           
            tempArray.append(dic as! [String : String])
            
        }
        
        for j in previousArray{
            let dic:Dictionary = j as! Dictionary<String,AnyObject>
          
            tempArray.append(dic as! [String : String])
        }
        if tempArray.count<42 {
            for i in 1...42-tempArray.count{
                var dic:Dictionary = [String:AnyObject]()
                dic["type"] = "next" as AnyObject
                dic["date"] = String(i) as AnyObject

                tempArray.append(dic as! [String : String])
            }
        }
        return tempArray
    }
    func nextPressed()->Array<Any>  {
        dateAddtion = dateAddtion!+1
        dateNow = Calendar.current.date(byAdding: .month, value: dateAddtion!, to: Date())!
        return self.showNextMonth(previousArray: daysArray)
        
    }
    func previousPressed()->Array<Any> {
        dateAddtion = dateAddtion!-1
        dateNow = Calendar.current.date(byAdding: .month, value: dateAddtion!, to: Date())!
        return self.showNextMonth(previousArray: daysArray)
        
        
        
        
    }
    func showNextMonth(previousArray:Array<Any>) -> Array<Any> {
        
    
        
        
        let todayDate = dateNow
        LblCurrentMonth.text = mainMonthFormatter.string(from: todayDate)
        let nextMonthFromNow = Calendar.current.date(byAdding: .month, value: 1, to: todayDate)
        LblNextMonth.text = monthNameFormatter.string(from: nextMonthFromNow!)
        let previousMonthFromNow = Calendar.current.date(byAdding: .month, value: -1, to: todayDate)
        LblPreviousMonth.text = monthNameFormatter.string(from: previousMonthFromNow!)
        daysArray = []
        let totalDaysInCurrentMonth = todayDate.getDaysInMonth()
        print("\(totalDaysInCurrentMonth)")
        for i in 1...totalDaysInCurrentMonth{
            var dic:Dictionary = [String:AnyObject]()
            dic["type"] = "current" as AnyObject
            dic["date"] = String(i) as AnyObject
            
            daysArray.append(dic as! [String : String])

          
        }
        
        let currentMonthStart = dateNow.firstDayOfMonth.weekDay
        let previousMonth = Calendar.current.date(byAdding: .month, value: -1, to: dateNow)
        let totalDaysPreviousMonth = previousMonth?.getDaysInMonth()
        var daysPreviousForLoop = totalDaysPreviousMonth!
        var previousDaysArray = [Int]()
        var tempArray:[Dictionary<String, String>] = []
        if currentMonthStart != 1 {
            
            
            for _ in 1...currentMonthStart-1{
                previousDaysArray.append(daysPreviousForLoop)
                daysPreviousForLoop -= 1
            }
            let sortedPreviousArray = previousDaysArray.sorted()
            
            
            for i in sortedPreviousArray {
                var dic:Dictionary = [String:AnyObject]()
                dic["type"] = "previous" as AnyObject
                dic["date"] = String(i) as AnyObject
                
                tempArray.append(dic as! [String : String])

                
            }
        }
        for j in daysArray{
            let dic:Dictionary = j
            
            tempArray.append(dic )

        }
        
        
        if tempArray.count<42 {
            for i in 1...42-tempArray.count{
                var dic:Dictionary = [String:AnyObject]()
                dic["type"] = "next" as AnyObject
                dic["date"] = String(i) as AnyObject
                
                tempArray.append(dic as! [String : String])

            }
        }
        return tempArray
      
    }

    
}
extension Date{
    var weekDay:Int{
        return Calendar.current.component(.weekday, from: self)
    }
    var firstDayOfMonth:Date{
        return Calendar.current.date(from: Calendar.current.dateComponents([.year,.month], from: self))!
        
    }
    func getDaysInMonth() -> Int{
        let calendar = Calendar.current
        
        let dateComponents = DateComponents(year: calendar.component(.year, from: self), month: calendar.component(.month, from: self))
        let date = calendar.date(from: dateComponents)!
        
        let range = calendar.range(of: .day, in: .month, for: date)!
        let numDays = range.count
        
        return numDays
    }
    
}
extension String{
    static var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    var date: Date? {
        return String.dateFormatter.date(from: self)
    }
}
extension MyJournalVC:UITableViewDelegate,UITableViewDataSource{
    func ReloadData(){
        self.array_tbleJournal.removeAll()
        self.array_tbleJournal.append(["type" : JournalCell.AddCell.rawValue])
        self.array_tbleJournal.append(["type" : JournalCell.JournalCell.rawValue])
        self.array_tbleJournal.append(["type" : JournalCell.JournalCell.rawValue])
        self.array_tbleJournal.append(["type" : JournalCell.JournalCell.rawValue])
        self.array_tbleJournal.append(["type" : JournalCell.JournalCell.rawValue])
        self.array_tbleJournal.append(["type" : JournalCell.JournalCell.rawValue])
        
        //Appending to tags array
        self.array_tblTags.removeAll()
        self.array_tblTags.append(["type" : TagsCell.tags.rawValue])
         self.array_tblTags.append(["type" : TagsCell.tagEdit.rawValue])
        self.array_tblTags.append(["type" : TagsCell.treatment.rawValue])
        self.RegisterXib()
    }
    func RegisterXib(){
        
        
        self.tableView_journal.register(UINib(nibName: "addJournalCell", bundle: nil), forCellReuseIdentifier: "addJournalCell")
        self.tableView_journal.register(UINib(nibName: "journalsCell", bundle: nil), forCellReuseIdentifier: "journalsCell")
        self.tableView_journal.register(UINib(nibName: "tagsCell", bundle: nil), forCellReuseIdentifier: "tagsCell")
        self.tableView_journal.register(UINib(nibName: "tagEditCell", bundle: nil), forCellReuseIdentifier: "tagEditCell")
        self.tableView_journal.register(UINib(nibName: "treatmentCell", bundle: nil), forCellReuseIdentifier: "treatmentCell")
        
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 25
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableViewAutomaticDimension
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tagsViewShown {
            return self.array_tblTags.count
        }
                
        return self.array_tbleJournal.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
       
        if tagsViewShown == true{
            let DataElement = self.array_tblTags[indexPath.row]
            
            let dataType = DataElement["type"] as! String
            switch dataType {
            case TagsCell.tags.rawValue:
                return tagsCell(tableView:tableView, cellForRowAt:indexPath)
            case TagsCell.tagEdit.rawValue:
                return tagEditCell(tableView:tableView, cellForRowAt:indexPath)
            case TagsCell.treatment.rawValue:
                return treatmentCell(tableView:tableView, cellForRowAt:indexPath)
            default:
                return journalsCell(tableView:tableView, cellForRowAt:indexPath)
            }
        }
        else{
            let DataElement = self.array_tbleJournal[indexPath.row]

            let dataType = DataElement["type"] as! String
            switch dataType {
            case JournalCell.AddCell.rawValue:
                return addJournalCell(tableView:tableView, cellForRowAt:indexPath)
            case JournalCell.JournalCell.rawValue:
                return journalsCell(tableView:tableView, cellForRowAt:indexPath)

            default:
                return journalsCell(tableView:tableView, cellForRowAt:indexPath)
            }
        }
            

   
    
        
    }
    func addJournalCell(tableView: UITableView, cellForRowAt indexPath: IndexPath)  -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "addJournalCell") as? addJournalCell
        cell?.Btn_sort.addTarget(self, action: #selector(showSortingPopup), for: .touchUpInside)
        cell?.Btn_AddNew.addTarget(self, action: #selector(Addnew), for: .touchUpInside)
        
        cell?.selectionStyle = .none
        return cell!
    }
    func journalsCell(tableView: UITableView, cellForRowAt indexPath: IndexPath)  -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "journalsCell") as? journalsCell
        cell?.editBtn.addTarget(self, action: #selector(showEditPopup), for: .touchUpInside)
        cell?.selectionStyle = .none
        return cell!
    }
    func tagsCell(tableView: UITableView, cellForRowAt indexPath: IndexPath)  -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tagsCell") as? tagsCell
        cell?.lblTagCount.layer.cornerRadius = (cell?.lblTagCount.bounds.size.width)!/2
        cell?.lblTagCount.layer.borderColor = UIColor.white.cgColor
        cell?.lblTagCount.layer.borderWidth = 1.0
        cell?.lblTagCount.layer.masksToBounds = true
        cell?.lblTagCount2.layer.cornerRadius = (cell?.lblTagCount.bounds.size.width)!/2
        cell?.lblTagCount2.layer.borderColor = UIColor.white.cgColor
        cell?.lblTagCount2.layer.borderWidth = 1.0
        cell?.lblTagCount2.layer.masksToBounds = true
        cell?.lblTagCount3.layer.cornerRadius = (cell?.lblTagCount.bounds.size.width)!/2
        cell?.lblTagCount3.layer.borderColor = UIColor.white.cgColor
        cell?.lblTagCount3.layer.borderWidth = 1.0
        cell?.lblTagCount3.layer.masksToBounds = true
        cell?.lblTagCount4.layer.cornerRadius = (cell?.lblTagCount.bounds.size.width)!/2
        cell?.lblTagCount4.layer.borderColor = UIColor.white.cgColor
        cell?.lblTagCount4.layer.borderWidth = 1.0
        cell?.lblTagCount4.layer.masksToBounds = true
        cell?.lblTagCount5.layer.cornerRadius = (cell?.lblTagCount.bounds.size.width)!/2
        cell?.lblTagCount5.layer.borderColor = UIColor.white.cgColor
        cell?.lblTagCount5.layer.borderWidth = 1.0
        cell?.lblTagCount5.layer.masksToBounds = true
        cell?.lblTagCount6.layer.cornerRadius = (cell?.lblTagCount.bounds.size.width)!/2
        cell?.lblTagCount6.layer.borderColor = UIColor.white.cgColor
        cell?.lblTagCount6.layer.borderWidth = 1.0
        cell?.lblTagCount6.layer.masksToBounds = true
        cell?.lblTagCount7.layer.cornerRadius = (cell?.lblTagCount.bounds.size.width)!/2
        cell?.lblTagCount7.layer.borderColor = UIColor.white.cgColor
        cell?.lblTagCount7.layer.borderWidth = 1.0
        cell?.lblTagCount7.layer.masksToBounds = true
        cell?.lblTagCount8.layer.cornerRadius = (cell?.lblTagCount.bounds.size.width)!/2
        cell?.lblTagCount8.layer.borderColor = UIColor.white.cgColor
        cell?.lblTagCount8.layer.borderWidth = 1.0
        cell?.lblTagCount8.layer.masksToBounds = true
        cell?.lblTagCount9.layer.cornerRadius = (cell?.lblTagCount.bounds.size.width)!/2
        cell?.lblTagCount9.layer.borderColor = UIColor.white.cgColor
        cell?.lblTagCount9.layer.borderWidth = 1.0
        cell?.lblTagCount9.layer.masksToBounds = true
        cell?.selectionStyle = .none
        return cell!
    }
    func tagEditCell(tableView: UITableView, cellForRowAt indexPath: IndexPath)  -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tagEditCell") as? tagEditCell
        cell?.selectionStyle = .none
        return cell!
    }
    func treatmentCell(tableView: UITableView, cellForRowAt indexPath: IndexPath)  -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "treatmentCell") as? treatmentCell
        cell?.selectionStyle = .none
        return cell!
    }
    func showSortingPopup(sender : UIButton){
        let viewMain = self.storyboard?.instantiateViewController(withIdentifier: "sortVC") as! sortVC
        
        self.navigationController?.popoverPresentationController?.backgroundColor = UIColor.red
        viewMain.showPopover(withNavigationController: sender, sourceRect: sender.bounds)
        
    }
    
    func Addnew(sender : UIButton) {
        self.PushViewWithIdentifier(name: "NewJournalVC")
    }
    func showEditPopup(sender : UIButton){
        let viewMain = self.storyboard?.instantiateViewController(withIdentifier: "editJournalPopupVC") as! editJournalPopupVC
        
        self.navigationController?.popoverPresentationController?.backgroundColor = UIColor.red
        viewMain.showPopover(withNavigationController: sender, sourceRect: sender.bounds)
        
    }

}
class addJournalCell :UITableViewCell{

    @IBOutlet weak var Btn_sort: UIButton!
    @IBOutlet weak var Btn_AddNew: UIButton!
    
}
class journalsCell :UITableViewCell{
    
    @IBOutlet weak var editBtn: UIButton!
    
}
class tagsCell: UITableViewCell{
    @IBOutlet weak var lblTagCount: UILabel!
    @IBOutlet weak var lblTagCount2: UILabel!
    @IBOutlet weak var lblTagCount3: UILabel!
    @IBOutlet weak var lblTagCount4: UILabel!
    @IBOutlet weak var lblTagCount5: UILabel!
    @IBOutlet weak var lblTagCount6: UILabel!
    @IBOutlet weak var lblTagCount7: UILabel!
    @IBOutlet weak var lblTagCount8: UILabel!
    @IBOutlet weak var lblTagCount9: UILabel!
    
}
class tagEditCell: UITableViewCell{
    
}
class treatmentCell: UITableViewCell{
    
}


