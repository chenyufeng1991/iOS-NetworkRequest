

//
//  AFNsoapViewController.m
//  NetworkRequest
//
//  Created by chenyufeng on 15/11/27.
//  Copyright © 2015年 chenyufengweb. All rights reserved.
//

#import "AFNsoapViewController.h"
#import <AFNetworking.h>

@interface AFNsoapViewController ()

@end

@implementation AFNsoapViewController

- (void)viewDidLoad {

  [super viewDidLoad];
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
                       "</soap12:Envelope>", @"18888888888", @""];

  NSURL *url = [NSURL URLWithString: @"http://webservice.webxml.com.cn/WebServices/MobileCodeWS.asmx"];
  NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
  NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMsg length]];
  [req addValue:@"application/soap+xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
  [req addValue:msgLength forHTTPHeaderField:@"Content-Length"];
  [req setHTTPMethod:@"POST"];
  [req setHTTPBody: [soapMsg dataUsingEncoding:NSUTF8StringEncoding]];

  AFHTTPRequestOperation *operate = [[AFHTTPRequestOperation alloc] initWithRequest:req];
  operate.responseSerializer = [AFHTTPResponseSerializer serializer];

  if ([[NSFileManager defaultManager] fileExistsAtPath:@"Library/Caches/12"]) {
    //从本地读缓存文件
    NSData *data = [NSData dataWithContentsOfFile:@"Library/Caches/12"];
    //这个data就可以使用了；
    NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"缓存结果：%@",result);
  }else{
    //缓存不存在，就可以继续进行网络请求；
  }

  [operate setCompletionBlockWithSuccess:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
  //在AFNETWorking中，并没有提供现成的缓存方案，我们可以通过写文件的方式，自行做缓存。
    //写缓存：我这里存储NSData,此时缓存的内容必定是最新的内容；
    //Library/Caches：存放缓存文件，iTunes不会备份此目录，此目录下文件不会在应用退出删除
    /**
     *   1:Documents：应用中用户数据可以放在这里，iTunes备份和恢复的时候会包括此目录
     2:tmp：存放临时文件，iTunes不会备份和恢复此目录，此目录下文件可能会在应用退出后删除
     3:Library/Caches：存放缓存文件，iTunes不会备份此目录，此目录下文件不会在应用退出删除
     */
    [responseObject writeToFile:@"Library/Caches/12" options:NSDataWritingWithoutOverwriting error:nil];
    NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
    NSLog(@"成功：%@",result);
  } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {

    NSLog(@"失败：%@",error);
  }];
  [operate start];
}

@end
