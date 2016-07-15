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
    
    func doLogin() {
        let script = "document.getElementById('password').value='????';"
            + "document.getElementById('Login').click();"
        self.webview.stringByEvaluatingJavaScriptFromString(script)
    }
    
    func triggerEvent(selectorName: String, afterDelay: Double) {
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(afterDelay * Double(NSEC_PER_SEC)))
        
        dispatch_after(delayTime, dispatch_get_main_queue()) {
            self.performSelector(NSSelectorFromString(selectorName))
        }
    }
    
    func searchProject() {
        self.webview.stringByEvaluatingJavaScriptFromString(
            "var ele = document.getElementsByClassName('searchInputField')[0];ele.value = 'demand';ele.focus();var ke3 = document.createEvent('Events');ke3.initEvent('keypress', true, true);ke3.keyCode = ke3.which = 13;        ele.dispatchEvent(ke3);")
    }
    
    func clickRelated() {
        self.webview.stringByEvaluatingJavaScriptFromString("document.getElementsByClassName('nav-container')[0].getElementsByTagName('a')[1].click()")
    }
    
    func clickRelatedTimeCard() {
        self.webview.stringByEvaluatingJavaScriptFromString("document.getElementsByClassName('forceRelatedListCard')[3].click()")
    }
    
    func getListHtml() {
        let html = self.webview.stringByEvaluatingJavaScriptFromString("document.getElementsByClassName('listContent')[1].getElementsByTagName('ul')[0].innerHTML");
        print(html)
    }
    
    func clickProjectFound() {
        self.webview.stringByEvaluatingJavaScriptFromString("document.getElementsByClassName('listContent')[0].getElementsByClassName('light')[1].getElementsByClassName('body')[0].getElementsByTagName('a')[0].click()")
    }
    
    func clickProjectItem() {
        self.webview.stringByEvaluatingJavaScriptFromString("document.getElementsByClassName('selectorItem')[1].getElementsByTagName('a')[0].click()")
    }
    
    func clickToggleNavButton() {
        self.webview.stringByEvaluatingJavaScriptFromString("document.getElementsByClassName('toggleNav')[0].click();")
    }
    
    func clickMore() {
        self.webview.stringByEvaluatingJavaScriptFromString("document.getElementsByTagName('ul')[2].getElementsByTagName('li')[1].getElementsByTagName('a')[0].click();")
    }
    
    func clickProject() {
        self.webview.stringByEvaluatingJavaScriptFromString("document.getElementsByTagName('ul')[2].getElementsByTagName('li')[0].getElementsByTagName('a')[0].click();")
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