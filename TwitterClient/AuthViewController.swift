//
//  AuthViewController.swift
//  TwitterClient
//
//  Created by Hoi Pham Ngoc on 3/24/16.
//  Copyright © 2016 John Pham. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class AuthViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onLoginByTwitter(sender: AnyObject) {
        let twitterClient = BDBOAuth1SessionManager(baseURL: NSURL(string: "http://api.twitter.com")!, consumerKey: "dQqHiuBXSVjQUYszrEN0V8JkW", consumerSecret: "yyYzKcHgEySk94WJ6mTecgkl2A1hYPoBaBcB5p3QdXEmgykJ0f")
        twitterClient.deauthorize()
        
        twitterClient.fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: nil, scope: nil, success: { (requestToken: BDBOAuth1Credential!) -> Void in
            print("I got a token")
            }) { (error: NSError!) -> Void in
                print("Error: \(error.localizedDescription)")
        }
        
        
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
