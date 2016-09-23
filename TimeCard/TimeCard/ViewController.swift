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
    @IBOutlet weak var dateLabel: UILabel!
    
    var holderView = HolderView(frame: CGRect.zero)
    
    var counter = 0
    var oneAppCounter = 0
    
    var memberArr: NSArray? = []
    var domElementModel: DomElement?
    var isRunning: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textLabel.delegate = self
        self.domElementModel = DomElement.init(name: "SalesForce", webview: self.webview)
        self.dateLabel.text = "Start Date: " + Date.getLastMondayStr()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if isRunning == false {
            isRunning = true
            self.checkAccountInfo() ? self.refresh() : self.gotoAccountViewController()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: Public Methods
    @IBAction func onRefreshButtonClicked(_ sender: AnyObject) {
        self.refresh()
    }
    
    func refresh() {
        counter = 0
        self.addHolderView()
        self.setStage(Stage.ready)
        self.domElementModel?.updateUserInfo()
        webview.loadRequest(URLRequest(url: URL(string: SALESFORCE_LOGIN_URL)!))
    }
    
    func gotoAccountViewController() {
        self.performSegue(withIdentifier: "AccountViewControllerIdentifier", sender: self)
    }
    
    func analyzeDone() {
        self.setStage(Stage.done)
    }
    
    func animateLabel() {
        holderView.removeFromSuperview()
        self.showResult()
        
        tabviewContainer.transform = tabviewContainer.transform.scaledBy(x: 0.25, y: 0.25)
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.1, options: UIViewAnimationOptions(),
            animations: ({
                self.view.bringSubview(toFront: self.tabviewContainer)
                self.tabviewContainer.transform = self.tabviewContainer.transform.scaledBy(x: 4.0, y: 4.0)
            }), completion: { finished in
                print("Done")
        })
    }
    
    //MARK: Private Methods
    
    fileprivate func checkAccountInfo() -> Bool {
        var result = true
        
        if STANDER_USER_DEFAULT.object(forKey: USERNAME_UD_KEY) == nil {
            result = false;
        } else if STANDER_USER_DEFAULT.object(forKey: SECRET_UD_KEY) == nil {
            result = false;
        } else if STANDER_USER_DEFAULT.object(forKey: PROJECT_ONAME_UD_KEY) == nil {
            result = false;
        } else if STANDER_USER_DEFAULT.object(forKey: PROJECT_NAME_UD_KEY) == nil {
            result = false;
        }
        
        return result
    }
    
    fileprivate func showResult() {
        memberArr = self.domElementModel?.getAllInfo((self.domElementModel?.timecardHTML)! as String)
        print(memberArr)
        self.tableview.reloadData()
    }
    
    fileprivate func getSalesforceVerifacationCode() {
        let alert = UIAlertController.init(title: "Salesforce Verification Code", message: "Please input your verification which Salesforce send to you via email.", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addTextField { (textField) -> Void in
            textField.textColor = Colors.TCBlue
            textField.placeholder = "Please input your code"
        }
        
        alert.addAction(UIAlertAction.init(title: "Sure", style: UIAlertActionStyle.destructive,
            handler: { (alertAction) -> Void in
                let code = alert.textFields?.first?.text
                if ((code?.isEmpty) == true) {
                    self.getSalesforceVerifacationCode()
                } else {
                    self.domElementModel?.doVerificate(code!)
                }
        }))

        self.present(alert, animated: true) { () -> Void in
            
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
    func setStage(_ stage: String) {
        self.textLabel.text = stage
        switch stage {
        case Stage.ready:
            holderView.addOval()
            holderView.ovalLayer.fillColor = Colors.LightSkyBlue.cgColor
            break
        case Stage.login:
            pagecontrolView.currentPage = 1
            holderView.ovalLayer.fillColor = Colors.SkyBlue.cgColor
            break
        case Stage.search:
            pagecontrolView.currentPage = 2
            holderView.ovalLayer.fillColor = Colors.DeepSkyBlue.cgColor
            break
        case Stage.project:
            pagecontrolView.currentPage = 3
            holderView.ovalLayer.fillColor = Colors.DodgerBlue.cgColor
            break
        case Stage.timecard:
            pagecontrolView.currentPage = 4
            holderView.ovalLayer.fillColor = Colors.RoyalBlue.cgColor
            break
        case Stage.done:
            pagecontrolView.currentPage = 5
            holderView.ovalLayer.fillColor = Colors.TCBlue.cgColor
            holderView.stopOval()
            holderView.drawBlueAnimatedRectangle()
            break
        default:
            break
        }
    }
    
    //MARK: UITableView DataSource and Delegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memberArr!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "identtifier"
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier)
        if(cell == nil){
            cell = UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: identifier)
        }
        
        let member = memberArr![(indexPath as NSIndexPath).row] as? String
        cell?.textLabel?.text = member
        cell?.accessoryType = UITableViewCellAccessoryType.checkmark
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: UIWebView Delegate
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool{
//        let rurl =  request.URL?.absoluteString
//        print("shouldStartLoadWithRequest: \(rurl)")
        return true
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView){
        let rurl =  webView.request?.url?.absoluteString
        
        if rurl == SALESFORCE_LOGIN_URL {
            counter += 1
            if counter == 5 {
                self.setStage(Stage.login)
                domElementModel?.doLogin()
            }
        } else if ((rurl?.contains(SALESFORCE_VER_URL)) == true) {
            self.getSalesforceVerifacationCode()
        } else if rurl == SALESFORCE_ONE_APP_URL {
            oneAppCounter += 1
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
                                                                
                                                                self.perform(NSSelectorFromString("analyzeDone"), with: nil, afterDelay: 4.0)

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
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        let rurl =  webView.request?.url?.absoluteString
        print("didFailLoadWithError: \(rurl)")
    }
    
    //MARK: Segue
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination.isKind(of: AccountViewController.self) {
            let accountVC = segue.destination as! AccountViewController
            accountVC.homeVC = self
        }
    }
    
}

