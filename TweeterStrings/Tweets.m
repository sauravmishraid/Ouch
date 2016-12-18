//
//  Tweets.m
//  TweeterStrings
//
//  Created by Saurav  Mishra on 17/12/16.
//  Copyright © 2016 Saurav  Mishra. All rights reserved.
//

#import "Tweets.h"
@import UIKit;
@implementation Tweets


-(instancetype)init{
    self=[super init];
    if(self)
    {
        self.screenName = [NSString new];
        self.Status = [NSString new];
        self.CreatedAt = [NSDate new];
        self.imageProfileURL = [NSString new];
        self.arrayOfUnSortedTweets=[NSMutableArray new];
    }
    return self;
}

-(NSArray *)evaluateStatus:(NSArray *)status
{
    NSMutableArray <Tweets *>*arrayOfTweets = [NSMutableArray new];
    for (id eachStatus in status) {
        Tweets * tweet = [[Tweets alloc] init];
        tweet.screenName = [[eachStatus objectForKey:@"user"] objectForKey:@"screen_name"];
        tweet.Status = [eachStatus objectForKey:@"text"];
        tweet.CreatedAt = [self dateFromString:[eachStatus objectForKey:@"created_at"]];
        tweet.imageProfileURL = [[eachStatus objectForKey:@"user"] objectForKey:@"profile_image_url_https"];
        NSString *mediaContent = [[[eachStatus objectForKey:@"entities"] objectForKey:@"media"][0] objectForKey:@"media_url"];
        tweet.doesContainMediaContent = mediaContent.length ? YES : NO;
        [arrayOfTweets addObject:tweet];
    }
   return [self createSortedArrayUsingDate:arrayOfTweets];
}


-(NSDate *)dateFromString:(NSString *)dateString
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"EEE MMM dd HH:mm:ss Z yyyy"];
    return [dateFormat dateFromString:dateString];
}

-(NSArray *)createSortedArrayUsingDate:(NSMutableArray *)unsortedTweets
{
    [unsortedTweets sortUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"CreatedAt" ascending:NO]]];
    return unsortedTweets;
}

@end
