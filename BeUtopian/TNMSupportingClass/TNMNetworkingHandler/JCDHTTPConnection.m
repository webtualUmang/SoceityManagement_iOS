//
//  JCDHTTPConnection.m
//  Created by Justin Driscoll on 11/26/11.
//

#import "JCDHTTPConnection.h"


#define TIMEOUT_INTERVAL 60
#define CONTENT_TYPE @"Content-Type"
#define URL_ENCODED @"application/x-www-form-urlencoded"
#define POST @"POST"

@interface JCDHTTPConnection ()

@property (nonatomic, strong) NSMutableURLRequest *request;
@property (nonatomic, strong) NSHTTPURLResponse *response;
@property (nonatomic, strong) NSMutableData *data;
@property (nonatomic, readonly) id body;

@property (nonatomic, copy) OnSuccess onSuccess;
@property (nonatomic, copy) OnFailure onFailure;
@property (nonatomic, copy) OnDidSendData onDidSendData;

@end


@implementation JCDHTTPConnection

//- (id)initWithRequest:(NSURLRequest *)urlRequest
//{
//    self = [super init];
//    if (self) {
//        self.request = urlRequest;
//    }
//    return self;
//}

-(id)initWithUrl:(NSString *)url params:(NSDictionary*)params
{
    
    NSString *postData = [self serializeParams:params];
    //TNMLog(@"Postdata: %@",postData);
    //Temporary Store Request
//    NSLog(@"post data:%@",postData);
    
    NSMutableURLRequest *request = [self getNSMutableURLRequestUsingPOSTMethodWithUrl:url postData:postData];
//    NSLog(@"request data :%@",request);
    
    self.request = request;
    return self;
}

- (id)body
{
    if (self.data != nil) {
        NSError *errorInJsonParsing;
        id json = [NSJSONSerialization JSONObjectWithData:self.data options:0 error:&errorInJsonParsing];
        return json;
    }else{
        return nil;
    }
    
//    return [[NSString alloc] initWithData:self.data encoding:NSUTF8StringEncoding];
}

- (BOOL)executeRequestOnSuccess:(OnSuccess)onSuccessBlock
                        failure:(OnFailure)onFailureBlock
                    didSendData:(OnDidSendData)onDidSendDataBlock
{
    self.onSuccess = onSuccessBlock;
    self.onFailure = onFailureBlock;
    self.onDidSendData = onDidSendDataBlock;
    
//    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:self.request delegate:self];
    return connection != nil;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)aResponse
{
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)aResponse;
    self.response = httpResponse;
    
    self.data = [NSMutableData data];
    [self.data setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)bytes
{
    [self.data appendData:bytes];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
//    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    if (self.onFailure)
        self.onFailure(self.response, self.body, error);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
//    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    if (self.onSuccess)
        self.onSuccess(self.response, self.body);
}

-(NSCachedURLResponse *)connection:(NSURLConnection *)connection
                 willCacheResponse:(NSCachedURLResponse *)cachedResponse
{
    return nil;
}

- (void)connection:(NSURLConnection *)connection didSendBodyData:(NSInteger)bytesWritten
                                               totalBytesWritten:(NSInteger)totalBytesWritten
                                       totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite
{
    if (self.onDidSendData)
        self.onDidSendData(bytesWritten, totalBytesWritten, totalBytesExpectedToWrite);
}


//MARK: Extra
-(NSString *)serializeParams:(NSDictionary *)params {
    
    NSMutableArray* pairs = [NSMutableArray array];
    for (NSString* key in [params keyEnumerator]) {
        id value = [params objectForKey:key];
        if ([value isKindOfClass:[NSDictionary class]]) {
            for (NSString *subKey in value) {
                NSString* escaped_value = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                                                                (CFStringRef)[value objectForKey:subKey],
                                                                                                                NULL,
                                                                                                                (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                                                                kCFStringEncodingUTF8));
                [pairs addObject:[NSString stringWithFormat:@"%@[%@]=%@", key, subKey, escaped_value]];
            }
        } else if ([value isKindOfClass:[NSArray class]]) {
            for (NSString *subValue in value) {
                NSString* escaped_value = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                                                                (CFStringRef)subValue,
                                                                                                                NULL,
                                                                                                                (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                                                                kCFStringEncodingUTF8));
                [pairs addObject:[NSString stringWithFormat:@"%@[]=%@", key, escaped_value]];
            }
        } else {
            NSString* escaped_value = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                                                            (CFStringRef)[params objectForKey:key],
                                                                                                            NULL,
                                                                                                            (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                                                            kCFStringEncodingUTF8));
            [pairs addObject:[NSString stringWithFormat:@"%@=%@", key, escaped_value]];
        }
    }
    return [pairs componentsJoinedByString:@"&"];
}
-(NSMutableURLRequest*)getNSMutableURLRequestUsingPOSTMethodWithUrl:(NSString *)url postData:(NSString*)_postData
{
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:TIMEOUT_INTERVAL];
    [req setHTTPMethod:POST];
    [req addValue:URL_ENCODED forHTTPHeaderField:CONTENT_TYPE];
    [req setHTTPBody:[_postData dataUsingEncoding:NSUTF8StringEncoding]];
    return req;
}
- (NSString *)urlencode:(NSString*)unencodedString {
    NSString *encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
                                                                                  NULL,
                                                                                  (CFStringRef)unencodedString,
                                                                                  NULL,
                                                                                  (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                                  kCFStringEncodingUTF8 ));
    return encodedString;
}

@end
