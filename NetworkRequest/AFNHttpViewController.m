

//
//  AFNWebServiceViewController.m
//  NetworkRequest
//
//  Created by chenyufeng on 15/11/26.
//  Copyright © 2015年 chenyufengweb. All rights reserved.
//

#import "AFNHttpViewController.h"
#import <AFNetworking.h>

@interface AFNHttpViewController ()

@end

@implementation AFNHttpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
  

  
  AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
  manager.responseSerializer = [AFHTTPResponseSerializer serializer];
  

  NSDictionary *dic = @{@"mobileCode":@"18888888888",
                        @"userID":@""};
  //这里改成POST，就可以进行POST请求；
  [manager GET:@"http://webservice.webxml.com.cn/WebServices/MobileCodeWS.asmx/getMobileCodeInfo"
     parameters:dic
        success:^(AFHTTPRequestOperation *operation,id responseObject){
          NSString *string = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
          NSLog(@"成功: %@", string);
        }
        failure:^(AFHTTPRequestOperation *operation,NSError *error){
          NSLog(@"失败: %@", error);
        }];

  
  
}


@end
