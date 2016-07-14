//
//  DomElement.swift
//  TimeCard
//
//  Created by Wei Wayde Sun on 7/14/16.
//  Copyright © 2016 iHakula. All rights reserved.
//

import Foundation
import UIKit

class DomElement: NSObject {
    var name: String
    var webview: UIWebView
    
    init(name: String, webview: UIWebView) {
        self.name = name
        self.webview = webview
    }
    
    func clickToggleNavButton() {
        self.webview.stringByEvaluatingJavaScriptFromString("document.getElementsByClassName('toggleNav')[0].click();")
    }
    
    func clickMore() {
        self.webview.stringByEvaluatingJavaScriptFromString("document.getElementsByTagName('ul')[2].getElementsByTagName('li')[1].getElementsByTagName('a')[0].click();")
    }
    
    func findElementByClassNameUntil(className: String, var timesLeft: Int8, callback: (Bool) -> ()){
        var isFound = false
        
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(3 * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) {
            
            let htmlStr = self.webview.stringByEvaluatingJavaScriptFromString("document.getElementsByTagName('HTML')[0].innerHTML")
            
            isFound = (htmlStr?.containsString(className))!
            if isFound == true {
                callback(true)
            } else {
                if timesLeft > 0 {
                    timesLeft--
                    self.findElementByClassNameUntil(className, timesLeft: timesLeft, callback: callback)
                } else {
                    callback(false)
                }
            }
        }
    }
}