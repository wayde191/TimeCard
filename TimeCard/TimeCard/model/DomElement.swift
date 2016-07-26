//
//  DomElement.swift
//  TimeCard
//
//  Created by Wei Wayde Sun on 7/14/16.
//  Copyright © 2016 iHakula. All rights reserved.
//

import Foundation
import UIKit

extension NSRange {
    func rangeForString(str: String) -> Range<String.Index>? {
        guard location != NSNotFound else { return nil }
        return str.startIndex.advancedBy(location) ..< str.startIndex.advancedBy(location + length)
    }
}

class DomElement: NSObject {
    var name: String
    var webview: UIWebView
    var timecardHTML = ""
    
    var ud_username: String?
    var ud_password: String?
    var ud_pname: String?
    var ud_poname: String?
    
    init(name: String, webview: UIWebView) {
        self.name = name
        self.webview = webview
    }
    
    func updateUserInfo() {
        ud_username = STANDER_USER_DEFAULT.objectForKey(USERNAME_UD_KEY) as? String
        ud_password = STANDER_USER_DEFAULT.objectForKey(SECRET_UD_KEY) as? String
        ud_pname = STANDER_USER_DEFAULT.objectForKey(PROJECT_NAME_UD_KEY) as? String
        ud_poname = STANDER_USER_DEFAULT.objectForKey(PROJECT_ONAME_UD_KEY) as? String
    }
    
    func getAllInfo(text: String) -> NSArray {
        let members = NSMutableArray()
        
        let lastMon = NSDate.getLastMondayStr()
        
        let arr = text.componentsSeparatedByString("dark actionable uiInfiniteListRow forceActionRow forceListRecord forceRecordLayout")
        for record in arr {
            if record.containsString(lastMon) {
                do {
                    let rows = record.componentsSeparatedByString("tableRowGroup")
                    var contextStr = ""
                    for context in rows {
                        if context.containsString("Resource:") {
                            contextStr = context
                            break
                        }
                    }
                    
                    let input:String = contextStr.stringByReplacingOccurrencesOfString("\\\"", withString: "")
                    let regex = try NSRegularExpression(pattern: "forceOutputLookup\">(.*)</span>", options: NSRegularExpressionOptions.CaseInsensitive)
                    let matches = regex.matchesInString(input, options: [], range: NSRange(location: 0, length: input.utf16.count))
                    if let match = matches.first {
                        let range = match.rangeAtIndex(1)
                        if let swiftRange = range.rangeForString(input) {
                            let name = input.substringWithRange(swiftRange)
                            members.addObject(name)
                        }
                    }
                } catch {
                    // regex was bad!
                }
            }
        }
        return members
    }
    
    func doLogin() {
        let script = "document.getElementById('password').value='"
            + ud_password! + "';"
            + "document.getElementById('Login').click();"
        self.webview.stringByEvaluatingJavaScriptFromString(script)
    }
    
    func searchProject() {
        self.webview.stringByEvaluatingJavaScriptFromString(
            "var ele = document.getElementsByClassName('searchInputField')[0];"
                + "ele.value = '" + ud_pname! + "';"
                + "ele.focus();var ke3 = document.createEvent('Events');ke3.initEvent('keypress', true, true);ke3.keyCode = ke3.which = 13;        ele.dispatchEvent(ke3);")
    }
    
    func clickRelated() {
        self.webview.stringByEvaluatingJavaScriptFromString("document.getElementsByClassName('nav-container')[0].getElementsByTagName('a')[1].click()")
    }
    
    func clickRelatedTimeCard() {
        self.webview.stringByEvaluatingJavaScriptFromString("document.getElementsByClassName('forceRelatedListCard')[3].click()")
    }
    
    func getListHtml() {
        let html = self.webview.stringByEvaluatingJavaScriptFromString("document.getElementsByClassName('listContent')[1].getElementsByTagName('ul')[0].innerHTML");
        self.timecardHTML = html!
    }
    
    func getProjectIndex() -> Int {
        var index = 0
        
        let html = self.webview.stringByEvaluatingJavaScriptFromString("document.getElementsByClassName('listContent')[0].innerHTML");
        var arr = html!.componentsSeparatedByString("light actionable uiInfiniteListRow forceActionRow forceListRecord forceRecordLayout")
        arr.removeAtIndex(0)
        
        for project in arr {
            if project.containsString(ud_pname!) && project.containsString(ud_poname!) {
                index = arr.indexOf(project)!
            }
        }
        
        return index
    }
    
    func clickProjectFound() {
        let projectIndex = getProjectIndex()
        
        self.webview.stringByEvaluatingJavaScriptFromString("document.getElementsByClassName('listContent')[0].getElementsByClassName('light')[\(projectIndex)].getElementsByClassName('body')[0].getElementsByTagName('a')[0].click()")
    }
    
    func clickProjectItem() {
        self.webview.stringByEvaluatingJavaScriptFromString("document.getElementsByClassName('selectorItem')[1].getElementsByTagName('a')[0].click()")
    }
    
    func clickToggleNavButton() {
        self.webview.stringByEvaluatingJavaScriptFromString("document.getElementsByClassName('toggleNav')[0].click();")
    }
    
    func clickProject() {
        self.webview.stringByEvaluatingJavaScriptFromString("document.getElementsByTagName('ul')[2].getElementsByTagName('li')[0].getElementsByTagName('a')[0].click();")
    }
    
    func triggerEvent(selectorName: String, afterDelay: Double) {
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(afterDelay * Double(NSEC_PER_SEC)))
        
        dispatch_after(delayTime, dispatch_get_main_queue()) {
            self.performSelector(NSSelectorFromString(selectorName))
        }
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