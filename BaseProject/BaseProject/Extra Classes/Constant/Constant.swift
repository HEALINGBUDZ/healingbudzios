//
//  Constant.swift
//  Shir
//

//

import Foundation
import UIKit

let kEmptyString = ""
let kEmptyInt = 0
let kEmptyDouble = 0.0
let kEmptyBoolean = false

extension UIColor {
    
    convenience init(red: CGFloat, green: CGFloat, blue: CGFloat) {
        self.init(red: red / 255, green: green / 255, blue: blue / 255, alpha: 1)
    }
    
    convenience init(hexColor: String) {
        var red: UInt32 = 0, green: UInt32 = 0, blue: UInt32 = 0
        
        let hex = hexColor as NSString
        Scanner(string: hex.substring(with: NSRange(location: 0, length: 2))).scanHexInt32(&red)
        Scanner(string: hex.substring(with: NSRange(location: 2, length: 2))).scanHexInt32(&green)
        Scanner(string: hex.substring(with: NSRange(location: 4, length: 2))).scanHexInt32(&blue)
        self.init(red: CGFloat(red)/255.0, green: CGFloat(green)/255.0, blue: CGFloat(blue)/255.0, alpha: 1.0)
    }
    
}
struct Constants {
    // Constants to call services to server
    static let kTagColor = UIColor.init(hexColor: "6d96ad")
    static let kBlackColor = UIColor.init(red: 0.6901, green: 0.6901, blue: 0.6901, alpha: 1.0)
    static let kBorderColor = UIColor.lightGray

    
	static let kNavigationcolor = UIColor.init(red: 0.1647, green: 0.5882, blue: 0.9176, alpha: 1.0)
	
    static let kPlaceholderColor = UIColor.gray
    
    static let kCornerRaious : CGFloat = 5.0
    
    
    
    static var deviceToken = "DummyToken"
    static var ShareLinkConstant = "https://healingbudz.com/"
    static var defaultDateFormate = "yyyy-MM-dd HH:mm:ss"
    static var SeeMore  = "- See More"
    static var DeepLinkConstant = "healingbudz.com"

}



struct ConstantsColor {
    

    static let kUnder100Color = UIColor.init(red: (255/255), green: (255/255), blue: (255/255), alpha: 1.0)
    static let kUnder200Color = UIColor.init(red: (123/255), green: (192/255), blue: (67/255), alpha: 1.0)
    static let kUnder300Color = UIColor.init(red: (237/255), green: (191/255), blue: (46/255), alpha: 1.0)
    static let kUnder400Color = UIColor.init(red: (232/255), green: (150/255), blue: (6/255), alpha: 1.0)

    static let kUnder500Color = UIColor.init(red: (224/255), green: (112/255), blue: (224/255), alpha: 1.0)

    static var gradiant_first_colro = UIColor(red:174.0/255.0, green:89.0/255.0, blue:194.0/255.0, alpha:1.000).cgColor
    static var gradiant_second_colro = UIColor(red:194.0/255.0, green:68.0/255.0, blue:98.0/255.0, alpha:1.000).cgColor
    static let kBudzSelectColor = UIColor.init(red: (153/255), green: (45/255), blue: (127/255), alpha: 1.0)
    static let kBudzUnselectColor = UIColor.init(red: (92/255), green: (92/255), blue: (92/255), alpha: 1.0)
    static let kStrainSelectColor = UIColor.init(red: (244/255), green: (196/255), blue: (47/255), alpha: 1.0)
    static let kHomeColor = UIColor.init(red: 0.490, green: 0.745, blue: 0.298, alpha: 1.0)
    static let kQuestionColor = UIColor.init(red: 0.075, green: 0.416, blue: 0.612, alpha: 1.0)
    static let kJournalColor = UIColor.init(red: 0.345, green: 0.541, blue: 0.259, alpha: 1.0)
    static let kGroupColor = UIColor.init(red: 0.667, green: 0.404, blue: 0.196, alpha: 1.0)
    static let kStrainColor = UIColor.init(red:0.957, green:0.769, blue:0.290, alpha:1.000)
    static let kStrainGreenColor = UIColor.init(red:(124/255), green:(194/255), blue:(68/255), alpha:1.000)
    static let kStrainRedColor = UIColor.init(red:(194/255), green:(68/255), blue:(98/255), alpha:1.000)
    static let kStrainPurpleColor = UIColor.init(red:(174/255), green:(89/255), blue:(194/255), alpha:1.000)
    static let kBudzColor = UIColor.init(red:0.420, green:0.114, blue:0.396, alpha:1.000)
    static let kDarkGrey = UIColor(red: 0.165, green: 0.165, blue: 0.165, alpha: 1.0)
    static let KLightGrayColor = UIColor.init(hexColor: "555555")
}

