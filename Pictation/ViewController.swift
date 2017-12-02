//
//  ViewController.swift
//  HelpViewController
//
//  Created by Ashmit Ahuja on 2017-11-26.
//  Copyright © 2017 Ashmit Ahuja. All rights reserved.
//

import UIKit
import Foundation
import MessageUI

class ViewController: UIViewController, MFMailComposeViewControllerDelegate {
    
    
    @IBAction func DiscussionLink(_ sender: UIButton) {
        
        if let url = NSURL(string:"https://sites.google.com/site/cmpt275project08pictation/"){
            UIApplication.shared.open(url as URL)
        }
    }
    
    @IBAction func SendAction(_ sender: UIButton) {
        let mailComposeViewController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            self.present(mailComposeViewController, animated: true, completion: nil)
        }else{
            self.showSendMailErrorAlert()
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Settings.sharedValues.viewBackgroundColor
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        mailComposerVC.setToRecipients(["edleung@sfu.ca", "aahuja@sfu.ca", "jamesonr@sfu.ca", "meihuiy@sfu.ca","bentonk@sfu.ca"])
        
        mailComposerVC.setSubject("Pictation - User Messages")
        mailComposerVC.setMessageBody("This is the message body", isHTML: false)
        
        return mailComposerVC
    }
    
    
    func showSendMailErrorAlert() {
        
        let sendMailErrorAlert = UIAlertController(title: "Could not send email", message: "Your device must have an active mail account", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "OK", style: .cancel)
        
        sendMailErrorAlert.addAction(cancelAction)
        
    }
    
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }



}

