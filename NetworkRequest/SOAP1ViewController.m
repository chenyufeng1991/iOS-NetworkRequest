
//
//  WebServiceViewController.m
//  NetworkRequest
//
//  Created by chenyufeng on 15/11/26.
//  Copyright © 2015年 chenyufengweb. All rights reserved.
//

#import "SOAP1ViewController.h"

/**
 *  SOAP采用的协议是HTTP和XML协议；
 WebService只采用HTTP POST传输数据，不使用GET；
 目前WebService的协议主要有SOAP1.1和1.2，两者主要是命名空间不同；还有就是Content-Type不同；
 
 text/xml 这是基于soap1.1协议。
 application/soap+xml 这是基于soap1.2协议。

 
 WebService从数据传输格式上作了限定，WebService所使用的数据都是基于XML格式的。目前标准的WebService在数据格式上主要采用SOAP协议。
 SOAP协议实际上就是一种基于XML编程规范的文本协议，是运行在HTTP协议基础上的协议。其实就在HTTP协议传输XML文件，就变成了SOAP协议。
 
 
 Soap1.1的命名空间：
 xmlns:soap=“http://schemas.xmlsoap.org/soap/envelope/ “

 Soap1.2 命名空间：
 xmlns:soap="http://www.w3.org/2003/05/soap-envelope“
 
 
 SOAP包括四部分：
 （1）SOAP封装(envelop)：封装定义了一个描述消息中的内容是什么，是谁发送的，谁应当接受并处理它以及如何处理它们的框架；
  (2)SOAP编码规则(encoding rules):用于表示应用程序需要使用的数据类型的实例;
  (3)SOAP RPC表示(RPC representation):表示远程过程调用和应答的协定;
  (4)SOAP绑定（binding）:使用底层协议交换信息。

 
 
 
 SOAP=RPC+HTTP+XML：SOAP使用HTTP传送XML，
 采用HTTP作为底层通讯协议；
 RPC作为一致性的调用途径；
 ＸＭＬ作为数据传送的格式；
 
 
 客户端发送请求时，不管客户端是什么平台的，首先把请求转换成XML格式，SOAP网关可自动执行这个转换。
 
 SOAP1.2没有SOAPAction且类型为soap+xml;
 
 
 SOAP11客户端可以请求SOAP11和SOAP12服务器；
 SOAP12客户端只能请求SOAP12服务器；

 
 RPC：远程过程调用协议。
 

 */
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
  self.webData = [[NSMutableData alloc] init];
}

// 刚开始接受响应时调用，所有接收的数据通过NSMutableData来接收；
-(void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *) response{
  [self.webData setLength: 0];
}

// 每接收到一部分数据就追加到webData中
-(void) connection:(NSURLConnection *)connection didReceiveData:(NSData *) data {
  if(data != nil){
    [self.webData appendData:data];
  }
}

// 出现错误时,全部置空；
-(void) connection:(NSURLConnection *)connection didFailWithError:(NSError *) error {
  self.conn = nil;
  self.webData = nil;
}

// 完成接收数据时调用
-(void) connectionDidFinishLoading:(NSURLConnection *) connection {
  NSString *xml = [[NSString alloc] initWithData:self.webData encoding:NSUTF8StringEncoding];
  // 打印出得到的XML
  NSLog(@"返回的数据：%@", xml);
}
@end