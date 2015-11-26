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
  
  
  //以下方法已经不推荐使用；
  //  NSString *urlStr = [@"http://v.juhe.cn/weather/index?format=2&cityname=北京&key=88e194ce72b455563c3bed01d5f967c5"stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
  
  
  //建议使用这个方法stringByAddingPercentEncodingWithAllowedCharacters，不推荐使用stringByAddingPercentEscapesUsingEncoding；
  NSString *urlStr2 = [@"http://v.juhe.cn/weather/index?format=2&cityname=北京&key=88e194ce72b455563c3bed01d5f967c5" stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
  [self asynHttpGet:urlStr2];
  
  
  
}

- (NSString *)asynHttpGet:(NSString *)urlAsString{
  NSURL *url = [NSURL URLWithString:urlAsString];
//  __block NSString *resault=@"";
  NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
  [urlRequest setTimeoutInterval:30];
  [urlRequest setHTTPMethod:@"GET"];
  
  //以下方法已经被禁用；
  
//  NSOperationQueue *queue = [[NSOperationQueue alloc] init];
//  
//  [NSURLConnection
//   sendAsynchronousRequest:urlRequest
//   queue:queue
//   completionHandler:^(NSURLResponse *response,
//                       NSData *data,
//                       NSError *error) {
//     
//     if ([data length] >0  &&
//         error == nil){
//       NSString *html = [[NSString alloc] initWithData:data
//                                              encoding:NSUTF8StringEncoding];
//       resault=[html copy];
//       
//       NSLog(@"返回的服务器数据 = %@", html);
//     }
//     else if ([data length] == 0 &&
//              error == nil){
//       resault=@"Nothing was downloaded.";
//       NSLog(@"Nothing was downloaded.");
//     }
//     else if (error != nil){
//       resault=[NSString stringWithFormat:@"Error happened = %@", error];
//       NSLog(@"发生错误 = %@", error);
//     }
//     
//   }];
  
  /////////////////////////////////////////////////////////

  //推荐使用这种请求方法；
  NSURLSession *session = [NSURLSession sharedSession];
  
  __block  NSString *result = @"";
  NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
    
    if (!error) {
      //没有错误，返回正确；
      result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
      NSLog(@"返回正确：%@",result);
      
    }else{
      //出现错误；
      NSLog(@"错误信息：%@",error);
    }
    
  }];
  
  
  [dataTask resume];
  
  
  return result;
  
  
}

@end
