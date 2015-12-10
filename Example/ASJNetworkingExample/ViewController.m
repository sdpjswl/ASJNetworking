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
- (IBAction)putTapped:(id)sender;
- (IBAction)patchTapped:(id)sender;
- (IBAction)deleteTapped:(id)sender;

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

#pragma mark - GET

- (IBAction)getTapped:(id)sender
{
  [[NSOperationQueue mainQueue] addOperationWithBlock:^{
    textView.text = @" ";
    progressLabel.text = @" ";
  }];
  ASJNetworking *networking = [[ASJNetworking alloc] initWithBaseUrl:kBaseURL requestMethod:@"get"];
  [networking GETWithCompletion:^(id response, NSString *responseString, NSError *error) {
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
      textView.text = responseString;
    }];
  }];
}

#pragma mark - POST

- (IBAction)postTapped:(id)sender
{
  [[NSOperationQueue mainQueue] addOperationWithBlock:^{
    textView.text = @" ";
    progressLabel.text = @" ";
  }];
  ASJNetworking *networking = [[ASJNetworking alloc] initWithBaseUrl:kBaseURL requestMethod:@"post"];
  [networking POSTWithCompletion:^(id response, NSString *responseString, NSError *error) {
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
      textView.text = responseString;
    }];
  }];
}

#pragma mark - POST multipart

- (IBAction)multipartTapped:(id)sender
{
  [[NSOperationQueue mainQueue] addOperationWithBlock:^{
    textView.text = @" ";
    progressLabel.text = @" ";
  }];
  
  NSDictionary *p = @{@"imageCaption": @"I am FIROZZZ"};
  ASJMultipartImageItem *imageItem = [[ASJMultipartImageItem alloc] init];
  imageItem.name = @"userPhoto";
  imageItem.filename = @"talk.jpg";
  imageItem.image = [UIImage imageNamed:@"el_capitan"];
  
  ASJNetworking *networking = [[ASJNetworking alloc] initWithBaseUrl:kBaseURL2 requestMethod:nil arguments:nil parameters:p imageItems:@[imageItem]];
  [networking POSTMultipartWithProgress:^(CGFloat progressPc)
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

#pragma mark - PUT

- (IBAction)putTapped:(id)sender
{
  [[NSOperationQueue mainQueue] addOperationWithBlock:^{
    textView.text = @" ";
    progressLabel.text = @" ";
  }];
  ASJNetworking *networking = [[ASJNetworking alloc] initWithBaseUrl:kBaseURL requestMethod:@"put"];
  [networking PUTWithCompletion:^(id response, NSString *responseString, NSError *error) {
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
      textView.text = responseString;
    }];
  }];
}

#pragma mark - PATCH

- (IBAction)patchTapped:(id)sender
{
  [[NSOperationQueue mainQueue] addOperationWithBlock:^{
    textView.text = @" ";
    progressLabel.text = @" ";
  }];
  ASJNetworking *networking = [[ASJNetworking alloc] initWithBaseUrl:kBaseURL requestMethod:@"patch"];
  [networking PATCHWithCompletion:^(id response, NSString *responseString, NSError *error) {
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
      textView.text = responseString;
    }];
  }];
}

#pragma mark - DELETE

- (IBAction)deleteTapped:(id)sender
{
  [[NSOperationQueue mainQueue] addOperationWithBlock:^{
    textView.text = @" ";
    progressLabel.text = @" ";
  }];
  ASJNetworking *networking = [[ASJNetworking alloc] initWithBaseUrl:kBaseURL requestMethod:@"delete"];
  [networking DELETEWithCompletion:^(id response, NSString *responseString, NSError *error) {
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
      textView.text = responseString;
    }];
  }];
}

@end
