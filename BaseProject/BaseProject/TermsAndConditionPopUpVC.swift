//
//  TermsAndConditionPopUpVC.swift
//  BaseProject
//
//  Created by MN on 28/09/2018.
//  Copyright © 2018 Wave. All rights reserved.
//

import UIKit


class TermsAndConditionPopUpVC: ViewController {

    @IBOutlet weak var lb_text_display: UITextView!
    @IBOutlet var webView: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
            var texttt : String =
                "<b ><font color=#0083cb>What is a Privacy Policy, Exactly?</font> </b>\n" +
                    "A privacy policy is a document that discloses to your website visitors what you will do with any information gathered about them, how you are gathering that information and how the information will be stored, managed and protected. It fulfills a legal requirement in many countries & jurisdictions to protect your user's privacy.\n" +
                    "\n" +
                    "<b ><font color=#0083cb>Why Can't I Use a Template Privacy Policy?</font> </b>\n" +
                    "Copying & pasting an example privacy policy might be OK... or it could be worse, far worse, than having no policy at all. What if it contains misleading or inaccurate information?\n" +
                    "\n" +
                    "Your privacy policy needs to be tailored to your website. If you simply \"borrow\" a template or generic privacy policy, it could provide misleading information.\n" +
                    "\n" +
                    "<b><font color=#0083cb>But I Don't Collect Personal Data...\n</font> </b>" +
                    "If you run a website in 2017, you almost certainly collect personal data - even if you are unaware of it. And ignorance is no excuse for complying with the law.\n" +
                    "\n" +
                    "As a general \"rule of thumb\", any website that...\n" +
                    "- Tracks visitor numbers (eg, Google Analytics)\n" +
                    "- Collects any personal data (eg, email addresses for a newsletter)\n" +
                    "- Shows advertising (eg, Google AdSense)\n" +
                    "- Takes online payments (Like PayPal or credit cards)\n" +
                    "- Uses cookies\n" +
                    "- Has user accounts\n" +
                    "\n<b ><font color=#0083cb>How to Create a Privacy Policy ASAP</font> </b>\n" +
                    "Generating a privacy policy for your website can be confusing and time-consuming. Worse, hiring an attorney to do the same thing will likely cost you $1000+.\n" +
                    "\n" +
                    "There's no one-size-fits-all policy template (no matter what our competitors say!), and your privacy policy needs to be tailored to your website to do the job right.\n" +
                    "\n" +
                    "With our privacy policy generator, you don't need to hire an expensive attorney or roll the dice on \"borrowing\" somebody else's template or copying & pasting a generic privacy policy.\n" +
                    "\n" +
                    "We can help you generate a customized privacy policy in around three minutes.\n" +
                    "\n" +
                    "<b ><font color=#0083cb>Any Questions?</font> </b>\n" +
            "Please check our FAQ";
        

        let bundlePath = Bundle.main.bundlePath
        let url = URL(fileURLWithPath: bundlePath)
        let htmlFile = Bundle.main.path(forResource: "termcond", ofType: "html")
        if !(htmlFile?.isEmpty)!{
            let html = try? String(contentsOfFile: htmlFile!, encoding: String.Encoding.utf8)
            webView.loadHTMLString(html!, baseURL: url)
        }

        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func agreeAction(sender: UIButton!){
        let userDefaults = UserDefaults.standard
        userDefaults.setValue("0", forKey: "firstView")
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "HideHelpPage"), object: nil)
    }
    
    @IBAction func disAgreeAction(sender: UIButton!){
        exit(0)
    }
    
}
