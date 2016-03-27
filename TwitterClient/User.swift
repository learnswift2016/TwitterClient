//
//  User.swift
//  TwitterClient
//
//  Created by Hoi Pham Ngoc on 3/24/16.
//  Copyright © 2016 John Pham. All rights reserved.
//

import UIKit

var _currentUser: User?
let currentUserKey = "kCurrentUserKey"
let userDidLoginNotification = "userDidLoginNotification"
let userDidLogoutNotification = "userDidLogoutNotification"


struct User {
    var name: String?
    var screenName: String?
    var profileImageUrl: String?
    var tagline: String?
    var dictionary: NSDictionary
    
    static var currentUser: User? {
        get {
            if _currentUser == nil {
                if let data = NSUserDefaults.standardUserDefaults().objectForKey(currentUserKey) as? NSData {
                    do {
                        let dictionary = try NSJSONSerialization.JSONObjectWithData(data, options: .MutableLeaves) as! NSDictionary
                        _currentUser = User(dictionary: dictionary)
                    } catch {
                        print("Error creating user from dictionary: \(error)")
                    }
                }
            }
            return _currentUser
        }
        set(user) {
            _currentUser = user
            
            if let cuser = _currentUser {
                do {
                    let data = try NSJSONSerialization.dataWithJSONObject(cuser.dictionary, options: .PrettyPrinted)
                    NSUserDefaults.standardUserDefaults().setObject(data, forKey: currentUserKey)
                } catch {
                    print("Error parsing JSON: \(error)")
                }
            } else {
                NSUserDefaults.standardUserDefaults().setObject(nil, forKey: currentUserKey)
            }
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    
    
    }
    init(dictionary: NSDictionary) {
        self.dictionary = dictionary
        
        name = dictionary["name"] as? String
        screenName = dictionary["screen_name"] as? String
        profileImageUrl = dictionary["profile_image_url_https"] as? String
        profileImageUrl = profileImageUrl?.stringByReplacingOccurrencesOfString("_normal", withString: "")
        tagline = dictionary["description"] as? String
    }
    
    func logout() {
        User.currentUser = nil
        TwitterClientAPI.sharedInstance.requestSerializer.removeAccessToken()
        
        NSNotificationCenter.defaultCenter().postNotificationName(userDidLogoutNotification, object: nil)
    }
    
    
    
}