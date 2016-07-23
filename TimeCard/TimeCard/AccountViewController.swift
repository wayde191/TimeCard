//
//  AccountViewController.swift
//  TimeCard
//
//  Created by Wei Wayde Sun on 7/23/16.
//  Copyright © 2016 iHakula. All rights reserved.
//

import UIKit

class AccountViewController: UIViewController, UITextFieldDelegate {
    
    
    var homeVC: ViewController?
    
    @IBOutlet weak var projectOwnerTF: UITextField!
    @IBOutlet weak var projectNameTF: UITextField!
    @IBOutlet weak var secretTF: UITextField!
    @IBOutlet weak var usernameTF: UITextField!
    
    @IBAction func onCancelButtonClicked(sender: AnyObject) {
        self.gobackToHomeVC()
    }
    
    @IBAction func onSaveButtonClicked(sender: AnyObject) {
        if self.checkRequiredFields() {
            self.updateUserDefault()
            self.dismissViewControllerAnimated(true) { () -> Void in
                self.homeVC?.refresh()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.syncUserDefault()
    }
    
    func syncUserDefault() {
        usernameTF.text = NSUserDefaults.standardUserDefaults().objectForKey(USERNAME_UD_KEY) as! String?
        secretTF.text = NSUserDefaults.standardUserDefaults().objectForKey(SECRET_UD_KEY) as! String?
        projectNameTF.text = NSUserDefaults.standardUserDefaults().objectForKey(PROJECT_NAME_UD_KEY) as! String?
        projectOwnerTF.text = NSUserDefaults.standardUserDefaults().objectForKey(PROJECT_ONAME_UD_KEY) as! String?
    }
    
    func updateUserDefault() {
        NSUserDefaults.standardUserDefaults().setObject(usernameTF.text, forKey: USERNAME_UD_KEY)
        NSUserDefaults.standardUserDefaults().setObject(secretTF.text, forKey: SECRET_UD_KEY)
        NSUserDefaults.standardUserDefaults().setObject(projectNameTF.text, forKey: PROJECT_NAME_UD_KEY)
        NSUserDefaults.standardUserDefaults().setObject(projectOwnerTF.text, forKey: PROJECT_ONAME_UD_KEY)
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    func checkRequiredFields() -> Bool {
        var isValidate = true
        
        if ((usernameTF.text?.isEmpty) == true) {
            isValidate = false
            usernameTF.becomeFirstResponder()
            self.showAlertMessage("UserName is required.")
            
        } else if ((secretTF.text?.isEmpty) == true) {
            isValidate = false
            secretTF.becomeFirstResponder()
            self.showAlertMessage("Secret key is required.")
            
        } else if ((projectNameTF.text?.isEmpty) == true) {
            isValidate = false
            projectNameTF.becomeFirstResponder()
            self.showAlertMessage("Project name is required.")
            
        } else if ((projectOwnerTF.text?.isEmpty) == true) {
            isValidate = false
            projectOwnerTF.becomeFirstResponder()
            self.showAlertMessage("Project owner name is required.")
        }
        
        return isValidate
    }
    
    func gobackToHomeVC() {
        self.dismissViewControllerAnimated(true) { () -> Void in
            
        }
    }
    
    func showAlertMessage(message: String) {
        let alert = UIAlertController.init(title: nil, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        self.presentViewController(alert, animated: true) { () -> Void in
            self.performSelector(NSSelectorFromString("gobackToHomeVC"), withObject: nil, afterDelay: 1.3)
        }
    }
}
