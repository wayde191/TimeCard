//
//  ViewController.swift
//  TimeCard
//
//  Created by Wei Wayde Sun on 7/12/16.
//  Copyright © 2016 iHakula. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIWebViewDelegate {

    @IBOutlet weak var webview: UIWebView!
    @IBOutlet weak var tableview: UITableView!
    
    var counter = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webview.loadRequest(NSURLRequest(URL: NSURL(string: "https://login.salesforce.com")!))
        
        print(NSDate.getTodayWeekStr())
        print(NSDate.get(.Next, "Sunday", considerToday:  true))
        print(NSDate.get(.Previous, "Thursday", considerToday:  true))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: UITableView DataSource and Delegate
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        return 55
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let identifier = "identtifier"
        var cell = tableView.dequeueReusableCellWithIdentifier(identifier)
        if(cell == nil){
            cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: identifier)
        }
        
        cell?.textLabel?.text = "TEXT"
        cell?.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    //MARK: UIWebView Delegate
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool{
        let rurl =  request.URL?.absoluteString
        print(rurl)
        if (rurl!.hasPrefix("ios:")){
            let method =  rurl!.componentsSeparatedByString("@")[1]
            if method == "signin_go"{
                signin_go()
            }
            return false
        }
        return true
    }
    
    func webViewDidFinishLoad(webView: UIWebView){
        let rurl =  webView.request?.URL?.absoluteString
        print(rurl)
//        let bodyHTML = webView.stringByEvaluatingJavaScriptFromString("document.getElementsByTagName('html')[0].innerHTML")
//        print(bodyHTML)
        
        if rurl == "https://login.salesforce.com/"
        {
            let script = "document.getElementById('password').value='????';"
                + "document.getElementById('Login').click();"
            counter++
            print(counter)
            if counter == 5
            {
                webView.stringByEvaluatingJavaScriptFromString(script)
            }
        }
        
        
    }
    
    func signin_go(){
        NSLog("-我执行了signin_go-")
    }
    
}

