//
//  LTNetWorkBaseRequest.m
//  network_oc
//
//  Created by 8000yi on 2020/12/29.
//

#import "LTNetWorkBaseRequest.h"

static LTNetWorkBaseRequest *_Instance = nil;
@implementation LTNetWorkBaseRequest

//  网络请求单利
+(LTNetWorkBaseRequest *)shaderInstance {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _Instance = [[LTNetWorkBaseRequest alloc] init];
    });
    
    return  _Instance;
}

/// 原生的网络请求
/// @param url 传入的服务器请求地址
/// @param parameters 传入的网络请求参数
/// @param success 请求成功返回
/// @param failure 请求失败返回
- (void)postWithUrlString:(NSString *)url
               parameters:(id)parameters
                  success:(LTSuccessBlock)success
                  failure:(LTFailureBlock)failure {

    //1.创建URL资源地址
    NSURL *requesturl = [NSURL URLWithString:url];
    //2.创建Request请求
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:requesturl];
    //3.配置Request
    //设置请求方法
    request.HTTPMethod = @"POST";
    //设置请求超时
    request.timeoutInterval = 20;
    //设置头部参数
    [request setValue:@"123" forHTTPHeaderField:@"content-type"];
    //4.构造请求参数
    //4.1创建字典参数，参数放入字典
    NSDictionary *parametersDic = @{@"name":@"liutao",@"pwd":@"123"};
    //4.2遍历字典 以key-value 的方式创建参数字符串
    NSMutableString *parameterString = [[NSMutableString alloc] init];
    int pos = 0;
    for (NSString *key in parametersDic.allKeys) {
        [parameterString appendFormat:@"%@=%@",key,parametersDic[key]];
        if (pos<parametersDic.allKeys.count-1) {
            [parameterString appendString:@"&"];
        }
        pos++;
    }
    //4.3 NSString 转成NSData数据类型
    NSData *parametersData = [parameterString dataUsingEncoding:NSUTF8StringEncoding];
    //5.设置请求报文
    [request setHTTPBody:parametersData];
    //6.构造configuration
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    //7.创建网络会话
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    //8.创建会话任务
    NSURLSessionTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            NSLog(@"post success:%@",error.localizedDescription);
        }else {
            NSDictionary *object = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
            if (error) {
                failure(error);
                NSLog(@"post success:%@",error.localizedDescription);
            }else {
                NSLog(@"post success:%@",object);
                success(object);
                dispatch_async(dispatch_get_main_queue(), ^{
                   //刷新界面
                });
            }
        }
    }];
    //9.执行任务
    [task resume];
}

/// GET的请求方法
/// @param requestUrl 请求连接
/// @param paramters 请求参数
/// @param success 成功的回调
/// @param failure 失败的回调
- (void)getWithUrlString:(NSString *)requestUrl
               paramters:(id)paramters
                 success:(LTSuccessBlock)success
                 failure:(LTFailureBlock)failure {
    //1.请求的服务器连接
    NSURL *url = [NSURL URLWithString:requestUrl];
    //2.创建request请求
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    //2.1配置request请求方法
    [request setHTTPMethod:@"GET"];
    //2.2配置请求超时时间
    [request setTimeoutInterval:10.0];
    //2.3配置请求头
    [request addValue:@"gzip" forHTTPHeaderField:@"Content-Encoding"];
    //2.3or批量设置请求头
    request.allHTTPHeaderFields = @{@"Content-Encoding":@"gzip"};
    //3.0设置缓存策略
    [request setCachePolicy:NSURLRequestReloadIgnoringCacheData];
//    根据需求添加不用的设置，比如请求方式、超时时间、请求头信息，这里重点介绍下缓存策略：
//    NSURLRequestUseProtocolCachePolicy = 0 //默认的缓存策略， 如果缓存不存在，直接从服务端获取。如果缓存存在，会根据response中的Cache-Control字段判断下一步操作，如: Cache-Control字段为must-revalidata, 则询问服务端该数据是否有更新，无更新的话直接返回给用户缓存数据，若已更新，则请求服务端.
//    NSURLRequestReloadIgnoringLocalCacheData = 1 //忽略本地缓存数据，直接请求服务端.
//    NSURLRequestIgnoringLocalAndRemoteCacheData = 4 //忽略本地缓存，代理服务器以及其他中介，直接请求源服务端.
//    NSURLRequestReloadIgnoringCacheData = NSURLRequestReloadIgnoringLocalCacheData
//    NSURLRequestReturnCacheDataElseLoad = 2 //有缓存就使用，不管其有效性(即忽略Cache-Control字段), 无则请求服务端.
//     NSURLRequestReturnCacheDataDontLoad = 3 //只加载本地缓存. 没有就失败. (确定当前无网络时使用)
//    NSURLRequestReloadRevalidatingCacheData = 5 //缓存数据必须得得到服务端确认有效才使用
    
//    NSURLSession *sharedSession = [NSURLSession sharedSession];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
//    通过NSURLSessionConfiguration提供了三种创建NSURLSession的方式
//    defaultSessionConfiguration //默认配置使用的是持久化的硬盘缓存，存储证书到用户钥匙链。存储cookie到shareCookie。
//    ephemeralSessionConfiguration //不使用永久持存cookie、证书、缓存的配置，最佳优化数据传输。
//    backgroundSessionConfigurationWithIdentifier //可以上传下载HTTP和HTTPS的后台任务(程序在后台运行)。
//    在后台时，将网络传输交给系统的单独的一个进程,即使app挂起、推出甚至崩溃照样在后台执行。
//    也可以通过NSURLSessionConfiguration统一设置超时时间、请求头等信息
    
    //构造NSURLSessionTask任务
    NSURLSessionTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            NSLog(@"no you get a error%@",error.localizedDescription);
            failure(error);
        }else{
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
            NSLog(@"yes you get a success%@",dict);
            dispatch_async(dispatch_get_main_queue(), ^{
                success(dict);
            });
            
        }
    }];
    [task resume];
}

///  下载函数
/// @param Url 下载链接
- (void)downLoadTaskWithUrl:(NSString *)Url{
    //1.导入下载链接
    NSURL *downUrl = [NSURL URLWithString:Url];
    //2.创建请求
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:downUrl];
    //3.创建会话
    NSURLSession *session = [NSURLSession sharedSession];
    //4.创建会话任务
    NSURLSessionDownloadTask *downLoadTask = [session downloadTaskWithRequest:request completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (!error) {
            NSLog(@"download success :%@",location);
            NSData *data = [NSData dataWithContentsOfURL:location];
            UIImage *image = [UIImage imageWithData:data];
            dispatch_async(dispatch_get_main_queue(), ^{
                UIImageView *imageView = [[UIImageView alloc] init];
                imageView.image = image;
                
            });
        }else {
            NSLog(@"download error:%@",error.localizedDescription);
        }
    }];
    
    [downLoadTask resume];
}
@end
