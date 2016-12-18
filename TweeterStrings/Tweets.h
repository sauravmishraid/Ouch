//
//  Tweets.h
//  TweeterStrings
//
//  Created by Saurav  Mishra on 17/12/16.
//  Copyright © 2016 Saurav  Mishra. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Tweets : NSObject

@property(nonatomic, strong) NSString *screenName;
@property(nonatomic, strong) NSString *Status;
@property(nonatomic, strong) NSDate *CreatedAt;
@property(nonatomic, strong) NSString *imageProfileURL;
@property(nonatomic, strong) NSMutableArray  <Tweets *>*arrayOfUnSortedTweets;
@property(nonatomic        ) BOOL doesContainMediaContent;
-(NSArray *)evaluateStatus:(NSArray *)status;

@end
