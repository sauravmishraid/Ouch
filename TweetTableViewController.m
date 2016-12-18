//
//  TweetTableViewController.m
//  TweeterStrings
//
//  Created by Saurav  Mishra on 17/12/16.
//  Copyright © 2016 Saurav  Mishra. All rights reserved.
//

#import "TweetTableViewController.h"
#import "STTwitter/STTwitter.h"
#import "Tweets.h"
#import "TweetTableViewCell.h"

@interface TweetTableViewController ()<UITableViewDelegate,UITableViewDataSource>
@property  STTwitterAPI * twitter;
@property  Tweets * tweets;
@property  NSArray <Tweets *> * arrayOfSortedTweets;

@end

@implementation TweetTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.estimatedRowHeight = self.tableView.rowHeight;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.twitter = [STTwitterAPI twitterAPIWithOAuthConsumerKey:@"VReHqMvcPnOfZn63w1eUMZcpl" consumerSecret:@"YdTmePSWBEX7iVrp7yqvUry7Zm9H3ZhzxZ19cNGCYnZGNg8jtJ"];
    self.tweets = [[Tweets alloc] init];
    [self.twitter getSearchTweetsWithQuery:@"%23Blackrock" geocode:nil lang:nil locale:nil resultType:@"recent" count:@"100" until:nil sinceID:nil maxID:nil includeEntities:nil callback:nil useExtendedTweetMode:nil successBlock:^(NSDictionary *searchMetadata, NSArray *statuses) {
        self.arrayOfSortedTweets=[self.tweets evaluateStatus:statuses];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.tableView.delegate= self;
            self.tableView.dataSource=self;
            [self.tableView reloadData];
        });
    } errorBlock:^(NSError *error) {
        NSLog(@"Error : %@" ,error.localizedDescription);

    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return self.arrayOfSortedTweets ? 1 : 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   
    return self.arrayOfSortedTweets ? self.arrayOfSortedTweets.count : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    static NSString * cellidentifier = @"Tweet";
    TweetTableViewCell  *tweetCell = [tableView dequeueReusableCellWithIdentifier:cellidentifier forIndexPath:indexPath];
    if(!tweetCell)
    {
        tweetCell = [[TweetTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellidentifier];
    }
    //UIActivityIndicatorView *indicatorView =[[UIActivityIndicatorView alloc] initWithFrame:tweetCell.profileImageView.bounds];
    //indicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
  // [tweetCell.profileImageView addSubview:indicatorView];
   // [indicatorView startAnimating];
    tweetCell.twitterScreenName.text = self.arrayOfSortedTweets[indexPath.row].screenName;
    tweetCell.createdDateLabel.text = [self stringFromDate:self.arrayOfSortedTweets[indexPath.row].CreatedAt];
    tweetCell.statusLabel.text = (self.arrayOfSortedTweets[indexPath.row].doesContainMediaContent?[self.arrayOfSortedTweets[indexPath.row].Status stringByAppendingString:@"📷"] : self.arrayOfSortedTweets[indexPath.row].Status);
    tweetCell.profileImageView.image=[UIImage imageNamed:@"twitter"];
    NSString * profileImageURL = self.arrayOfSortedTweets[indexPath.row].imageProfileURL;
    if(profileImageURL)
    {    NSURL *url = [NSURL URLWithString:profileImageURL];
        NSURLSessionDownloadTask *downloadPhotoTask = [[NSURLSession sharedSession]
                                                       downloadTaskWithURL:url completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
                                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                                UIImage *downloadedImage = [UIImage imageWithData:
                                                                                            [NSData dataWithContentsOfURL:location]];
                                                               if(downloadedImage)
                                                               {
                                                                   tweetCell.profileImageView.image = downloadedImage;
                                                                   [tweetCell setNeedsDisplay];
                                                                  // [indicatorView stopAnimating];
                                                                  // [indicatorView removeFromSuperview];
                                                               }
                                                           });
                                                       }];
             [downloadPhotoTask resume];
    
    }
    
    return tweetCell;
}

-(NSString *)stringFromDate:(NSDate *)date
{
    NSDateFormatter *dateformate=[[NSDateFormatter alloc]init];
    [dateformate setDateFormat:@"MMM d,HH:mm"]; // Date formater

    //[dateformate setDateFormat:@"EEE, MMM d, ''yy"]; // Date formater
    NSString *dateString = [dateformate stringFromDate:date];
    return dateString;
}
@end
