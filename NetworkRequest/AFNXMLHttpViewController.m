
//
//  AFNXMLHttpViewController.m
//  NetworkRequest
//
//  Created by chenyufeng on 15/11/28.
//  Copyright © 2015年 chenyufengweb. All rights reserved.
//

#import "AFNXMLHttpViewController.h"
#import <AFNetworking.h>

@interface AFNXMLHttpViewController ()

@end

@implementation AFNXMLHttpViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  /*
   这里需要进行如下的安全性设置；
   使用AFNetworking发送XML，如果不进行如下的设置，将会报错：
   Error Domain=NSCocoaErrorDomain Code=3840 "JSON text did not start with array or object and option to allow fragments not set." UserInfo={NSDebugDescription=JSON text did not start with array or object and option to allow fragments not set.}
   */
  AFSecurityPolicy *securityPolicy = [[AFSecurityPolicy alloc] init];
  [securityPolicy setAllowInvalidCertificates:YES];
  
  AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
  [manager setSecurityPolicy:securityPolicy];
  manager.responseSerializer = [AFHTTPResponseSerializer serializer];
  
  NSString *str = @"这里存放需要发送的XML";
  
  NSDictionary *parameters = @{@"test" : str};
  
  [manager POST:@"需要发送的链接"
     parameters:parameters
        success:^(AFHTTPRequestOperation *operation,id responseObject){
          NSString *string = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
          NSLog(@"成功: %@", string);
        }
        failure:^(AFHTTPRequestOperation *operation,NSError *error){
          NSLog(@"失败: %@", error);
        }];
  
}


@end
