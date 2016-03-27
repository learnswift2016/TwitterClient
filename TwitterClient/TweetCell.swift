//
//  TweetCell.swift
//  TwitterClient
//
//  Created by Hoi Pham Ngoc on 3/26/16.
//  Copyright © 2016 John Pham. All rights reserved.
//

import UIKit


class TweetCell: UITableViewCell {
    
    

    
    @IBOutlet weak var userProfileImage: UIImageView!

    @IBOutlet private weak var userProfileName: UILabel!
    @IBOutlet weak var userScreenName: UILabel!
    @IBOutlet private weak var tweetTextData: UILabel!
    @IBOutlet private weak var tweetTime: UILabel!
    @IBOutlet weak var circleBig: UIView!
 


    
    
    var tweet: Tweet! {
        didSet {
            if let user = tweet.user {
                if let urlString = user.profileImageUrl {
                    if let imageURL = NSURL(string: urlString) {
                       
                        userProfileImage.setImageWithURL(imageURL)
                    }
                }
                userProfileName.text = user.name
                userScreenName.text = "@\(user.screenName!)"
            }
            
            if (tweet.createdAtDate != nil) {
                let realDate = tweet.createdAtDate!
                let relativeDate = convertDateToRelativeTimestamp(realDate) as String?
                tweetTime.text = relativeDate 
            }
            
            
            
            tweetTextData.text = tweet.text
        }
    }
    
    // MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        circleBig.layer.cornerRadius = circleBig.frame.width/2
        circleBig.layer.borderWidth = 2
        circleBig.layer.borderColor = UIColor(red:0.81, green:0.91, blue:0.95, alpha:1.0).CGColor
        circleBig.clipsToBounds = true
        
        userProfileImage.layer.cornerRadius = userProfileImage.frame.width/2
        userProfileImage.layer.borderWidth = 3
        userProfileImage.layer.borderColor = UIColor(white:1.0, alpha:1.0).CGColor

        userProfileImage.clipsToBounds = true
    }
    
    
    

}
public func convertDateToRelativeTimestamp(date: NSDate) -> String? {
    return date.formatAsTimeAgo()
}
