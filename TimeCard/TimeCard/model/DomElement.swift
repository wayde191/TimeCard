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
    func rangeForString(_ str: String) -> Range<String.Index>? {
        guard location != NSNotFound else { return nil }
        return str.characters.index(str.startIndex, offsetBy: location) ..< str.characters.index(str.startIndex, offsetBy: location + length)
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
        ud_username = STANDER_USER_DEFAULT.object(forKey: USERNAME_UD_KEY) as? String
        ud_password = STANDER_USER_DEFAULT.object(forKey: SECRET_UD_KEY) as? String
        ud_pname = STANDER_USER_DEFAULT.object(forKey: PROJECT_NAME_UD_KEY) as? String
        ud_poname = STANDER_USER_DEFAULT.object(forKey: PROJECT_ONAME_UD_KEY) as? String
    }
    
    func getAllInfo(_ text: String) -> NSArray {
        let members = NSMutableArray()
        let lastMon = Date.getLastMondayStr()
        
        let arr = text.components(separatedBy: "dark actionable uiInfiniteListRow forceActionRow forceListRecord forceRecordLayout")
        for record in arr {
            if record.contains(lastMon) {
                do {
                    let rows = record.components(separatedBy: "tableRowGroup")
                    var contextStr = ""
                    for context in rows {
                        if context.contains("Resource:") {
                            contextStr = context
                            break
                        }
                    }
                    
                    let input:String = contextStr.replacingOccurrences(of: "\\\"", with: "")
                    let regex = try NSRegularExpression(pattern: "forceOutputLookup\">(.*)</span>", options: NSRegularExpression.Options.caseInsensitive)
                    let matches = regex.matches(in: input, options: [], range: NSRange(location: 0, length: input.utf16.count))
                    if let match = matches.first {
                        let range = match.rangeAt(1)
                        if let swiftRange = range.rangeForString(input) {
                            let name = input.substring(with: swiftRange)
                            members.add(name)
                        }
                    }
                } catch {
                    // regex was bad!
                }
            }
        }
        return members
    }
    
    func doVerificate(_ code: String) {
        let fillCode = "document.getElementById('emc').value='" + code + "';"
        let clickVerify = "document.getElementById('save').click();"
        self.webview.stringByEvaluatingJavaScript(from: fillCode + clickVerify)
    }
    
    func doLogin() {
        let fillPasswordScript = "document.getElementById('password').value='" + ud_password! + "';"
        let fillUsernameScript = "document.getElementById('username').value='" + ud_username! + "';"
        let clickLoginScript = "document.getElementById('Login').click();"
        self.webview.stringByEvaluatingJavaScript(from: fillUsernameScript + fillPasswordScript + clickLoginScript)
    }
    
    func searchProject() {
        self.webview.stringByEvaluatingJavaScript(
            from: "var ele = document.getElementsByClassName('searchInputField')[0];"
                + "ele.value = '" + ud_pname! + "';"
                + "ele.focus();var ke3 = document.createEvent('Events');ke3.initEvent('keypress', true, true);ke3.keyCode = ke3.which = 13;        ele.dispatchEvent(ke3);")
    }
    
    func clickRelated() {
        self.webview.stringByEvaluatingJavaScript(from: "document.getElementsByClassName('nav-container')[0].getElementsByTagName('a')[1].click()")
    }
    
    func clickRelatedTimeCard() {
        self.webview.stringByEvaluatingJavaScript(from: "document.getElementsByClassName('forceRelatedListCard')[3].click()")
    }
    
    func getListHtml() {
        let html = self.webview.stringByEvaluatingJavaScript(from: "document.getElementsByClassName('listContent')[1].getElementsByTagName('ul')[0].innerHTML");
        self.timecardHTML = html!
    }
    
    func getProjectIndex() -> Int {
        var index = 0
        
        let html = self.webview.stringByEvaluatingJavaScript(from: "document.getElementsByClassName('listContent')[0].innerHTML");
        var arr = html!.components(separatedBy: "light actionable uiInfiniteListRow forceActionRow forceListRecord forceRecordLayout")
        arr.remove(at: 0)
        
        for project in arr {
            if project.contains(ud_pname!) && project.contains(ud_poname!) {
                index = arr.index(of: project)!
            }
        }
        
        return index
    }
    
    func clickProjectFound() {
        let projectIndex = getProjectIndex()
        
        self.webview.stringByEvaluatingJavaScript(from: "document.getElementsByClassName('listContent')[0].getElementsByClassName('light')[\(projectIndex)].getElementsByClassName('body')[0].getElementsByTagName('a')[0].click()")
    }
    
    func clickProjectItem() {
        self.webview.stringByEvaluatingJavaScript(from: "document.getElementsByClassName('selectorItem')[1].getElementsByTagName('a')[0].click()")
    }
    
    func clickToggleNavButton() {
        self.webview.stringByEvaluatingJavaScript(from: "document.getElementsByClassName('toggleNav')[0].click();")
    }
    
    func clickProject() {
        self.webview.stringByEvaluatingJavaScript(from: "document.getElementsByTagName('ul')[2].getElementsByTagName('li')[0].getElementsByTagName('a')[0].click();")
    }
    
    func triggerEvent(_ selectorName: String, afterDelay: Double) {
        let delayTime = DispatchTime.now() + Double(Int64(afterDelay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        
        DispatchQueue.main.asyncAfter(deadline: delayTime) {
            self.perform(NSSelectorFromString(selectorName))
        }
    }
    
    func findElementByClassNameUntil(_ className: String, timesLeft: Int8, callback: @escaping (Bool) -> ()){
        var timesLeft = timesLeft
        var isFound = false
        
        let delayTime = DispatchTime.now() + Double(Int64(3 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: delayTime) {
            
            let htmlStr = self.webview.stringByEvaluatingJavaScript(from: "document.getElementsByTagName('HTML')[0].innerHTML")
            
            isFound = (htmlStr?.contains(className))!
            if isFound == true {
                callback(true)
            } else {
                if timesLeft > 0 {
                    timesLeft -= 1
                    self.findElementByClassNameUntil(className, timesLeft: timesLeft, callback: callback)
                } else {
                    callback(false)
                }
            }
        }
    }
}
