//
//  Constants.swift
//  BackSpace
//
//  Created by Khaled Rahman Ayon on 07/02/2018.
//  Copyright © 2018 Khaled Rahman Ayon. All rights reserved.
//

import Foundation
import Firebase

//database reference to firebase
let DB_BASE = Database.database().reference()
//storage reference to firebase
let STORAGE = Storage.storage().reference()

typealias handler = (_ success: Bool, _ error: Error?) -> ()

//StoryBoard ids
let AUTH_VC = "AuthVC"
let LOGIN_VC = "LoginVC"
let GROUP_FEED_VC = "GroupFeedVC"

