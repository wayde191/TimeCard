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
    @IBOutlet weak var tabviewContainer: UIView!
    @IBOutlet weak var pagecontrolView: UIPageControl!
    
    var holderView = HolderView(frame: CGRectZero)
    
    var counter = 0
    var oneAppCounter = 0
    
    var memberArr: NSArray? = []
    let members: NSArray = ["Li Xufei",
        "Zhang Mingyun",
        "Cao Yangyang",
        "Chen Yu Wuhan Dev",
        "Xu Jiang Dev",
        "Gu Chao",
        "Sun Wei Wayde",
        "Wang Tianyi",
        "Chen Ting",
        "Li Hongjing"]
    var domElementModel: DomElement?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textLabel.delegate = self
        self.domElementModel = DomElement.init(name: "SalesForce", webview: self.webview)
        
        self.checkAccountInfo() ? self.refresh() : self.gotoAccountViewController()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: Public Methods
    func refresh() {
        counter = 0
        self.addHolderView()
        self.setStage(Stage.ready)
        self.domElementModel?.updateUserInfo()
        webview.loadRequest(NSURLRequest(URL: NSURL(string: SALESFORCE_LOGIN_URL)!))
    }
    
    func gotoAccountViewController() {
        self.performSegueWithIdentifier("AccountViewControllerIdentifier", sender: self)
    }
    
    func analyzeDone() {
        self.setStage(Stage.done)
    }
    
    func animateLabel() {
        holderView.removeFromSuperview()
        self.showResult()
        
        tabviewContainer.transform = CGAffineTransformScale(tabviewContainer.transform, 0.25, 0.25)
        UIView.animateWithDuration(0.4, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.1, options: UIViewAnimationOptions.CurveEaseInOut,
            animations: ({
                self.view.bringSubviewToFront(self.tabviewContainer)
                self.tabviewContainer.transform = CGAffineTransformScale(self.tabviewContainer.transform, 4.0, 4.0)
            }), completion: { finished in
                print("Done")
        })
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
        self.tableview.reloadData()
    }
    
    private func getSalesforceVerifacationCode() {
        let alert = UIAlertController.init(title: "Salesforce Verification Code", message: "Please input your verification which Salesforce send to you via email.", preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addTextFieldWithConfigurationHandler { (textField) -> Void in
            textField.textColor = Colors.TCBlue
            textField.placeholder = "Please input your code"
        }
        
        alert.addAction(UIAlertAction.init(title: "Sure", style: UIAlertActionStyle.Destructive,
            handler: { (alertAction) -> Void in
                let code = alert.textFields?.first?.text
                if ((code?.isEmpty) == true) {
                    self.getSalesforceVerifacationCode()
                } else {
                    self.domElementModel?.doVerificate(code!)
                }
        }))

        self.presentViewController(alert, animated: true) { () -> Void in
            
        }
    }
    
    //MARK: HolderView
    func addHolderView() {
        let boxSize: CGFloat = 100.0
        holderView.frame = CGRect(
            x: view.bounds.width / 2 - boxSize / 2,
            y: textLabel.frame.origin.y + 150,
            width: boxSize,
            height: boxSize)
        holderView.parentFrame = view.frame
        holderView.delegate = self
        stateView.addSubview(holderView)
    }
    
    //MARK: Animation
    func setStage(stage: String) {
        self.textLabel.text = stage
        switch stage {
        case Stage.ready:
            holderView.addOval()
            holderView.ovalLayer.fillColor = Colors.LightSkyBlue.CGColor
            break
        case Stage.login:
            pagecontrolView.currentPage = 1
            holderView.ovalLayer.fillColor = Colors.SkyBlue.CGColor
            break
        case Stage.search:
            pagecontrolView.currentPage = 2
            holderView.ovalLayer.fillColor = Colors.DeepSkyBlue.CGColor
            break
        case Stage.project:
            pagecontrolView.currentPage = 3
            holderView.ovalLayer.fillColor = Colors.DodgerBlue.CGColor
            break
        case Stage.timecard:
            pagecontrolView.currentPage = 4
            holderView.ovalLayer.fillColor = Colors.RoyalBlue.CGColor
            break
        case Stage.done:
            pagecontrolView.currentPage = 5
            holderView.ovalLayer.fillColor = Colors.TCBlue.CGColor
            holderView.stopOval()
            holderView.drawBlueAnimatedRectangle()
            break
        default:
            break
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
        print("shouldStartLoadWithRequest: \(rurl)")
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
        } else if ((rurl?.containsString(SALESFORCE_VER_URL)) == true) {
            self.getSalesforceVerifacationCode()
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

