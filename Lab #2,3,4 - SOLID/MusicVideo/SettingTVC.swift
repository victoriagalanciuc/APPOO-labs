//
//  SettingTVC.swift
//  MusicVideo
//
//  Created by Victoria on 7/10/18.
//  Copyright © 2018 Victoria. All rights reserved.
//


import UIKit
import MessageUI

class SettingTVC: UITableViewController, MFMailComposeViewControllerDelegate {

    
    @IBOutlet weak var aboutDisplay: UILabel!
    
    @IBOutlet weak var feedBackDisplay: UILabel!
    
    
    @IBOutlet weak var securityDisplay: UILabel!
    
    
    @IBOutlet weak var touchID: UISwitch!
    
    
    @IBOutlet weak var bestImageDisplay: UILabel!
    
    // added two new fields to UI
    
    @IBOutlet weak var numberOfVideosDisplay: UILabel!
    
    @IBOutlet weak var dragTheSliderDIsplay: UILabel!
    
    //
    
    @IBOutlet weak var APICnt: UILabel!
    
    
    @IBOutlet weak var sliderCnt: UISlider!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        #if swift(>=2.2)
        NotificationCenter.default.addObserver(self, selector: #selector(SettingTVC.preferredFontChange), name: NSNotification.Name.UIContentSizeCategoryDidChange, object: nil)
        #else
             NSNotificationCenter.defaultCenter().addObserver(self, selector: "preferredFontChange", name: UIContentSizeCategoryDidChangeNotification, object: nil)
        #endif
        
        
        
        tableView.alwaysBounceVertical = false
        
        //change from settings to Settings
        title = "Settings"
        
        touchID.isOn = UserDefaults.standard.bool(forKey: "SecSetting")
        
        if (UserDefaults.standard.object(forKey: "APICNT") != nil)
        {
            let theValue = UserDefaults.standard.object(forKey: "APICNT") as! Int
            APICnt.text = "\(theValue)"
            sliderCnt.value = Float(theValue)
        } else {
            sliderCnt.value = 10.0
            APICnt.text = ("\(Int(sliderCnt.value))")
        }

        

    }
    
    @IBAction func valueChanged(_ sender: Any) {
        let defaults = UserDefaults.standard
        defaults.set(Int(sliderCnt.value), forKey: "APICNT")
        APICnt.text = ("\(Int(sliderCnt.value))")
    }
    
    @IBAction func touchIdSec(_ sender: Any) {
        let defaults = UserDefaults.standard
        if touchID.isOn {
            defaults.set(touchID.isOn, forKey: "SecSetting")
            
        }
        else
        {
            defaults.set(false, forKey: "SecSetting")
        }
    }
    
    
    

    func preferredFontChange() {
        
        aboutDisplay.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.subheadline)
        feedBackDisplay.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.subheadline)
        securityDisplay.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.subheadline)
        bestImageDisplay.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.subheadline)
        APICnt.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.subheadline)
        
        // added two new fields to UI
        
        numberOfVideosDisplay.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.subheadline)
        dragTheSliderDIsplay.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.footnote)
      
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.section == 0 && indexPath.row == 1 {
            
            let mailComposeViewController = configureMail()
            
            if MFMailComposeViewController.canSendMail() {
                self.present(mailComposeViewController,  animated: true, completion: nil)
            }
            else
            {
                // No email account Setup on Phone
                mailAlert()
            }
            tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        }
        
        
        
    }
    
    func configureMail() -> MFMailComposeViewController {
        
        let mailComposeVC = MFMailComposeViewController()
        mailComposeVC.mailComposeDelegate = self
        mailComposeVC.setToRecipients(["mrudowsky@me.com"])
        mailComposeVC.setSubject("Music Video App Feedback")
        mailComposeVC.setMessageBody("Hi Michael,\n\nI would like to share the following feedback...\n", isHTML: false)
        return mailComposeVC
    }
    
    
    func mailAlert() {
        
        let alertController: UIAlertController = UIAlertController(title: "Alert", message: "No e-Mail Account setup for Phone", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Ok", style: .default) { action -> Void in
            //do something if you want
        }
        
        alertController.addAction(okAction)
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        
        
//        switch result.rawValue {
//        case MFMailComposeResultCancelled.rawValue:
//            print("Mail cancelled")
//        case MFMailComposeResultSaved.rawValue:
//            print("Mail saved")
//        case MFMailComposeResultSent.rawValue:
//            print("Mail sent")
//        case MFMailComposeResultFailed.rawValue:
//            print("Mail Failed")
//        default:
//            print("Unknown Issue")
//        }
        self.dismiss(animated: true, completion: nil)}
    
    
    
    
    
    
    
    
    
    
    
    
    // Is called just as the object is about to be deallocated
    deinit
    {
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIContentSizeCategoryDidChange, object: nil)
    }
    
    
}
