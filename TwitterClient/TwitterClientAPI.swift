//
//  TwitterClientAPI.swift
//  TwitterClient
//
//  Created by Hoi Pham Ngoc on 3/24/16.
//  Copyright © 2016 John Pham. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

let twitterConsumerKey = "dQqHiuBXSVjQUYszrEN0V8JkW"
let twitterConsumerSecret = "yyYzKcHgEySk94WJ6mTecgkl2A1hYPoBaBcB5p3QdXEmgykJ0f"
let twitterBaseURL = NSURL(string: "https://api.twitter.com")



class TwitterClientAPI: BDBOAuth1SessionManager {
    var loginCompletion: ((user: User?, error: NSError?) -> ())?
    
    class var sharedInstance: TwitterClientAPI {
        struct Static {
            static let instance = TwitterClientAPI(baseURL: twitterBaseURL, consumerKey: twitterConsumerKey, consumerSecret: twitterConsumerSecret)
        }
        
        return Static.instance
    }
    
    func homeTimelineWithParams(params: NSDictionary?, completion: (tweets: [Tweet]?, error: NSError?) -> ()) {
        
        // GET the timeline
        GET("1.1/statuses/home_timeline.json", parameters: params,
            progress: nil,
            success: { (operation: NSURLSessionDataTask, response: AnyObject?) -> Void in
                // SUCCESS
                let tweets = Tweet.tweetsWithArray(response as! [NSDictionary])
                completion(tweets: tweets, error: nil)
                
                //                for tweet in tweets! {
                //                    print("text: \(tweet.text!), created: \(tweet.createdAt!)")
                //                }
            },
            failure: { (operation: NSURLSessionDataTask?, error: NSError) -> Void in
                // FAILURE
                print("Unable to retrieve timeline: \(error)")
                completion(tweets: nil, error: error)
        })
    }
    func favoriteTweetWithParams(params: NSDictionary?, completion: (success: Bool, error: NSError?) -> ()) {
        
        // POST favorite
        POST("1.1/favorites/create.json", parameters: params,
            progress: nil,
            success:  { (operation: NSURLSessionDataTask, response: AnyObject?) -> Void in
                // SUCCESS
                completion(success: true, error: nil)
            },
            failure: { (operation: NSURLSessionDataTask?, error: NSError) -> Void in
                //FAILURE
                print("Unable to favorite tweet: \(error)")
                completion(success: false, error: error)
        })
    }
    
    func retweetTweetWithParams(tweetId: NSNumber, params: NSDictionary?, completion: (success: Bool, error: NSError?) -> ()) {
        
        // POST retweet
        POST("1.1/statuses/retweet/\(tweetId).json", parameters: params,
            progress: nil,
            success: { (operation: NSURLSessionDataTask, response: AnyObject?) -> Void in
                // SUCCESS
                completion(success: true, error:nil)
            },
            failure: { (operation: NSURLSessionDataTask?, error: NSError) -> Void in
                //FAILURE
                print("Unable to retweet tweet: \(error)")
                completion(success: false, error: error)
        })
    }
    
    func composeTweetWithCompletion(params: NSDictionary?, completion: (success: Bool, error: NSError?) -> ()) {
        
        // POST update
        POST("1.1/statuses/update.json", parameters: params,
            progress: nil,
            success:  { (operation: NSURLSessionDataTask, response: AnyObject?) -> Void in
                // SUCCESS
                completion(success: true, error: nil)
            },
            failure: { (operation: NSURLSessionDataTask?, error: NSError) -> Void in
                //FAILURE
                print("Unable to udpate status: \(error)")
                completion(success: false, error: error)
        })
    }
    
    func loginWithCompletion(completion: (user: User?, error: NSError?) -> ()) {
        loginCompletion = completion
        
        
        // fetch request token and redirect to authorization page
        TwitterClientAPI.sharedInstance.requestSerializer.removeAccessToken()
        TwitterClientAPI.sharedInstance.fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: NSURL(string: "twiiterClient://oauth"), scope: nil,
            success: { (requestToken: BDBOAuth1Credential!) -> Void in
                print("Got the request token: \(requestToken)")
                
                
                
                let authURL = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")
                print(authURL)
                UIApplication.sharedApplication().openURL(authURL!)
            },
            failure: { (error: NSError!) -> Void in
                print("Got an error when requesting request token")
                self.loginCompletion?(user: nil, error: error)
        })
        
    }
    
    func openURL(url: NSURL) {
        
        fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: BDBOAuth1Credential(queryString: url.query),
            success: { (accessToken: BDBOAuth1Credential!) -> Void in
                print("Got the access token 2: \(accessToken)!")
                TwitterClientAPI.sharedInstance.requestSerializer.saveAccessToken(accessToken)
                
                // GET the user
                TwitterClientAPI.sharedInstance.GET("1.1/account/verify_credentials.json", parameters: nil,
                    progress: nil,
                    success: { (operation: NSURLSessionDataTask!, response: AnyObject?) -> Void in
                        // SUCCESS
                        if let response = response {
                            print("We've got a user: \(response)")
                            let user = User(dictionary: response as! NSDictionary)
                            User.currentUser = user
                            print("user: \(user.name)")
                            self.loginCompletion?(user: user, error: nil)
                        }
                    },
                    failure: { (operation: NSURLSessionDataTask?, error: NSError) -> Void in
                        // FAILURE
                        print("Unable to verify credentials: \(error)")
                        self.loginCompletion?(user: nil, error: error)
                })
                
            },
            failure: { (error: NSError!) -> Void in
                print("Got an error when requesting access token")
                self.loginCompletion?(user: nil, error: error)
        })
        
        
    }

    

}
