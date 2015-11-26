//
//  HttpGetViewController.m
//  NetworkRequest
//
//  Created by chenyufeng on 15/11/26.
//  Copyright © 2015年 chenyufengweb. All rights reserved.
//

#import "HttpGetViewController.h"

@interface HttpGetViewController ()

@end

@implementation HttpGetViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  /*
   为什么要执行如下方法？
   因为有的服务端要求把中文进行utf8编码，而我们的代码默认是unicode编码。必须要进行一下的转码，否则返回的可能为空，或者是其他编码格式的乱码了！
   注意可以对整个url直接进行转码，而没必要对出现的每一个中文字符进行编码；
   */
  NSString *urlStr = [@"http://v.juhe.cn/weather/index?format=2&cityname=北京&key=88e194ce72b455563c3bed01d5f967c5"stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
  
  [self asynHttpGet:urlStr];
  
}

- (NSString *)asynHttpGet:(NSString *)urlAsString{
  NSURL *url = [NSURL URLWithString:urlAsString];
  __block NSString *resault=@"";
  NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
  [urlRequest setTimeoutInterval:30];
  [urlRequest setHTTPMethod:@"GET"];
  
  NSOperationQueue *queue = [[NSOperationQueue alloc] init];
  
  [NSURLConnection
   sendAsynchronousRequest:urlRequest
   queue:queue
   completionHandler:^(NSURLResponse *response,
                       NSData *data,
                       NSError *error) {
     
     if ([data length] >0  &&
         error == nil){
       NSString *html = [[NSString alloc] initWithData:data
                                              encoding:NSUTF8StringEncoding];
       resault=[html copy];
       
       NSLog(@"返回的服务器数据 = %@", html);
     }
     else if ([data length] == 0 &&
              error == nil){
       resault=@"Nothing was downloaded.";
       NSLog(@"Nothing was downloaded.");
     }
     else if (error != nil){
       resault=[NSString stringWithFormat:@"Error happened = %@", error];
       NSLog(@"发生错误 = %@", error);
     }
     
   }];
  return resault;


}

@end
