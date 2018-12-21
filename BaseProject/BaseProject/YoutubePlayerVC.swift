//
//  YoutubePlayerVC.swift
//  BaseProject
//

//  Copyright © 2018 Wave. All rights reserved.
//

import UIKit
import YouTubePlayer
extension UIApplication {
    var statusBarView: UIView? {
        if responds(to: Selector(("statusBar"))) {
            return value(forKey: "statusBar") as? UIView
        }
        return nil
    }
}
extension String
{
    
    var url:URL?{
        return URL(string: self)
    }
    
    var thumbnailImage:String {
        return "http://img.youtube.com/vi/\(self)/0.jpg"
    }
    
    var youtubeVideo: String {
        return "http://www.youtube.com/embed/\(self)"
    }
    
    var getIDfromLink:String? {
        var result:String? = nil
        
        if let theURL = self.url {
            if theURL.host == "youtu.be" {
                result = theURL.pathComponents[1]
            } else if theURL.absoluteString.contains("www.youtube.com/embed") {
                result = theURL.pathComponents[2]
            } else if theURL.host == "youtube.googleapis.com" ||
                theURL.pathComponents.first == "www.youtube.com" {
                result = theURL.pathComponents[2]
            } else {
                result = theURL.absoluteString
            }
        }
        return result
    }
    
    var isValidURL:Bool {
        if let _url = self.url {
            return _url.scheme != ""
        }
        return false
    }
    
    func addBaseURL(_ theURL:String) -> String {
        if self.isValidURL { return self }
        
        // No check for now, just prepending the base url as passed
        return theURL + self
    }
    
    var stringByDecodingURL:String {
        let result = self
            .replacingOccurrences(of: "+", with: " ")
            .removingPercentEncoding
        return result!
    }
    
    
}
extension String{
    var getYoutube_IDfromLink:String? {
        var result:String? = nil
        if let theURL = self.url {
            if theURL.host == "youtu.be" {
                result = theURL.pathComponents[1]
            } else if theURL.absoluteString.contains("www.youtube.com/embed") {
                result = theURL.pathComponents[2]
            } else if theURL.host == "youtube.googleapis.com" ||
                theURL.pathComponents.first == "www.youtube.com" {
                result = theURL.pathComponents[2]
            } else {
                if theURL.host == "www.youtube.com"{
                    var id = theURL.absoluteString.components(separatedBy: "=")
                    if id.count > 1 {
                      result = id[id.count-1]
                    }
                }else{
                    result = theURL.absoluteString
                }
                
            }
        }
        return result
    }
}
class YoutubePlayerVC: BaseViewController , YouTubePlayerDelegate {
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    var videoURL : URL = URL.init(string: "www.youtube.com")!
    class func PlayerVC(url : URL)->YoutubePlayerVC
    {
        let me = YoutubePlayerVC(nibName: String(describing: YoutubePlayerVC.self), bundle: nil)
        me.videoURL = url
        return me
    }
    
    @IBOutlet weak var youtube_video_img: UIImageView!
    @IBOutlet var playerView: YouTubePlayerView!
    override func viewDidLoad() {
        super.viewDidLoad()
        playerView.playerVars = [
            "playsinline": "1" as AnyObject,
            "controls": "1" as AnyObject,
            "autoplay": "1" as AnyObject,
            "showinfo": "0" as AnyObject,
            "autohide":"0" as AnyObject,
            "modestbranding":"0" as AnyObject,
            "rel":0 as AnyObject
        ]
        playerView.backgroundColor = .black
        playerView.loadVideoURL(self.videoURL)
        playerView.delegate = self
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func onClickCross(_ sender: Any) {
        self.playerView.pause()
        self.playerView.clear()
        self.playerView.stop()
        isfromYoutubePlayer = true
        self.dismiss(animated: false, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let thumb_url =  "https://img.youtube.com/vi/" + (self.videoURL.absoluteString.getYoutube_IDfromLink!) + "/0.jpg"
        print(thumb_url)
        self.youtube_video_img.sd_addActivityIndicator()
        self.youtube_video_img.sd_showActivityIndicatorView()
        self.youtube_video_img.sd_setImage(with: URL(string:thumb_url))
        self.navigationController?.navigationBar.isHidden=true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden=false
    }
    func playerReady(_ videoPlayer: YouTubePlayerView) {
        self.indicator.isHidden = true
        self.youtube_video_img.isHidden = true
         print(videoPlayer.getDuration() ?? "null")
        if self.viewIfLoaded?.window != nil {
            videoPlayer.play()
        }else{
            self.playerView.pause()
            self.playerView.clear()
            self.playerView.stop()
        }
    }
    
    
}