//MARK:- Numbers
let kZero: CGFloat = 0.0
let kOne: CGFloat = 1.0
let kHalf: CGFloat = 0.5
let kTwo: CGFloat = 2.0
let kHundred: CGFloat = 100.0
let kDefaultAnimationDuration = 0.3


struct StoryBoardConstant {
    
    static let QA           = "QAStoryBoard"
    static let Profile      = "ProfileView"
    static let Budz         = "BudzStoryBoard"
    static let Main         = "Main"
    static let Reward         = "Rewards"
    static let SurveyStrain         = "SurveyStoryBoard"
    
}
//MARK:- Messages

struct Alert {
    
    static let kEmptyCredentails    = "Please provide your credentails to proceed!"
    static let kWrongEmail          = "Incorrect email format. Please provide a valid email address!"
	static let kEmptyEmail          = "Email address is missing!"
	static let kEmptyPassword       = "Password is missing!"
	static let kPasswordNotMatch    = "Password not match with confirm password!"
	static let kUserNameMissing     = "UserName is missing!"
	static let kUserImageMissing     = "User image is missing!"
}

let kErrorTitle                     = "Error!"
let kInformationMissingTitle        = "Information Missing!"
let kOKBtnTitle                     = "OK"
let kCancelBtnTitle                 = "Cancel"
let kDismissBtnTitle                = "Dismiss"
let kTryAgainBtnTitle               = "Try Again!"

let kDescriptionHere                = "Description Here..."

var kNetworkNotAvailableMessage = "It appears that you are not connected with internet. Please check your internet connection and try again."
//var kServerNotReachableMessage = "We are unable to connect our server at the moment. Please check your device internet settings or try later."
var kServerNotReachableMessage = "Network not Available!"

//"Network not Available!"
var kFacebookSigninFailedMessage = "We are unable to get your identity from Facebook. Please check your Facebook profile settings and then try again."


struct Notifications{
    
   static let googleSignInNotification = "Google_SignIn_Notificaiton"
}

enum DataType: String {
	case Image				= "0"

}

enum StrainSurveyType: String {
    case Medical                    = "0"
    case Mood                       = "1"
    case Disease                    = "2"
    case Negative                   = "4"
    case Flavor                     = "3"
    
}
enum ActivityLog:String {
    case strainAdd          = "0"
    case followingBud       = "1"
    case QuestionAsked      = "2"
    case Answered           = "3"
    case Liked              = "4"
    case Favourites         = "5"
    case AddedJournal       = "6"
    case StartedJournal     = "7"
    case CreatedGroup       = "8"
    case JoinedGroup        = "9"
    case FollowingTags      = "10"
    case JoinedHealingBud   = "11"
    case Random             = "12"
    case Comment            = "13"
    case Post               = "14"
    case Tags               = "15"
    
    
}
enum StrainDataType: String {
    case Header                 = "0"
    case ButtonChoose			= "1"
    case Description			= "2"
    case SurveyResult			= "3"
    case DetailSurvey			= "4"
    case TextWithImage			= "5"
    case ImageSubmit			= "6"
    case ReviewTotal			= "7"
    case CommentCell			= "8"
    case AddYourcomment			= "9"
    case AddImage               = "10"
    case ShowImage              = "11"
    case AddRating              = "12"
    case TellExperience			= "13"
    case SubmitComment			= "14"
    
    case LocateThisBud			= "15"
    case NearStrain             = "16"
    case StrainBud              = "17"
    
    case StrainAddInfo          = "18"
    case StrainShowDes          = "19"
    case StrainShowType         = "20"
    case StrainShowCrossBreed   = "21"
    case chemistryCell          = "22"
    case StrainShowCare         = "23"
    case StrainShowEditHeading  = "24"
    case StrainShowUserEdit     = "25"
    case EmptyBlankCell     = "29"
    case googleAdd     =          "26"
    case nosurvay     =          "27"
    case addplace     =          "28"
    case noFullSurvay =          "30"
}


enum AddNewStrain: String {

    case HeaderView         = "0"
    case ImageUpload        = "1"
    case AddInfo            = "2"
    case AddType            = "3"
    case AddBreed           = "4"
    case Chemistry          = "5"
    case AddCare            = "6"
    case AddNotes           = "7"
    case Submit             = "8"
}



enum StrainFilter: String {
    
    case NameKeyword            = "0"
    case StrainMatchingText     = "1"
    case Button                 = "2"
    case FilterBy               = "3"
    case TextFieldSearch        = "4"
}


