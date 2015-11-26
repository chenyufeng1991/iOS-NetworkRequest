
//
//  WebServiceViewController.m
//  NetworkRequest
//
//  Created by chenyufeng on 15/11/26.
//  Copyright © 2015年 chenyufengweb. All rights reserved.
//

#import "WebServiceViewController.h"

@interface WebServiceViewController ()<NSURLConnectionDelegate>

@property (strong, nonatomic) NSMutableData *webData;
@property (strong, nonatomic) NSMutableString *soapResults;
@property (strong, nonatomic) NSXMLParser *xmlParser;
@property (nonatomic) BOOL elementFound;
@property (strong, nonatomic) NSString *matchingElement;
@property (strong, nonatomic) NSURLConnection *conn;

@property (strong,nonatomic) NSString *xmlReturnToMainThread;


@end

@implementation WebServiceViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  [self query:@"18888888888"];
  
}

-(void)query:(NSString*)phoneNumber{
  
  // 设置我们之后解析XML时用的关键字，与响应报文中Body标签之间的getMobileCodeInfoResult标签对应
  self.matchingElement = @"getMobileCodeInfoResult";
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
  
  // 将这个XML字符串打印出来
//  NSLog(@"%@", soapMsg);
  // 创建URL，内容是前面的请求报文报文中第二行主机地址加上第一行URL字段
  NSURL *url = [NSURL URLWithString: @"http://webservice.webxml.com.cn/WebServices/MobileCodeWS.asmx"];
  // 根据上面的URL创建一个请求
  NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
  NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMsg length]];
  // 添加请求的详细信息，与请求报文前半部分的各字段对应
  [req addValue:@"application/soap+xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
  [req addValue:msgLength forHTTPHeaderField:@"Content-Length"];
  // 设置请求行方法为POST，与请求报文第一行对应
  [req setHTTPMethod:@"GET"];
  // 将SOAP消息加到请求中
  [req setHTTPBody: [soapMsg dataUsingEncoding:NSUTF8StringEncoding]];
  // 创建连接
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
