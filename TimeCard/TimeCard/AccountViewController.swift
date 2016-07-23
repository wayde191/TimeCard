//
//  AccountViewController.swift
//  TimeCard
//
//  Created by Wei Wayde Sun on 7/23/16.
//  Copyright © 2016 iHakula. All rights reserved.
//

import UIKit

class AccountViewController: UIViewController {
    
    
    var homeVC: ViewController?
    
    @IBOutlet weak var projectOwnerTF: UITextField!
    @IBOutlet weak var projectNameTF: UITextField!
    @IBOutlet weak var secretTF: UITextField!
    @IBOutlet weak var usernameTF: UITextField!
    
    @IBAction func onCancelButtonClicked(sender: AnyObject) {
        self.dismissViewControllerAnimated(true) { () -> Void in
            
        }
    }
    
    @IBAction func onSaveButtonClicked(sender: AnyObject) {
        self.dismissViewControllerAnimated(true) { () -> Void in
            print(self.homeVC)
        }
    }
}
