
//
//  AFNHttp3ViewController.m
//  NetworkRequest
//
//  Created by chenyufeng on 15/11/27.
//  Copyright © 2015年 chenyufengweb. All rights reserved.
//

#import "AFNHttp3ViewController.h"
#import <AFNetworking.h>

@interface AFNHttp3ViewController ()

@end

@implementation AFNHttp3ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  NSURL *url = [NSURL URLWithString: @"http://webservice.webxml.com.cn/WebServices/MobileCodeWS.asmx/getMobileCodeInfo?mobileCode=18888888888&userId="];
  NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
  [req setHTTPMethod:@"GET"];
  AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:req];
  operation.responseSerializer = [AFHTTPResponseSerializer serializer];
  [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
    
    NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
    NSLog(@"成功：%@",result);
  } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
    NSLog(@"失败：%@",error);
  }];
  [operation start];
}
@end