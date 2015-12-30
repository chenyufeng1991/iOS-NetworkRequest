
//
//  SOAP3ViewController.m
//  NetworkRequest
//
//  Created by chenyufeng on 15/11/27.
//  Copyright © 2015年 chenyufengweb. All rights reserved.
//

#import "SOAP3ViewController.h"

@interface SOAP3ViewController ()

@property (strong, nonatomic) NSMutableData *webData;
@property (strong, nonatomic) NSURLConnection *conn;

@end

@implementation SOAP3ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  [self query:@"18888888888"];
}

-(void)query:(NSString*)phoneNumber{

  // 设置我们之后解析XML时用的关键字，与响应报文中Body标签之间的getMobileCodeInfoResult标签对应
  // 创建SOAP消息，内容格式就是网站上提示的请求报文的主体实体部分    这里使用了SOAP1.2；
  NSString *soapMsg = [NSString stringWithFormat:
                       @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                       "<soap12:Envelope "
                       "xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" "
                       "xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" "
                       "xmlns:soap12=\"http://www.w3.org/2003/05/soap-envelope\">"
                       "<soap12:Body>"
                       "<getMobileCodeInfo xmlns=\"http://WebXml.com.cn/\">"
                       "<mobileCode>%@</mobileCode>"
                       "<userID>%@</userID>"
                       "</getMobileCodeInfo>"
                       "</soap12:Body>"
                       "</soap12:Envelope>", phoneNumber, @""];

  NSURL *url = [NSURL URLWithString: @"http://webservice.webxml.com.cn/WebServices/MobileCodeWS.asmx"];
  NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
  NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMsg length]];
  [req addValue:@"application/soap+xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
  [req addValue:msgLength forHTTPHeaderField:@"Content-Length"];
  [req setHTTPMethod:@"POST"];
  [req setHTTPBody: [soapMsg dataUsingEncoding:NSUTF8StringEncoding]];

  NSURLSession *session = [NSURLSession sharedSession];
  NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:req completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {

    if (!error) {
      NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
      NSLog(@"成功：%@",result);
    }else{
      NSLog(@"失败 ： %@",error);
    }
  }];
  [dataTask resume];
}
@end
