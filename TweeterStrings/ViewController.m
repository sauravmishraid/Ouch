//
//  ViewController.m
//  TweeterStrings
//
//  Created by Saurav  Mishra on 14/12/16.
//  Copyright © 2016 Saurav  Mishra. All rights reserved.
//

#import "ViewController.h"
@interface ViewController ()

@property (nonatomic , strong) NSString *bearerToken;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self setTwitterKeys];
    
    
}
- (void)setTwitterKeys
{
    if(_bearerToken == nil)
    {
        NSString *rawConsumerKey =@"83hR9TPFQxlVqCjZmkTIZSGpl";
        NSString * consumerKey = rawConsumerKey;
        NSString * rawConsumerSecretKey = @"2ETtdU6L6Cw9sFKMpNfxdIrDLuGt9ivddacbRxk4N8rKvGOzZ6";
        NSString * consumerSecret = rawConsumerSecretKey;
        
        //the combined authentication key is "CONSUMER_KEY:CONSUMER_SECRET" run through base64 encoding.
        //we'll use NSData instead of NSString here so that we can feed it directly to the HTTPRequest later.
        NSString * combinedKey = [[self class] _base64Encode:[[NSString stringWithFormat:@"%@:%@", consumerKey, consumerSecret] dataUsingEncoding:NSUTF8StringEncoding]];
        
        NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://api.twitter.com/oauth2/token"]];
        [urlRequest setHTTPMethod:@"POST"];
        [urlRequest setValue:[NSString stringWithFormat:@"Basic %@", combinedKey] forHTTPHeaderField:@"Authorization"];
        [urlRequest setValue:[NSString stringWithFormat:@"application/x-www-form-urlencoded;charset=UTF-8"] forHTTPHeaderField:@"Content-Type"];
        [urlRequest setHTTPBody:[@"grant_type=client_credentials" dataUsingEncoding:NSUTF8StringEncoding]];
        
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
        NSURLSessionDataTask *downloadTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            
            NSDictionary *responseJSON = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            _bearerToken = [responseJSON valueForKey:@"access_token"];
            [self fetchTweets];

        }];
        [downloadTask resume];

    }
    
    
}
    
-(void)fetchTweets
{
    if(self.bearerToken == nil) return;
    NSURL *URL = [NSURL URLWithString:@"https://api.twitter.com/1.1/search/tweets.json?q=%23ios&count=25"];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:URL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:30.0];
    [urlRequest setValue:[NSString stringWithFormat:@"Bearer %@", self.bearerToken] forHTTPHeaderField:@"Authorization"];
    [urlRequest setHTTPMethod:@"GET"];
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
   // NSDictionary *responseJSON= [NSDictionary new];
    
  /*  NSURLSessionDownloadTask *downloadTask = [session downloadTaskWithRequest:urlRequest completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
 
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSURL *documentsURL = [fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask][0];
        NSURL *fileURL = [documentsURL URLByAppendingPathComponent:@"lolmax3.json"];
        NSError *moveError;
        if (![fileManager moveItemAtURL:location toURL:fileURL error:&moveError]) {
            NSLog(@"moveItemAtURL failed: %@", moveError);
        }
        
        NSData *data = [NSData dataWithContentsOfURL:fileURL];
        NSError *jsonError;
        NSMutableDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jsonError];


        NSLog(@"Hi");
        
        //        NSString *myJSON = [[NSString alloc] initWithContentsOfURL:fileURL encoding:NSUTF8StringEncoding error:NULL];
//        NSArray *jsonDataArray = [NSJSONSerialization JSONObjectWithData:[myJSON dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:&error];

        
    }];*/
   NSURLSessionDataTask *downloadTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSDictionary *responseJSON=[NSDictionary new];
        NSData *trueData= data;
        responseJSON = [NSJSONSerialization JSONObjectWithData:trueData options:NSJSONReadingAllowFragments error:nil];
       NSLog(@"Hi");
   }];
    [downloadTask resume];

}
    
+(NSString *)_base64Encode:(NSData *)data{
    //Point to start of the data and set buffer sizes
    int inLength = (int)[data length];
    int outLength = ((((inLength * 4)/3)/4)*4) + (((inLength * 4)/3)%4 ? 4 : 0);
    const char *inputBuffer = [data bytes];
    char *outputBuffer = malloc(outLength);
    outputBuffer[outLength] = 0;
    
    //64 digit code
    static char Encode[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
    
    //start the count
    int cycle = 0;
    int inpos = 0;
    int outpos = 0;
    char temp;
    
    //Pad the last to bytes, the outbuffer must always be a multiple of 4
    outputBuffer[outLength-1] = '=';
    outputBuffer[outLength-2] = '=';
    
    /* http://en.wikipedia.org/wiki/Base64
     Text content   M           a           n
     ASCII          77          97          110
     8 Bit pattern  01001101    01100001    01101110
     
     6 Bit pattern  010011  010110  000101  101110
     Index          19      22      5       46
     Base64-encoded T       W       F       u
     */
    
    
    while (inpos < inLength){
        switch (cycle) {
            case 0:
                outputBuffer[outpos++] = Encode[(inputBuffer[inpos]&0xFC)>>2];
                cycle = 1;
                break;
            case 1:
                temp = (inputBuffer[inpos++]&0x03)<<4;
                outputBuffer[outpos] = Encode[temp];
                cycle = 2;
                break;
            case 2:
                outputBuffer[outpos++] = Encode[temp|(inputBuffer[inpos]&0xF0)>> 4];
                temp = (inputBuffer[inpos++]&0x0F)<<2;
                outputBuffer[outpos] = Encode[temp];
                cycle = 3;
                break;
            case 3:
                outputBuffer[outpos++] = Encode[temp|(inputBuffer[inpos]&0xC0)>>6];
                cycle = 4;
                break;
            case 4:
                outputBuffer[outpos++] = Encode[inputBuffer[inpos++]&0x3f];
                cycle = 0;
                break;
            default:
                cycle = 0;
                break;
        }
    }
    NSString *pictemp = [NSString stringWithUTF8String:outputBuffer];
    free(outputBuffer);
    return pictemp;
}


@end
