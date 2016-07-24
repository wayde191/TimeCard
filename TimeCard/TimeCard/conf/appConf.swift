//
//  appConf.swift
//  TimeCard
//
//  Created by Wei Wayde Sun on 7/15/16.
//  Copyright © 2016 iHakula. All rights reserved.
//

import Foundation
import UIKit

let SALESFORCE_LOGIN_URL    = "https://login.salesforce.com/"
let SALESFORCE_ONE_APP_URL  = "https://na32.lightning.force.com/one/one.app"

let USERNAME_UD_KEY         = "UsernameUserDefaultKey"
let SECRET_UD_KEY           = "SecretUserDefaultKey"
let PROJECT_NAME_UD_KEY     = "ProjectNameUserDefaultKey"
let PROJECT_ONAME_UD_KEY    = "ProjectOwnerNameUserDefaultKey"


let STANDER_USER_DEFAULT    = NSUserDefaults.standardUserDefaults()

struct Stage {
    static let ready = "Ready, Go!"
    static let login = "Logging into Salesforce..."
    static let search = "Searching for your project..."
    static let project = "Project matching..."
    static let timecard = "Analyzing timecard..."
    static let done = "Done!"
}
