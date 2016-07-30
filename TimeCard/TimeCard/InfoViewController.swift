//
//  InfoViewController.swift
//  TimeCard
//
//  Created by Wei Wayde Sun on 7/30/16.
//  Copyright © 2016 iHakula. All rights reserved.
//

import Foundation

import UIKit

class InfoViewController: UIViewController, UITextFieldDelegate {
    
    @IBAction func onCancelButtonClicked(sender: AnyObject) {
        self.gobackToHomeVC()
    }
    
    func gobackToHomeVC() {
        self.dismissViewControllerAnimated(true) { () -> Void in
            
        }
    }
    
    
}