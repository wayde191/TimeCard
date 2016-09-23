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
    
    @IBAction func onCancelButtonClicked(_ sender: AnyObject) {
        self.gobackToHomeVC()
    }
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBAction func onSaveButtonClicked(_ sender: AnyObject) {
        if self.checkRequiredFields() {
            self.updateUserDefault()
            self.dismiss(animated: true) { () -> Void in
                self.homeVC?.refresh()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.syncUserDefault()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.scrollView.contentSize = CGSize.init(width: self.scrollView.contentSize.width, height: 800)
    }
    
    func syncUserDefault() {
        usernameTF.text = UserDefaults.standard.object(forKey: USERNAME_UD_KEY) as! String?
        secretTF.text = UserDefaults.standard.object(forKey: SECRET_UD_KEY) as! String?
        projectNameTF.text = UserDefaults.standard.object(forKey: PROJECT_NAME_UD_KEY) as! String?
        projectOwnerTF.text = UserDefaults.standard.object(forKey: PROJECT_ONAME_UD_KEY) as! String?
    }
    
    func updateUserDefault() {
        UserDefaults.standard.set(usernameTF.text, forKey: USERNAME_UD_KEY)
        UserDefaults.standard.set(secretTF.text, forKey: SECRET_UD_KEY)
        UserDefaults.standard.set(projectNameTF.text, forKey: PROJECT_NAME_UD_KEY)
        UserDefaults.standard.set(projectOwnerTF.text, forKey: PROJECT_ONAME_UD_KEY)
        UserDefaults.standard.synchronize()
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
        self.dismiss(animated: true) { () -> Void in
            
        }
    }
    
    func showAlertMessage(_ message: String) {
        let alert = UIAlertController.init(title: nil, message: message, preferredStyle: UIAlertControllerStyle.alert)
        self.present(alert, animated: true) { () -> Void in
            self.perform(NSSelectorFromString("gobackToHomeVC"), with: nil, afterDelay: 1.3)
        }
    }
}