enum  JournalListing : String {
    case ExpandCell = "0"
    case DetailCell = "1"
    case LineCell   = "2"
}
enum JournalCell : String{
    case AddCell     = "0"
    case JournalCell = "1"
    
}
enum TagsCell : String{
    case tags       = "0"
    case tagEdit    = "1"
    case treatment  = "2"
    
}
enum mainSettingCell: String{
    case normalCell = "0"
    case switchCell = "1"
}
enum businessListingSettings: String{
    case titleCell      = "0"
    case premiumCell    = "1"
    case billingCell    = "2"
    case amountCell     = "3"
    case mybusinessCell = "4"
}
enum journalSettings: String{
    case quickEntryCell      = "0"
    case reminderCell        = "1"
    case dataCell            = "2"

}
enum notifications_Alerts: String{
    case mainHeadingCell        = "0"
    case notificationCell       = "1"
    case subHeadingCell         = "2"
    case notificationCell2      = "3"
    case keywordCell              = "4"
    
}
enum profileSettings: String{
    case profileSettingsTitleCell                     = "0"
    case profileSettingsDetailCell                    = "1"
    case profileSettingsEmailCell                     = "2"
    case profileSettingsMedicalConditionsCell         = "3"
    case profileSettingsUserInfo                      = "4"
    case profileBudzInfo                              = "5"
    case profileButton                                = "6"
    case isQACell                                     = "7"
    case QACell                                       = "8"
    case AnswerCell                                   = "9"
    case StrainHeadingCell                            = "10"
    case BudzHeadingCell                              = "12"
    case StrainCell                                   = "11"
    case BudzCell                                     = "13"
    case StrainReview                                 = "14"
    case BudzReview                                   = "15"
    case TextPostCell                                 = "16"
    case MediaPostCell                                = "17"
    case NoRecordFound                                = "18"
    case LoadingMore                                = "19"
}
enum reminderSettings: String{
    case reminderSettingsSwitchCell  = "0"
    case reminderSettingsTimerCell   = "1"
}
enum dataSettings : String{
    case dataSettingsWifiCell           = "0"
    case dataSettingsSyncNotification   = "1"
    case dataSettingsBackupCell         = "2"
}

struct ScreenSize
{
    static let SCREEN_WIDTH         = UIScreen.main.bounds.size.width
    static let SCREEN_HEIGHT        = UIScreen.main.bounds.size.height
    static let SCREEN_MAX_LENGTH    = max(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
    static let SCREEN_MIN_LENGTH    = min(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
}

struct DeviceType
{
    static let IS_IPHONE_4_OR_LESS  = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH < 568.0
    static let IS_IPHONE_5          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 568.0
      static let IS_IPHONE_5_OR_LESS          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH <= 568.0
    static let IS_IPHONE_6_7          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 667.0
    static let IS_IPHONE_6P_7P         = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 736.0
    static let IS_IPAD              = UIDevice.current.userInterfaceIdiom == .pad && ScreenSize.SCREEN_MAX_LENGTH == 1024.0
    static let IS_IPAD_PRO          = UIDevice.current.userInterfaceIdiom == .pad && ScreenSize.SCREEN_MAX_LENGTH == 1366.0
}


enum BudzIcon : String{
    case Dispencery               = "DispensaryIcon"
    case Entertainment           = "EntertainmentIcon"
    case Event                  = "EventsIcon"
    case Cannabites           = "CannabitesIcon"
    case Medical           = "MedicalIcon"
    case Others             = "OthersIcon"
}


enum BudzMapDataType: String {
    case Header                = "0"
    case MenuButton            = "1"
    case BudzDescription       = "2"
    case Location              = "3"
    case WeekHours             = "4"
    case WebsiteLinks          = "5"
    case PaymentMethods        = "6"
    case TotalReviews          = "7"
    case UserReview            = "8"
    case AddReviewTextview     = "9"
    case AddReviewImage        = "10"
    case ImageView             = "11"
    case AddRating             = "12"
    case SubmitActionButton    = "13"
    case ReviewHeading         = "14"
    case Languages         = "15"
    case HeadingWithText         = "16"
    case BudzEventTime         = "17"
    case BudzSpecial             = "18"
    case BudzProduct             = "19"
    case BudzService             = "20"
    case NoRecord             = "21"
     case NoRecordtext             = "23"
    case addYourComment        = "22"
     case addSpecial        = "30"
    case eventTicktes        = "31"
    case eventPaymentMethods        = "32"
     case evnetPurchaseTicketCell        = "33"
     case addProductServices             = "244"
     case addNewEvent             = "54"
    case othersImage            = "35"
}


enum NewBudzMapDataType: String {
    case Header              = "0"
    case MenuButton          = "1"
    case Heading             = "2"
    case BudzType            = "3"
    case EnterText           = "4"
    case Location            = "5"
    case Contact             = "6"
    case HoursofOpreation    = "7"
    case SubmitButton        = "8"
    case AddLanguage         = "9"
    case ShowLanguage        = "10"
    case InsuranceAccepted   = "11"
    case AddRating           = "12"
    case EventTime           = "13"
    case Payment             = "14"
    case UploadButton       = "15"
    case OtherAttachment    = "16"
    
}

