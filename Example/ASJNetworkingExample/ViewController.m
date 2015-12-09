//
//  ViewController.m
//  ASJNetworkingExample
//
//  Created by sudeep on 04/07/15.
//  Copyright (c) 2015 Sudeep Jaiswal. All rights reserved.
//

#import "ViewController.h"
#import "ASJNetworking.h"

static NSString *const kBaseURL = @"http://httpbin.org";
static NSString *const kBaseURL2 = @"http://99.111.104.82:8080/api/photo";

@interface ViewController () {
  IBOutlet UITextView *textView;
  IBOutlet UILabel *progressLabel;
}

- (IBAction)getTapped:(id)sender;
- (IBAction)postTapped:(id)sender;
- (IBAction)multipartTapped:(id)sender;

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

#pragma mark - Misc

- (IBAction)getTapped:(id)sender
{
  [[NSOperationQueue mainQueue] addOperationWithBlock:^{
    textView.text = nil;
    progressLabel.text = nil;
  }];
  ASJNetworking *networking = [[ASJNetworking alloc] initWithBaseUrl:kBaseURL requestMethod:@"get"];
  [networking fireGetWithCompletion:^(id response, NSString *responseString, NSError *error) {
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
      textView.text = responseString;
    }];
  }];
}

- (IBAction)postTapped:(id)sender
{
  [[NSOperationQueue mainQueue] addOperationWithBlock:^{
    textView.text = nil;
    progressLabel.text = nil;
  }];
  ASJNetworking *networking = [[ASJNetworking alloc] initWithBaseUrl:kBaseURL requestMethod:@"post"];
  [networking firePostWithCompletion:^(id response, NSString *responseString, NSError *error) {
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
      textView.text = responseString;
    }];
  }];
}

- (IBAction)multipartTapped:(id)sender
{
  [[NSOperationQueue mainQueue] addOperationWithBlock:^{
    textView.text = nil;
    progressLabel.text = nil;
  }];
  
  NSDictionary *p = @{@"imageCaption": @"I am FIROZZZ"};
  ASJMultipartImageItem *imageItem = [[ASJMultipartImageItem alloc] init];
  imageItem.name = @"userPhoto";
  imageItem.filename = @"talk.jpg";
  imageItem.image = [UIImage imageNamed:@"el_capitan"];
  
  ASJNetworking *networking = [[ASJNetworking alloc] initWithBaseUrl:kBaseURL2 requestMethod:nil arguments:nil parameters:p imageItems:@[imageItem]];
  [networking fireMultipartPostWithProgress:^(CGFloat progressPc)
   {
     progressLabel.text = [NSString stringWithFormat:@"Progress: %.2f%%", progressPc];
     
   } completion:^(id response, NSString *responseString, NSError *error)
   {
     NSString *message = responseString.length ? responseString : error.localizedDescription;
     [[NSOperationQueue mainQueue] addOperationWithBlock:^{
       textView.text = message;
     }];
   }];
}

@end
