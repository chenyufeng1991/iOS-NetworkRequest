
//
//  WebServiceViewController.m
//  NetworkRequest
//
//  Created by chenyufeng on 15/11/26.
//  Copyright © 2015年 chenyufengweb. All rights reserved.
//

#import "SOAP1ViewController.h"

@interface SOAP1ViewController ()<NSURLConnectionDelegate>

@property (strong, nonatomic) NSMutableData *webData;
@property (strong, nonatomic) NSURLConnection *conn;

@end

@implementation SOAP1ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  [self query:@"18888888888"];
  
}

-(void)query:(NSString*)phoneNumber{
  
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
  
  self.conn = [[NSURLConnection alloc] initWithRequest:req delegate:self];
  if (self.conn) {
    self.webData = [NSMutableData data];
  }
  
}


// 刚开始接受响应时调用
-(void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *) response{
  [self.webData setLength: 0];
}

// 每接收到一部分数据就追加到webData中
-(void) connection:(NSURLConnection *)connection didReceiveData:(NSData *) data {
  
  if(data != NULL){
    [self.webData appendData:data];
  }
  
}

// 出现错误时
-(void) connection:(NSURLConnection *)connection didFailWithError:(NSError *) error {
  self.conn = nil;
  self.webData = nil;
}

// 完成接收数据时调用
-(void) connectionDidFinishLoading:(NSURLConnection *) connection {
  NSString *theXML = [[NSString alloc] initWithBytes:[self.webData mutableBytes]
                                              length:[self.webData length]
                                            encoding:NSUTF8StringEncoding];
  
  // 打印出得到的XML
  NSLog(@"返回的数据：%@", theXML);
  
}

@end








