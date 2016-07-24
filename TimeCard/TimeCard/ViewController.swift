//
//  ViewController.swift
//  TimeCard
//
//  Created by Wei Wayde Sun on 7/12/16.
//  Copyright © 2016 iHakula. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIWebViewDelegate, LTMorphingLabelDelegate, HolderViewDelegate {

    @IBOutlet weak var webview: UIWebView!
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var webviewContainer: UIView!
    @IBOutlet weak var textLabel: LTMorphingLabel!
    @IBOutlet weak var stateView: UIView!
    
    var holderView = HolderView(frame: CGRectZero)
    
    var counter = 0
    var oneAppCounter = 0
    
    var memberArr: NSArray? = []
    let members: NSArray = ["Li Xufei",
        "Zhang Mingyun",
        "Cao Yangyang",
        "Chen Yu Wuhan Dev",
        "Gu Chao",
        "Wang Zhi Tupi",
        "Sun Wei Wayde",
        "Wang Tianyi",
        "Chen Ting",
        "Li Hongjing"]
    var domElementModel: DomElement?
    
    func animateLabel() {
        // 1
        holderView.removeFromSuperview()
        stateView.backgroundColor = Colors.blue
        
        // 2
        let label: UILabel = UILabel(frame: view.frame)
        label.textColor = Colors.white
        label.font = UIFont(name: "HelveticaNeue-Thin", size: 170.0)
        label.textAlignment = NSTextAlignment.Center
        label.text = "S"
        label.transform = CGAffineTransformScale(label.transform, 0.25, 0.25)
        stateView.addSubview(label)
        
        // 3
        UIView.animateWithDuration(0.4, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.1, options: UIViewAnimationOptions.CurveEaseInOut,
            animations: ({
                label.transform = CGAffineTransformScale(label.transform, 4.0, 4.0)
            }), completion: { finished in
                print("Done")
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textLabel.delegate = self
        self.domElementModel = DomElement.init(name: "SalesForce", webview: self.webview)
        
        self.checkAccountInfo() ? self.refresh() : self.gotoAccountViewController()
        
        print(NSDate.getTodayWeekStr())
        print(NSDate.get(.Next, "Sunday", considerToday:  true))
        print(NSDate.get(.Previous, "Thursday", considerToday:  true))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: Public Methods
    func refresh() {
        self.addHolderView()
        self.setStage(Stage.ready)
        webview.loadRequest(NSURLRequest(URL: NSURL(string: SALESFORCE_LOGIN_URL)!))
    }
    
    func gotoAccountViewController() {
        self.performSegueWithIdentifier("AccountViewControllerIdentifier", sender: self)
    }
    
    func analyzeDone() {
        self.setStage(Stage.done)
    }
    
    //MARK: Private Methods
    
    private func checkAccountInfo() -> Bool {
        var result = true
        
        if STANDER_USER_DEFAULT.objectForKey(USERNAME_UD_KEY) == nil {
            result = false;
        } else if STANDER_USER_DEFAULT.objectForKey(SECRET_UD_KEY) == nil {
            result = false;
        } else if STANDER_USER_DEFAULT.objectForKey(PROJECT_ONAME_UD_KEY) == nil {
            result = false;
        } else if STANDER_USER_DEFAULT.objectForKey(PROJECT_NAME_UD_KEY) == nil {
            result = false;
        }
        
        return result
    }
    
    private func showResult() {
        memberArr = self.domElementModel?.getAllInfo((self.domElementModel?.timecardHTML)! as String)
        self.webviewContainer.hidden = true
        self.tableview.reloadData()
    }
    
    //MARK: HolderView
    func addHolderView() {
        let boxSize: CGFloat = 200.0
        holderView.frame = CGRect(x: view.bounds.width / 2 - boxSize / 2,
            y: view.bounds.height / 2 - boxSize / 2,
            width: boxSize,
            height: boxSize)
        holderView.parentFrame = stateView.frame
        holderView.delegate = self
        stateView.addSubview(holderView)
    }
    
    //MARK: Animation
    func setStage(stage: String) {
        self.textLabel.text = stage
        if stage == Stage.ready {
            holderView.addOval()
        } else if stage == Stage.done {
            holderView.stopOval()
            holderView.drawArc()
        }
    }
    
    //MARK: UITableView DataSource and Delegate
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return members.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let identifier = "identtifier"
        var cell = tableView.dequeueReusableCellWithIdentifier(identifier)
        if(cell == nil){
            cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: identifier)
        }
        
        let member = members[indexPath.row] as? String
        cell?.textLabel?.text = member
        
        if (memberArr!.containsObject(member!)) {
            cell?.accessoryType = UITableViewCellAccessoryType.Checkmark
            cell?.backgroundColor = UIColor.whiteColor()

        } else {
            cell?.backgroundColor = UIColor.redColor()
            cell?.accessoryType = UITableViewCellAccessoryType.None
        }
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    //MARK: UIWebView Delegate
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool{
        let rurl =  request.URL?.absoluteString
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
        
        if rurl == SALESFORCE_LOGIN_URL {
            counter++
            print(counter)
            if counter == 5 {
                self.setStage(Stage.login)
                domElementModel?.doLogin()
            }
        } else if rurl == SALESFORCE_ONE_APP_URL {
            oneAppCounter++
            if 1 == oneAppCounter
            {
                self.setStage(Stage.search)
                domElementModel?.findElementByClassNameUntil("toggleNav", timesLeft: 5,
                    callback: { (result: Bool) -> () in
                        if result == true {
                            self.domElementModel?.searchProject()
                            self.domElementModel?.findElementByClassNameUntil("selectorItem", timesLeft: 5,
                                callback: { (found) -> () in
                                    if found == true {
                                        self.setStage(Stage.project)
                                        self.domElementModel?.clickProjectItem()
                                        self.domElementModel?.findElementByClassNameUntil("listContent", timesLeft: 5,
                                            callback: { (found) -> () in
                                                if found == true {
                                                    self.setStage(Stage.timecard)
                                                    self.domElementModel?.clickProjectFound()
                                                    self.domElementModel?.findElementByClassNameUntil("nav-container", timesLeft: 5,
                                                        callback: { (found) -> () in
                                                            if found == true {
                                                                self.domElementModel?.clickRelated()
                                                                self.domElementModel?.triggerEvent("clickRelatedTimeCard", afterDelay: 1)
                                                                self.domElementModel?.triggerEvent("getListHtml", afterDelay: 3)
                                                                
                                                                self.performSelector(NSSelectorFromString("analyzeDone"), withObject: nil, afterDelay: 4.0)

                                                            }
                                                    })
                                                }
                                        })
                                    }
                            })
                        }
                })
            }
        }
    }
    
    func webView(webView: UIWebView, didFailLoadWithError error: NSError?) {
        let rurl =  webView.request?.URL?.absoluteString
        print(rurl)
        print(error?.userInfo)
    }

    
    func signin_go(){
        NSLog("-我执行了signin_go-")
    }
    
    //MARK: Segue
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        return true
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.destinationViewController.isKindOfClass(AccountViewController) {
            let accountVC = segue.destinationViewController as! AccountViewController
            accountVC.homeVC = self
        }
    }
    
}

