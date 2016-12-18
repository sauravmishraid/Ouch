//
//  TweetTableViewCell.h
//  TweeterStrings
//
//  Created by Saurav  Mishra on 17/12/16.
//  Copyright © 2016 Saurav  Mishra. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TweetTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *twitterScreenName;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *createdDateLabel;

@end
